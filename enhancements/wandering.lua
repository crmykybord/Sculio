SMODS.Enhancement {
  key = 'wandering',
  atlas = 'centers',
  pos = { x = 2, y = 1 },
  prefix_config = { atlas = false },

  config = {},
  loc_vars = function(self, info_queue, card)
    return { vars = { 1 } }
  end,
  calculate = function(self, card, context)
    -- Like The Hook: when a hand is played, leftover Wandering Cards
    -- discard themselves and permanently gain +1 Mult.
    -- (ante, hands_left) uniquely identifies a hand within a run.
    if context.before and context.cardarea == G.hand and not context.blueprint then
      local hand_id = tostring(G.GAME.round_resets.ante) .. ':' .. (G.GAME.current_round.hands_left or 0)
      if card.Sculio_wandering_hand_id ~= hand_id then
        card.Sculio_wandering_hand_id = hand_id
        card.ability.perma_mult = (card.ability.perma_mult or 0) + 1
        G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.25, func = function()
          play_sound('card1', 1)
          card.ability.discarded = true
          draw_card(G.hand, G.discard, 100, 'down', false, card)
          return true
        end }))
        return { message = localize('k_upgrade_ex'), colour = G.C.MULT }
      end
    end
  end,
}
