SMODS.Enhancement {
  key = 'smeared',
  atlas = 'Sculio_Enhancements',
  pos = { x = 6, y = 0 },

  config = {},
  loc_vars = function(self, info_queue, card)
    return { vars = { Sculio.distorted() and 2.25 or 1.75 } }
  end,
  calculate = function(self, card, context)
    local x = Sculio.distorted() and 2.25 or 1.75
    if context.initial_scoring_step and context.cardarea == G.play then
      return { x_mult = x }
    end
    if context.final_scoring_step and context.cardarea == G.play then
      return { x_mult = x }
    end
  end,
}
