SMODS.Enhancement {
  key = 'wandering',
  atlas = 'Sculio_Enhancements',
  pos = { x = 4, y = 0 },

  config = {},
  loc_vars = function(self, info_queue, card)
    return { vars = { 1 } }
  end,
  calculate = function(self, card, context)
    -- Like The Hook: when a hand is played, leftover Wandering Cards
    -- discard themselves and permanently gain +1 Mult.
    if context.press_play and context.cardarea == G.hand and not card.highlighted and not context.blueprint then
      card.ability.perma_mult = (card.ability.perma_mult or 0) + 1
      G.E_MANAGER:add_event(Event({ func = function()
        play_sound('card1', 1)
        G.hand:add_to_highlighted(card, true)
        G.FUNCS.discard_cards_from_highlighted(nil, true)
        return true
      end }))
      return { message = localize('k_upgrade_ex'), colour = G.C.MULT }
    end
  end,
}
