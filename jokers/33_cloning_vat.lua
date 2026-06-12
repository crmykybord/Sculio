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

    -- Helper: get most common rank suffix from current deck (excluding card c)
    local function get_best_rank_suffix(c)
      local rank_count = {}
      for _, dc in ipairs(G.playing_cards) do
        if dc ~= c and dc.base and dc.base.id then
          rank_count[dc.base.id] = (rank_count[dc.base.id] or 0) + 1
        end
      end
      local best_id, best_count = nil, 0
      for id, count in pairs(rank_count) do
        if count > best_count then best_id = id; best_count = count end
      end
      if not best_id then return nil end
      return best_id < 10 and tostring(best_id) or
        best_id == 10 and 'T' or best_id == 11 and 'J' or
        best_id == 12 and 'Q' or best_id == 13 and 'K' or 'A'
    end

    -- Helper: apply rank + random seal/edition to a card
    local function vat_card(c)
      if not (c and c.base and c.base.id) then return false end
      local rank_suffix = get_best_rank_suffix(c)
      if not rank_suffix then return false end

      local suits = {'S_', 'H_', 'C_', 'D_'}
      local suit_prefix = suits[pseudorandom('cloning_vat_suit', 1, #suits)]
      local front = G.P_CARDS[suit_prefix .. rank_suffix]
      if front then c:set_base(front) end

      local seals = {'Gold', 'Red', 'Blue', 'Purple'}
      local editions = {'e_foil', 'e_holo', 'e_polychrome'}
      if not c.seal and pseudorandom('cloning_vat_seal') > 0.85 then
        c:set_seal(seals[pseudorandom('cloning_vat_seal_pick', 1, #seals)], true, true)
      end
      if not c.edition and pseudorandom('cloning_vat_edition') > 0.95 then
        c:set_edition(editions[pseudorandom('cloning_vat_edition_pick', 1, #editions)], true, true)
      end
      return true
    end

    -- Standard Pack: transform each card as it is generated (before display)
    if context.modify_booster_card and context.booster and context.card then
      local booster_name = context.booster.ability and context.booster.ability.name or ''
      if string.find(booster_name, 'Standard') and context.card.base and context.card.base.id then
        vat_card(context.card)
      end
    end

    -- Shop playing cards at generation time (covers Base and Enhanced/Illusion cards)
    if context.modify_shop_card and context.card then
      local c = context.card
      if c.base and c.base.id and
         c.config and c.config.center and
         (c.config.center.set == 'Default' or c.config.center.set == 'Enhanced') then
        vat_card(c)
      end
    end
  end,

  -- Magic Trick effect: playing cards appear in shop while this joker is owned
  add_to_deck = function(self, card, from_debuff)
    G.GAME.cloning_vat_prev_pcr = G.GAME.cloning_vat_prev_pcr or G.GAME.playing_card_rate or 0
    G.GAME.playing_card_rate = math.max(G.GAME.playing_card_rate or 0, 4)
  end,

  remove_from_deck = function(self, card, from_debuff)
    local others = 0
    for _, v in ipairs(G.jokers and G.jokers.cards or {}) do
      if v ~= card and v.config.center.key == card.config.center.key then
        others = others + 1
      end
    end
    if others == 0 and not (G.GAME.used_vouchers and
        (G.GAME.used_vouchers.v_magic_trick or G.GAME.used_vouchers.v_illusion)) then
      G.GAME.playing_card_rate = G.GAME.cloning_vat_prev_pcr or 0
      G.GAME.cloning_vat_prev_pcr = nil
    end
  end
}
