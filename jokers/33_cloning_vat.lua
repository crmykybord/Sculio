-- Global state for Cloning Vat
Sculio = Sculio or {}
Sculio.vat_state = Sculio.vat_state or {
  round_analysis = nil,  -- Cached deck analysis
  round_id = nil,        -- Round identifier for cache invalidation
  shop_shim_installed = false
}

-- Constants
-- ponytail: rank/suit tables are rebuilt lazily so suits and ranks added by other mods
-- (registered after us) still count; cache invalidates on buffer size change
local CV_RANK_CACHE = nil

local function cv_get_ranks()
  local n = #SMODS.Rank.obj_buffer
  if CV_RANK_CACHE and CV_RANK_CACHE.n == n then return CV_RANK_CACHE end
  local ids, suffix = {}, {}
  for _, key in ipairs(SMODS.Rank.obj_buffer) do
    local rank = SMODS.Ranks[key]
    ids[#ids + 1] = rank.id
    suffix[rank.id] = rank.card_key
  end
  table.sort(ids)  -- deterministic order (fixes bug where pairs() order caused inconsistent results)
  CV_RANK_CACHE = { n = n, ids = ids, suffix = suffix }
  return CV_RANK_CACHE
end

local function cv_get_suit_prefix(rank_suffix)
  local options = {}
  for _, key in ipairs(SMODS.Suit.obj_buffer) do
    local prefix = SMODS.Suits[key].card_key .. '_'
    if G.P_CARDS[prefix .. rank_suffix] then options[#options + 1] = prefix end
  end
  if #options == 0 then return 'S_' end
  return options[pseudorandom('cv_suit', 1, #options)]
end

-- Unified bonus application: Phase 1 (guaranteed), Phase 2 (probabilistic)
-- guaranteed_type: 'seal', 'edition', 'enhancement', or nil (random between seal/edition)
-- enhancement_center: G.P_CENTERS entry or nil
local function cv_apply_bonuses(card, guaranteed_type, enhancement_center)
  if enhancement_center then card:set_ability(enhancement_center) end

  -- Phase 1: Guaranteed bonus
  local p1 = guaranteed_type
  if not p1 then
    p1 = pseudorandom('cv_phase1', 1, 2) == 1 and 'seal' or 'edition'
  end

  if p1 == 'seal' then
    local seal = SMODS.poll_seal({mod = 1, guaranteed = true})
    if seal then card:set_seal(seal, true, true) end
  elseif p1 == 'edition' then
    local ed = poll_edition('cv_phase1', nil, true, true)
    if ed then card:set_edition(ed, true, true) end
  end
  -- Note: 'enhancement' case is handled by enhancement_center param

  -- Phase 2: Probabilistic bonuses
  if not card.seal then
    local bonus_seal = SMODS.poll_seal({mod = 4})
    if bonus_seal then card:set_seal(bonus_seal, true, true) end
  end
  if not card.edition then
    local bonus_ed = poll_edition('cv_phase2', nil, true)
    if bonus_ed then card:set_edition(bonus_ed, true, true) end
  end
end

-- Internal analysis function - returns best_id, rankless_dominant, best_enh_key
local function cv_analyze_deck_internal()
  local rank_count = {}
  local enh_count = {}
  local rankless_total = 0

  for _, dc in ipairs(G.playing_cards or {}) do
    if dc.base and dc.base.id then
      if SMODS.has_no_rank(dc) then
        rankless_total = rankless_total + 1
        local ek = dc.config and dc.config.center and dc.config.center.key or 'm_stone'
        enh_count[ek] = (enh_count[ek] or 0) + 1
      else
        rank_count[dc.base.id] = (rank_count[dc.base.id] or 0) + 1
      end
    end
  end

  -- Find best rank using DETERMINISTIC order (fixes bug where pairs() order caused inconsistent results)
  local best_id, best_count = nil, 0
  for _, id in ipairs(cv_get_ranks().ids) do
    local count = rank_count[id] or 0
    if count > best_count then
      best_id, best_count = id, count
    end
  end

  -- Rankless is dominant when their count ties or beats the best ranked
  local rankless_dominant = (rankless_total > 0) and (rankless_total >= best_count)

  -- Find most common enhancement among rankless cards
  local best_enh, best_enh_count = nil, 0
  for ek, count in pairs(enh_count) do
    if count > best_enh_count then
      best_enh, best_enh_count = ek, count
    end
  end

  return best_id, rankless_dominant, best_enh
end

-- Cached analysis - computes once per round
local function cv_get_analysis()
  local current_round = G.GAME and G.GAME.round or 0
  if Sculio.vat_state.round_id ~= current_round then
    Sculio.vat_state.round_analysis = cv_analyze_deck_internal()
    Sculio.vat_state.round_id = current_round
  end
  return Sculio.vat_state.round_analysis
end

local function cv_build_rankless_card()
  local _, _, best_enh = cv_get_analysis()
  local suit_prefix = cv_get_suit_prefix('2')
  local front = G.P_CARDS[suit_prefix .. '2'] or G.P_CARDS['S_2']
  local center = (best_enh and G.P_CENTERS[best_enh]) or G.P_CENTERS.m_stone

  if not front then return nil end

  local card = Card(
    G.shop_jokers.T.x + G.shop_jokers.T.w / 2,
    G.shop_jokers.T.y,
    G.CARD_W, G.CARD_H,
    front, center,
    {bypass_discovery_center = true, bypass_discovery_ui = true}
  )
  card.Sculio_vat_card = true

  -- For rankless: enhancement is already set via center; guarantee seal OR edition
  cv_apply_bonuses(card, nil, nil)

  create_shop_card_ui(card)
  card:start_materialize()
  return card
end

-- Returns guaranteed_type, enhancement_center for ranked cards
local function cv_pick_guaranteed_bonus()
  local enhs = {}
  for k, v in pairs(G.P_CENTERS) do
    if v.set == 'Enhanced' then enhs[#enhs + 1] = k end
  end

  if #enhs > 0 then
    local pool = {'seal', 'edition', 'enhancement'}
    local choice = pool[pseudorandom('cv_ensure', 1, #pool)]
    if choice == 'enhancement' then
      return 'edition', G.P_CENTERS[enhs[pseudorandom('cv_enh', 1, #enhs)]]
    else
      return choice, G.P_CENTERS.c_base
    end
  end
  return (pseudorandom('cv_ensure', 1, 2) == 1 and 'seal' or 'edition'), G.P_CENTERS.c_base
end

local function cv_build_ranked_card()
  local best_id, _, _ = cv_get_analysis()
  if not best_id then return nil end

  local rank_suffix = cv_get_ranks().suffix[best_id]
  if not rank_suffix then return nil end
  local suit_prefix = cv_get_suit_prefix(rank_suffix)
  local front = G.P_CARDS[suit_prefix .. rank_suffix]
  if not front then return nil end

  local guaranteed_type, center = cv_pick_guaranteed_bonus()

  local card = Card(
    G.shop_jokers.T.x + G.shop_jokers.T.w / 2,
    G.shop_jokers.T.y,
    G.CARD_W, G.CARD_H,
    front, center,
    {bypass_discovery_center = true, bypass_discovery_ui = true}
  )
  card.Sculio_vat_card = true

  cv_apply_bonuses(card, guaranteed_type, nil)

  create_shop_card_ui(card)
  card:start_materialize()
  return card
end

local function cv_build_vat_card()
  if not G.shop_jokers then return nil end

  local _, rankless_dominant = cv_get_analysis()

  if rankless_dominant then
    return cv_build_rankless_card()
  else
    return cv_build_ranked_card()
  end
end

-- Count active (non-debuffed) Vats
local function cv_count_active_vats()
  local count = 0
  for _, jc in ipairs(G.jokers and G.jokers.cards or {}) do
    if jc.config and jc.config.center and jc.config.center.key == 'j_Sculio_cloning_vat' and not jc.debuff then
      count = count + 1
    end
  end
  return count
end

-- Installs the create_card_for_shop shim lazily
local function cv_install_shim()
  if Sculio.vat_state.shop_shim_installed then return end
  if type(create_card_for_shop) ~= 'function' then return end
  Sculio.vat_state.shop_shim_installed = true

  local _orig = create_card_for_shop
  function create_card_for_shop(area)
    if area ~= G.shop_jokers then return _orig(area) end

    local vat_count = cv_count_active_vats()
    if vat_count == 0 then return _orig(area) end

    -- Calls beyond the base slots are for the vat slot(s)
    local base_max = (G.GAME.shop and G.GAME.shop.joker_max or 2) - vat_count
    local normal_count = 0
    for _, sc in ipairs(G.shop_jokers.cards) do
      if not sc.Sculio_vat_card then normal_count = normal_count + 1 end
    end

    if normal_count >= base_max then
      return cv_build_vat_card()
    end
    return _orig(area)
  end
end

-- Apply Vat bonuses to a Standard Pack card
local function cv_apply_to_booster_card(card)
  local best_id, rankless_dominant, best_enh = cv_get_analysis()

  if rankless_dominant then
    local enh_center = (best_enh and G.P_CENTERS[best_enh]) or G.P_CENTERS.m_stone
    card:set_ability(enh_center)
    cv_apply_bonuses(card, nil, nil)
  elseif best_id then
    local rank_suffix = cv_get_ranks().suffix[best_id]
    if not rank_suffix then return end
    local suit_prefix = cv_get_suit_prefix(rank_suffix)
    local front = G.P_CARDS[suit_prefix .. rank_suffix]
    if front then card:set_base(front) end

    local guaranteed_type, enh_center = cv_pick_guaranteed_bonus()
    if enh_center and enh_center ~= G.P_CENTERS.c_base then
      card:set_ability(enh_center)
    end

    cv_apply_bonuses(card, guaranteed_type, nil)
  end
end

SMODS.Joker {
  key = 'cloning_vat',
  attributes = { 'generation', 'modify_card', 'enhancements', 'seals', 'editions' },
  unlocked = true,
  discovered = false,
  rarity = 3, -- Rare
  atlas = 'Sculio',
  pos = { x = 4, y = 3 },
  cost = 10,
  eternal_compat = true,
  perishable_compat = true,
  rental_compat = true,
  blueprint_compat = false,
  calculate = function(self, card, context)
    if context.blueprint then return end
    if card.debuff then return end  -- Does not work when debuffed

    cv_install_shim()

    if context.modify_booster_card and context.booster and context.card then
      local booster_name = context.booster.ability and context.booster.ability.name or ''
      if string.find(booster_name, 'Standard') and context.card.base and context.card.base.id then
        cv_apply_to_booster_card(context.card)
      end
    end
  end,

  add_to_deck = function(self, card, from_debuff)
    cv_install_shim()
    if card.Sculio_vat_slot_added then return end
    card.Sculio_vat_slot_added = true
    if G.GAME.shop then
      change_shop_size(1)
    end
  end,

  remove_from_deck = function(self, card, from_debuff)
    if not card.Sculio_vat_slot_added then return end
    card.Sculio_vat_slot_added = nil
    if not G.GAME.shop then return end
    if G.shop_jokers and G.shop_jokers.cards then
      for i = #G.shop_jokers.cards, 1, -1 do
        if G.shop_jokers.cards[i].Sculio_vat_card then
          G.shop_jokers.cards[i]:remove()
          table.remove(G.shop_jokers.cards, i)
          break
        end
      end
    end
    change_shop_size(-1)
  end
}
