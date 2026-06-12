-- Shim: SMODS object_weights shop polling can produce card_args = {type='Enhanced'/'Base'}
-- with no key and no set (poll_object returns nil for playing card types). SMODS.create_card
-- then calls create_card(nil, ...) and crashes in poll_object. Map type -> set as fallback.
if not Sculio_create_card_shim then
  Sculio_create_card_shim = true
  local scc_ref = SMODS.create_card
  function SMODS.create_card(t)
    if not t.set and not t.key and (t.type == 'Base' or t.type == 'Enhanced') then
      t.set = t.type
    end
    return scc_ref(t)
  end
end

-- Returns best_id, rankless_dominant, best_enh_key
-- best_id:           most common rank id among ranked cards (nil if none)
-- rankless_dominant: true when rankless count >= best ranked count (rankless is the "most common")
-- best_enh_key:      most common enhancement key among rankless cards
function Sculio_vat_deck_analysis()
  local rank_count = {}
  local enh_count  = {}
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

  local best_id, best_count = nil, 0
  for id, count in pairs(rank_count) do
    if count > best_count then best_id = id; best_count = count end
  end

  -- Rankless is dominant when their count ties or beats the best ranked
  local rankless_dominant = (rankless_total > 0) and (rankless_total >= best_count)

  local best_enh, best_enh_count = nil, 0
  for ek, count in pairs(enh_count) do
    if count > best_enh_count then best_enh = ek; best_enh_count = count end
  end

  return best_id, rankless_dominant, best_enh
end

-- Build the cloned playing card for the shop (no emplace — caller decides).
function Sculio_vat_build_card()
  if not G.shop_jokers then return nil end

  local best_id, rankless_dominant, best_enh = Sculio_vat_deck_analysis()

  local front, center

  if rankless_dominant then
    -- Rankless most common: use most common enhancement, random suit
    local suits = {'S_', 'H_', 'C_', 'D_'}
    local suit_prefix = suits[pseudorandom('cloning_vat_suit', 1, #suits)]
    front = G.P_CARDS[suit_prefix .. '2'] or G.P_CARDS['S_2']
    center = (best_enh and G.P_CENTERS[best_enh]) or G.P_CENTERS.m_stone
    if not front then return nil end

    local card = Card(
      G.shop_jokers.T.x + G.shop_jokers.T.w / 2,
      G.shop_jokers.T.y,
      G.CARD_W, G.CARD_H,
      front, center,
      {bypass_discovery_center = true, bypass_discovery_ui = true}
    )
    card.Sculio_vat_card = true
    -- Enhancement is guaranteed via center; phase 1: guarantee seal OR edition too
    local p1 = pseudorandom('cloning_vat_ensure', 1, 2) == 1 and 'seal' or 'edition'
    if p1 == 'seal' then
      local seal = SMODS.poll_seal({mod = 1, guaranteed = true})
      if seal then card:set_seal(seal, true, true) end
    else
      local ed = poll_edition('cloning_vat_ensure', nil, true, true)
      if ed then card:set_edition(ed, true, true) end
    end
    -- Phase 2: probabilistic for the other
    if not card.seal then
      local bonus_seal = SMODS.poll_seal({mod = 4})
      if bonus_seal then card:set_seal(bonus_seal, true, true) end
    end
    if not card.edition then
      local bonus_ed = poll_edition('cloning_vat_bonus', nil, true)
      if bonus_ed then card:set_edition(bonus_ed, true, true) end
    end
    create_shop_card_ui(card)
    card:start_materialize()
    return card
  end

  if not best_id then return nil end

  local rank_suffix = best_id < 10 and tostring(best_id) or
    best_id == 10 and 'T' or best_id == 11 and 'J' or
    best_id == 12 and 'Q' or best_id == 13 and 'K' or 'A'

  local suits = {'S_', 'H_', 'C_', 'D_'}
  local suit_prefix = suits[pseudorandom('cloning_vat_suit', 1, #suits)]
  front = G.P_CARDS[suit_prefix .. rank_suffix]
  if not front then return nil end

  center = G.P_CENTERS.c_base
  local enhs = {}
  for k, v in pairs(G.P_CENTERS) do
    if v.set == 'Enhanced' then enhs[#enhs+1] = k end
  end

  -- Phase 1: guarantee one of seal/edition/enhancement
  local pool = {'seal', 'edition'}
  if #enhs > 0 then pool[#pool+1] = 'enhancement' end
  local p1 = pool[pseudorandom('cloning_vat_ensure', 1, #pool)]
  if p1 == 'enhancement' then
    center = G.P_CENTERS[enhs[pseudorandom('cloning_vat_ensure_enh', 1, #enhs)]]
  end

  local card = Card(
    G.shop_jokers.T.x + G.shop_jokers.T.w / 2,
    G.shop_jokers.T.y,
    G.CARD_W, G.CARD_H,
    front, center,
    {bypass_discovery_center = true, bypass_discovery_ui = true}
  )
  card.Sculio_vat_card = true

  if p1 == 'seal' then
    local seal = SMODS.poll_seal({mod = 1, guaranteed = true})
    if seal then card:set_seal(seal, true, true) end
  elseif p1 == 'edition' then
    local ed = poll_edition('cloning_vat_ensure', nil, true, true)
    if ed then card:set_edition(ed, true, true) end
  end
  -- Phase 2: probabilistic extras
  if not card.seal then
    local bonus_seal = SMODS.poll_seal({mod = 4})
    if bonus_seal then card:set_seal(bonus_seal, true, true) end
  end
  if not card.edition then
    local bonus_ed = poll_edition('cloning_vat_bonus', nil, true)
    if bonus_ed then card:set_edition(bonus_ed, true, true) end
  end

  create_shop_card_ui(card)
  card:start_materialize()
  return card
end

-- Installs the create_card_for_shop shim lazily (called from add_to_deck,
-- by which point the game is fully loaded and the function exists globally).
function Sculio_vat_install_shim()
  if Sculio_vat_shop_shim then return end
  if type(create_card_for_shop) ~= 'function' then return end
  Sculio_vat_shop_shim = true
  local _orig = create_card_for_shop
  function create_card_for_shop(area)
    if area ~= G.shop_jokers then return _orig(area) end
    local vat_count = 0
    for _, jc in ipairs(G.jokers and G.jokers.cards or {}) do
      if jc.config and jc.config.center and jc.config.center.key == 'j_Sculio_cloning_vat' then
        vat_count = vat_count + 1
      end
    end
    if vat_count == 0 then return _orig(area) end
    -- Calls beyond the base slots are for the vat slot(s)
    local base_max = (G.GAME.shop and G.GAME.shop.joker_max or 2) - vat_count
    local normal_count = 0
    for _, sc in ipairs(G.shop_jokers.cards) do
      if not sc.Sculio_vat_card then normal_count = normal_count + 1 end
    end
    if normal_count >= base_max then
      return Sculio_vat_build_card()
    end
    return _orig(area)
  end
end

SMODS.Joker {
  key = 'cloning_vat',

  unlocked = true,
  discovered = false,
  rarity = 3, -- Rare
  atlas = 'Sculio',
  pos = { x = 4, y = 3 },
  cost = 10,
  calculate = function(self, card, context)
    if context.blueprint then return end
    Sculio_vat_install_shim()

    -- Standard Pack: apply most-common rank + guaranteed bonus to each card
    if context.modify_booster_card and context.booster and context.card then
      local booster_name = context.booster.ability and context.booster.ability.name or ''
      if string.find(booster_name, 'Standard') and context.card.base and context.card.base.id then
        local c = context.card
        local best_id, rankless_dominant, best_enh = Sculio_vat_deck_analysis()

        if rankless_dominant then
          local enh_center = (best_enh and G.P_CENTERS[best_enh]) or G.P_CENTERS.m_stone
          c:set_ability(enh_center)
          local p1 = pseudorandom('cloning_vat_ensure', 1, 2) == 1 and 'seal' or 'edition'
          if p1 == 'seal' then
            local seal = SMODS.poll_seal({mod = 1, guaranteed = true})
            if seal then c:set_seal(seal, true, true) end
          else
            local ed = poll_edition('cloning_vat_ensure', nil, true, true)
            if ed then c:set_edition(ed, true, true) end
          end
          if not c.seal then
            local bonus_seal = SMODS.poll_seal({mod = 4})
            if bonus_seal then c:set_seal(bonus_seal, true, true) end
          end
          if not c.edition then
            local bonus_ed = poll_edition('cloning_vat_bonus', nil, true)
            if bonus_ed then c:set_edition(bonus_ed, true, true) end
          end
        elseif best_id then
          local rank_suffix = best_id < 10 and tostring(best_id) or
            best_id == 10 and 'T' or best_id == 11 and 'J' or
            best_id == 12 and 'Q' or best_id == 13 and 'K' or 'A'
          local suits = {'S_', 'H_', 'C_', 'D_'}
          local suit_prefix = suits[pseudorandom('cloning_vat_suit', 1, #suits)]
          local front = G.P_CARDS[suit_prefix .. rank_suffix]
          if front then c:set_base(front) end

          local enhs = {}
          for k, v in pairs(G.P_CENTERS) do
            if v.set == 'Enhanced' then enhs[#enhs+1] = k end
          end
          local pool = {'seal', 'edition'}
          if #enhs > 0 then pool[#pool+1] = 'enhancement' end
          local p1 = pool[pseudorandom('cloning_vat_ensure', 1, #pool)]
          if p1 == 'seal' then
            local seal = SMODS.poll_seal({mod = 1, guaranteed = true})
            if seal then c:set_seal(seal, true, true) end
          elseif p1 == 'edition' then
            local ed = poll_edition('cloning_vat_ensure', nil, true, true)
            if ed then c:set_edition(ed, true, true) end
          elseif #enhs > 0 then
            c:set_ability(G.P_CENTERS[enhs[pseudorandom('cloning_vat_ensure_enh', 1, #enhs)]])
          end
          if not c.seal then
            local bonus_seal = SMODS.poll_seal({mod = 4})
            if bonus_seal then c:set_seal(bonus_seal, true, true) end
          end
          if not c.edition then
            local bonus_ed = poll_edition('cloning_vat_bonus', nil, true)
            if bonus_ed then c:set_edition(bonus_ed, true, true) end
          end
        end
      end
    end
  end,

  add_to_deck = function(self, card, from_debuff)
    Sculio_vat_install_shim()
    if G.GAME.shop then
      -- change_shop_size handles joker_max, card_limit, area width, recalculate
      -- and calls create_card_for_shop to fill the new slot (intercepted by shim)
      change_shop_size(1)
    end
  end,

  remove_from_deck = function(self, card, from_debuff)
    local others = 0
    for _, v in ipairs(G.jokers and G.jokers.cards or {}) do
      if v ~= card and v.config.center.key == card.config.center.key then
        others = others + 1
      end
    end
    if others == 0 and G.GAME.shop then
      -- Remove the vat card first so change_shop_size doesn't remove a random card
      if G.shop_jokers then
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
  end
}
