SMODS.Joker {
  key = 'jokerium',

  config = { extra = { levels = 1 } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 4, y = 2 },
  cost = 7,
  blueprint_compat = true,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.levels } }
  end,
  calculate = function(self, card, context)
    if context.end_of_round and not context.repetition and context.game_over == false and G.GAME.blind.boss then
      for hand, hand_data in pairs(G.GAME.hands) do
        if hand_data.visible then
          for i = 1, card.ability.extra.levels, 1 do
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(hand, 'poker_hands'),chips = hand_data.chips, mult = hand_data.mult, level=hand_data.level})
            level_up_hand(context.blueprint_card or card, hand, nil, 1)
          end
        end
      end

      return {
        message = localize('k_upgrade_ex'),
        colour = G.C.FILTER
      }
    end
  end
}
