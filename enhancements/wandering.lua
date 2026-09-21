SMODS.Enhancement {
  key = 'wandering',
  atlas = 'Sculio_Enhancements',
  pos = { x = 4, y = 0 },

  config = {},
  loc_vars = function(self, info_queue, card)
    return { vars = { Sculio.distorted() and 3 or 1 } }
  end,
  calculate = function(self, card, context)
    -- Like The Hook: when a hand is played, leftover Wandering Cards
    -- discard themselves and permanently gain Mult.
    if context.press_play and context.cardarea == G.hand and not card.highlighted and not context.blueprint then
      local per = Sculio.distorted() and 3 or 1
      card.ability.perma_mult = (card.ability.perma_mult or 0) + per
      G.E_MANAGER:add_event(Event({ func = function()
        play_sound('card1', 1)
        card.ability.Sculio_wandering_self = true
        G.hand:add_to_highlighted(card, true)
        G.FUNCS.discard_cards_from_highlighted(nil, true)
        card.ability.Sculio_wandering_self = nil
        return true
      end }))
      return { message = localize('k_upgrade_ex'), colour = G.C.MULT }
    end
    -- Also gains Mult when the player discards it from hand
    if context.discard and context.other_card == card and not card.ability.Sculio_wandering_self then
      local per = Sculio.distorted() and 3 or 1
      card.ability.perma_mult = (card.ability.perma_mult or 0) + per
      return { message = localize('k_upgrade_ex'), colour = G.C.MULT }
    end
  end,
}
