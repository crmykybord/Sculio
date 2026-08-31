SMODS.Enhancement {
  key = 'pierced',
  atlas = 'Sculio_Enhancements',
  pos = { x = 6, y = 0 },

  config = {},
  loc_vars = function(self, info_queue, card)
    return { vars = { 2 } }
  end,
  calculate = function(self, card, context)
    -- X2 Mult before and after the hand scores
    if context.initial_scoring_step and context.cardarea == G.play then
      return { x_mult = 2 }
    end
    if context.final_scoring_step and context.cardarea == G.play then
      return { x_mult = 2 }
    end
  end,
}
