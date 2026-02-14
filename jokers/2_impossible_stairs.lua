SMODS.Joker {
  key = 'impossible_stairs',

  config = { extra = { mult = 5, mult_add_min = -2, mult_add_max = 2, mult_min = 0 } },
  unlocked = true,
  discovered = false,
  rarity = 1, -- Common
  atlas = 'Sculio',
  pos = { x = 1, y = 0 },
  cost = 3,
  eternal_compat = false,
  perishable_compat = false,
  blueprint_compat = true,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.mult, card.ability.extra.mult_add_min, card.ability.extra.mult_add_max, card.ability.extra.mult_min } }
  end,
  calculate = function(self, card, context)
    if context.before and not context.blueprint then
      local add = pseudorandom('impossible_stairs', card.ability.extra.mult_add_min, card.ability.extra.mult_add_max)
      card.ability.extra.mult = card.ability.extra.mult + add

      if card.ability.extra.mult <= card.ability.extra.mult_min then
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
      end

      if add >= 0 then
        return {
          message = localize{type='variable', key='a_mult', vars={add}},
          colour = G.C.MULT
        }
      else
        return {
          message = localize{type='variable', key='a_mult_minus', vars={math.abs(add)}},
          colour = G.C.MULT
        }
      end
    end

    if context.joker_main then
      return {
        mult_mod = card.ability.extra.mult,
        message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
      }
    end
  end
}
