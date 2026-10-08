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
  cost = 2,
  loc_vars = function(self, info_queue, card)
    return { vars = {} }
  end,
  calculate = function(self, card, context)
    if context.end_of_round and context.main_eval and not context.game_over and G.GAME.blind.boss then
      local eff_card = context.blueprint_card or card
      -- Most played hand of the run
      local best, best_count
      for k, v in pairs(G.GAME.hands) do
        if v.visible and (not best_count or v.played > best_count) then
          best, best_count = k, v.played
        end
      end
      if not best then return nil end

      G.E_MANAGER:add_event(Event({
        func = function()
          card_eval_status_text(eff_card, 'extra', nil, nil, nil,
            { message = localize('k_upgrade_ex'), colour = G.C.FILTER })
          return true
        end
      }))
      update_hand_text({ sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3 },
        { handname = localize(best, 'poker_hands'), chips = G.GAME.hands[best].chips,
          mult = G.GAME.hands[best].mult, level = G.GAME.hands[best].level })
      level_up_hand(eff_card, best, false, card.ability.extra.levels)
      update_hand_text({ sound = 'button', volume = 0.7, pitch = 1.1, delay = 0 },
        { mult = 0, chips = 0, handname = '', level = '' })
      return nil
    end
  end
}
