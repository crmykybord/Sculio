SMODS.Joker {
  key = 'computer_virus',
  attributes = { 'boss_blind', 'destruction' },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = {} },
  unlocked = true,
  discovered = false,
  rarity = 3,
  atlas = 'Sculio',
  pos = { x = 7, y = 5 },
  cost = 8,
  loc_vars = function(self, info_queue, card)
    return { vars = {} }
  end,
  calculate = function(self, card, context)
    if context.blind_defeated and not context.blueprint and #G.jokers.cards > 1 then
      local rightmost_joker = G.jokers.cards[#G.jokers.cards]
      if rightmost_joker and rightmost_joker ~= card then
        G.E_MANAGER:add_event(Event({
          func = function()
            play_sound('tarot1')
            rightmost_joker.T.r = -0.2
            rightmost_joker:juice_up(0.3, 0.4)
            rightmost_joker.children.center.pinch.x = true
            G.E_MANAGER:add_event(Event({
              trigger = 'after',
              delay = 0.3,
              blockable = false,
              func = function()
                G.jokers:remove_card(rightmost_joker)
                rightmost_joker:remove()
                rightmost_joker = nil
                return true
              end
            }))
            return true
          end
        }))

        G.E_MANAGER:add_event(Event({
          trigger = 'after',
          delay = 0.5,
          func = function()
            local new_joker = SMODS.create_card({
              set = 'Joker',
              rarity = 1,
              major = false,
              no_soul = true
            })
            local edition = pseudorandom('computer_virus_edition') < 0.5 and 'Negative' or 'Polychrome'
            new_joker:set_edition(edition, true)
            new_joker.no_sell_value = true
            G.jokers:emplace(new_joker)
            return true
          end
        }))
      end
    end
  end
}
