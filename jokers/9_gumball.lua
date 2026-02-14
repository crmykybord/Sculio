SMODS.Joker {
  key = 'gumball',

  config = { extra = { mult = 3, mult_add_open = 2, mult_add_skip = -4, mult_min = 0 } },
  unlocked = true,
  discovered = false,
  rarity = 1, -- Common
  atlas = 'Sculio',
  pos = { x = 8, y = 0 },
  cost = 4,
  eternal_compat = false,
  blueprint_compat = true,
  perishable_compat = false,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.mult, card.ability.extra.mult_add_open, card.ability.extra.mult_add_skip, card.ability.extra.mult_min } }
  end,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        mult_mod = card.ability.extra.mult,
        message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
      }
    end

    if not context.blueprint then
      if context.open_booster then
        card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_add_open

        G.E_MANAGER:add_event(Event({
          func = function()
            card_eval_status_text(card, 'extra', nil, nil, nil, {
              message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult_add_open } },
              colour = G.C.RED,
              delay = 0.45
            })

            return true
          end
        }))
      end

      if context.skipping_booster then
        card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_add_skip

        G.E_MANAGER:add_event(Event({
          func = function()
            card_eval_status_text(card, 'extra', nil, nil, nil, {
              message = localize { type = 'variable', key = 'a_mult_minus', vars = { math.abs(card.ability.extra.mult_add_skip) } },
              colour = G.C.RED,
              delay = 0.45
            })

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

            return true
          end
        }))
      end
    end
  end
}
