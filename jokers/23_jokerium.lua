SMODS.Joker {
  key = 'jokerium',

  config = { extra = { levels = 1 } },
  unlocked = true,
  discovered = false,
  rarity = 3, -- Rare
  atlas = 'Sculio',
  pos = { x = 4, y = 2 },
  cost = 7,
  blueprint_compat = true,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.levels } }
  end,
  calculate = function(self, card, context)
    if context.end_of_round and context.main_eval and not context.game_over and G.GAME.blind.boss then
      local eff_card = context.blueprint_card or card
      G.E_MANAGER:add_event(Event({
        func = function()
          card_eval_status_text(eff_card, 'extra', nil, nil, nil,
            { message = localize('k_upgrade_ex'), colour = G.C.FILTER })
          return true
        end
      }))
      G.E_MANAGER:add_event(Event({
        trigger = 'after',
        func = function()
          update_hand_text({ sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3 },
            { handname = localize('k_all_hands'), chips = '...', mult = '...', level = '' })
          G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
              play_sound('tarot1')
              eff_card:juice_up(0.8, 0.5)
              G.TAROT_INTERRUPT_PULSE = true
              return true
            end
          }))
          update_hand_text({ delay = 0 }, { mult = '+', StatusText = true })
          G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.9,
            func = function()
              play_sound('tarot1')
              eff_card:juice_up(0.8, 0.5)
              return true
            end
          }))
          update_hand_text({ delay = 0 }, { chips = '+', StatusText = true })
          G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.3,
            func = function()
              play_sound('tarot1')
              eff_card:juice_up(0.8, 0.5)
              G.TAROT_INTERRUPT_PULSE = nil
              return true
            end
          }))
          update_hand_text({ sound = 'button', volume = 0.7, pitch = 0.9, delay = 0 }, { level = '+' .. card.ability.extra.levels })
          delay(1.3)
          for k, v in pairs(G.GAME.hands) do
            for i = 1, card.ability.extra.levels, 1 do
              level_up_hand(eff_card, k, true)
            end
          end
          update_hand_text({ sound = 'button', volume = 0.7, pitch = 1.1, delay = 0 },
            { mult = 0, chips = 0, handname = '', level = '' })
          return true
        end
      }))

      return
    end
  end
}
