SMODS.Joker {
  key = 'ecg',
  attributes = { 'passive', 'hands', 'discards' },
  eternal_compat = true,
  blueprint_compat = false,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = { used = false } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 8, y = 4 },
  cost = 5,
  calculate = function(self, card, context)
    if context.setting_blind and not context.blueprint then
      card.ability.extra.used = false
    end
    -- The Play Hand decrement already ran (ease_hands_played fires before
    -- Blind:press_play), so hands_left == 0 means this is the last hand.
    -- Refilling here lands before evaluate_play's game-over check.
    if context.press_play and not context.blueprint
        and not card.ability.extra.used and G.GAME.current_round.hands_left == 0 then
      card.ability.extra.used = true
      G.E_MANAGER:add_event(Event({
        func = function()
          ease_hands_played(1)
          ease_discard(1)
          card_eval_status_text(card, 'extra', nil, nil, nil,
            { message = localize { type = 'variable', key = 'a_hands', vars = { 1 } }, colour = G.C.BLUE })
          return true
        end
      }))
      G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.3,
        func = function()
          card_eval_status_text(card, 'extra', nil, nil, nil,
            { message = localize('k_Sculio_ecg_discard'), colour = G.C.RED })
          return true
        end
      }))
    end
  end
}
