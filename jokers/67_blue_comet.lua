SMODS.Joker {
  key = 'blue_comet',
  attributes = { 'boss_blind', 'planet' },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = { levels = 1 } },
  unlocked = true,
  discovered = false,
  rarity = 1, -- Common
  atlas = 'Sculio',
  pos = { x = 8, y = 6 },
  cost = 4,
  loc_vars = function(self, info_queue, card)
    return { vars = {} }
  end,
  calculate = function(self, card, context)
    if context.blind_defeated and G.GAME.blind.boss then
      local eff_card = context.blueprint_card or card
      G.E_MANAGER:add_event(Event({
        func = function()
          -- Most played hand of the run (visible hands only, first max wins)
          local best, best_count
          for k, v in pairs(G.GAME.hands) do
            if v.visible and (not best_count or v.played > best_count) then
              best, best_count = k, v.played
            end
          end
          if not best then return true end

          card_eval_status_text(eff_card, 'extra', nil, nil, nil,
            { message = localize('k_upgrade_ex'), colour = G.C.FILTER })
          return true
        end
      }))
      G.E_MANAGER:add_event(Event({
        trigger = 'after',
        func = function()
          local best, best_count
          for k, v in pairs(G.GAME.hands) do
            if v.visible and (not best_count or v.played > best_count) then
              best, best_count = k, v.played
            end
          end
          if not best then return true end

          update_hand_text({ sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3 },
            { handname = localize(best, 'poker_hands'), chips = G.GAME.hands[best].chips,
              mult = G.GAME.hands[best].mult, level = G.GAME.hands[best].level })
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
          update_hand_text({ delay = 0 }, { level = '+' .. card.ability.extra.levels })
          delay(0.6)
          G.TAROT_INTERRUPT_PULSE = nil
          for i = 1, card.ability.extra.levels, 1 do
            level_up_hand(eff_card, best, true)
          end
          update_hand_text({ sound = 'button', volume = 0.7, pitch = 1.1, delay = 0 },
            { mult = 0, chips = 0, handname = '', level = '' })
          return true
        end
      }))
      return nil
    end
  end
}
