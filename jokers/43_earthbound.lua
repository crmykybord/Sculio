SMODS.Joker {
  key = 'earthbound',
  attributes = { 'xmult', 'hand_type' },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = { x_mult = 3 } },
  unlocked = true,
  discovered = false,
  rarity = 2,
  atlas = 'Sculio',
  pos = { x = 4, y = 4 },
  cost = 7,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.x_mult } }
  end,

  is_active_owner = function(self, card)
    for _, j in ipairs(G.jokers and G.jokers.cards or {}) do
      if j.config.center.key == 'j_Sculio_earthbound' and not j.debuff then
        return j == card
      end
    end
    return false
  end,

  get_available_hands = function(self, cards)
    local evaluated = evaluate_poker_hand(cards) or {}
    local available = {}
    for hand_name, hand_data in pairs(G.GAME.hands) do
      if hand_data.visible ~= false
          and evaluated[hand_name]
          and next(evaluated[hand_name]) then
        for _, hand_cards in ipairs(evaluated[hand_name]) do
          if hand_cards and #hand_cards > 0 then
            table.insert(available, {
              name = hand_name,
              level = hand_data.level,
              order = hand_data.order or 999,
              cards = hand_cards,
            })
          end
        end
      end
    end
    table.sort(available, function(a, b)
      if a.level ~= b.level then return a.level > b.level end
      return a.order < b.order
    end)
    return available
  end,

  select_and_force = function(self, card)
    if not self:is_active_owner(card) then return end
    if G.playing_cards then
      for _, v in ipairs(G.playing_cards) do
        if v.ability.earthbound_forced then
          v.ability.earthbound_forced = nil
          v.ability.forced_selection = nil
        end
      end
    end
    G.hand:unhighlight_all()
    card.ability.selected_hand = nil

    local best = self:get_available_hands(G.hand.cards)[1]
    if best and best.cards then
      card.ability.selected_hand = best.name
      for _, c in ipairs(best.cards) do
        c.ability.earthbound_forced = card.unique_val
        c.ability.forced_selection = true
        G.hand:add_to_highlighted(c)
      end
      update_hand_text({}, {
        handname = localize(best.name, 'poker_hands'),
        chips = G.GAME.hands[best.name].chips,
        mult = G.GAME.hands[best.name].mult,
        level = G.GAME.hands[best.name].level,
      })
    end
  end,

  -- Re-apply force picks after vanilla would have cleared them.
  reapply_force = function(self, card)
    if not self:is_active_owner(card) then return end
    if G.playing_cards then
      for _, v in ipairs(G.playing_cards) do
        if v.ability.earthbound_forced == card.unique_val then
          v.ability.forced_selection = true
        end
      end
    end
  end,

  add_to_deck = function(self, card, from_debuff)
    if from_debuff then
      self:reapply_force(card)
    elseif G.hand and G.hand.cards and #G.hand.cards > 0 and self:is_active_owner(card) then
      self:select_and_force(card)
    end
  end,

  remove_from_deck = function(self, card, from_debuff)
    if G.playing_cards then
      for _, v in ipairs(G.playing_cards) do
        if v.ability.earthbound_forced == card.unique_val then
          if not from_debuff then v.ability.earthbound_forced = nil end
          v.ability.forced_selection = nil
        end
      end
    end
  end,

  calculate = function(self, card, context)
    if context.hand_drawn then
      self:select_and_force(card)
    elseif context.press_play or context.pre_discard then
      self:reapply_force(card)
    elseif context.joker_main then
      return { xmult = card.ability.extra.x_mult }
    end
  end,
}
