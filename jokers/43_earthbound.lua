SMODS.Joker {
  key = 'earthbound',

  config = { extra = { x_mult = 2 } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Common
  atlas = 'Sculio',
  pos = { x = 4, y = 4 },
  cost = 6,
  blueprint_compat = true,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.x_mult } }
  end,
  get_available_hands = function(self, cards)
    local evaluated_hands = evaluate_poker_hand(cards) or {}
    local available_hands = {}

    for hand, hand_data in pairs(G.GAME.hands) do
      if hand_data.visible and evaluated_hands[hand] and next(evaluated_hands[hand]) then
        table.insert(available_hands, {
          name = hand,
          level = hand_data.level,
          order = hand_data.order or 999,
          cards = evaluated_hands[hand][1]
        })
      end
    end

    table.sort(available_hands, function(a, b)
      if a.level == b.level then
        return a.order < b.order
      end

      return a.level > b.level
    end)

    return available_hands
  end,
  select_highest_hand = function(self, card, cards)
    local available_hands = self:get_available_hands(cards)
    local selected_hand = available_hands[1]

    card.ability.selected_hand = nil

    if selected_hand and selected_hand.cards then
      card.ability.selected_hand = selected_hand.name

      for k, v in ipairs(selected_hand.cards) do
        G.hand:add_to_highlighted(v)
      end

      update_hand_text({}, {handname=localize(selected_hand.name, 'poker_hands'),chips = G.GAME.hands[selected_hand.name].chips, mult = G.GAME.hands[selected_hand.name].mult, level=G.GAME.hands[selected_hand.name].level})
    end
  end,
  calculate = function(self, card, context)
    if context.hand_drawn and not context.blueprint then
      self:select_highest_hand(card, G.hand.cards)
    end

    if context.joker_main and context.scoring_name and card.ability.selected_hand == context.scoring_name then
      return {
        x_mult = card.ability.extra.x_mult,
        message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult } }
      }
    end
  end
}
