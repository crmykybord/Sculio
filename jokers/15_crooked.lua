SMODS.Joker {
  key = 'crooked',

  config = { extra = { hand_size_bonus = 3, steal = 3, money_min = 0 } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 4, y = 1 },
  cost = 7,
  eternal_compat = false,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.hand_size_bonus, card.ability.extra.steal, card.ability.extra.money_min } }
  end,
  add_to_deck = function(self, card, from_debuff)
    G.hand:change_size(card.ability.extra.hand_size_bonus)
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.hand:change_size(-card.ability.extra.hand_size_bonus)
  end,
  calculate = function(self, card, context)
    if context.end_of_round and not context.repetition and context.game_over == false and not context.blueprint then
      ease_dollars(-card.ability.extra.steal)

      if to_big(G.GAME.dollars - card.ability.extra.steal) <= to_big(card.ability.extra.money_min) then
        -- Delete Joker. Based off of Ice Cream.
        G.E_MANAGER:add_event(Event({
          func = function()
            play_sound('tarot1')
            card.T.r = -0.2
            card:juice_up(0.3, 0.4)
            card.states.drag.is = true
            card.children.center.pinch.x = true

            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
              func = function()
                G.jokers:remove_card(card)
                card:remove()
                card = nil
                return true
              end
            }))

            return true
          end
        }))

        return {
          message = 'Stole $' .. card.ability.extra.steal .. ', bailed!',
          colour = G.C.FILTER
        }
      else
        return {
          message = 'Stole $' .. card.ability.extra.steal,
          colour = G.C.FILTER
        }
      end
    end
  end
}
