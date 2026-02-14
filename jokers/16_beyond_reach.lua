SMODS.Joker {
  key = 'beyond_reach',

  config = { extra = { hands_gain = 1, required_score_percentage = 85 } },
  unlocked = true,
  discovered = false,
  rarity = 3, -- Rare
  atlas = 'Sculio',
  pos = { x = 5, y = 1 },
  cost = 9,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.hands_gain, card.ability.extra.required_score_percentage } }
  end,
  calculate = function(self, card, context)
    if context.end_of_round and context.game_over and to_big(G.GAME.chips / G.GAME.blind.chips) >= to_big(card.ability.extra.required_score_percentage / 100) and not context.blueprint then
      G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands_gain

      G.E_MANAGER:add_event(Event({
        func = function()
          G.hand_text_area.blind_chips:juice_up()
          G.hand_text_area.game_chips:juice_up()
          play_sound('tarot1')
          card:start_dissolve()
          return true
        end
      }))

      return {
        message = '+1 Hand',
        saved = true
      }
    end
  end
}
