SMODS.Enhancement {
  key = 'smeared',
  atlas = 'Sculio_Enhancements',
  pos = { x = 6, y = 0 },

  config = {},
  loc_vars = function(self, info_queue, card)
    return { vars = { 1.75 } }
  end,
  calculate = function(self, card, context)
    if context.initial_scoring_step and context.cardarea == G.play then
      return { x_mult = 1.75 }
    end
    if context.final_scoring_step and context.cardarea == G.play then
      return { x_mult = 1.75 }
    end
  end,
}
