SMODS.Enhancement {
  key = 'punched',
  atlas = 'Sculio_Enhancements',
  pos = { x = 0, y = 1 },

  config = {},
  loc_vars = function(self, info_queue, card)
    return { vars = { 1.5 } }
  end,
  calculate = function(self, card, context)
    if context.main_scoring and context.cardarea == G.play then
      return {
        x_mult = 1.5,
        message = localize { type = 'variable', key = 'a_xmult', vars = { 1.5 } },
      }
    end
  end,
}
