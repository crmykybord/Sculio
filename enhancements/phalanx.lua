SMODS.Enhancement {
  key = 'phalanx',
  atlas = 'Sculio_Enhancements',
  pos = { x = 3, y = 0 },

  config = {},
  loc_vars = function(self, info_queue, card)
    return { vars = { 0.2 } }
  end,
  calculate = function(self, card, context)
    -- Every scored Phalanx feeds one shared end-of-hand multiplier
    if context.main_scoring and context.cardarea == G.play then
      G.GAME.Sculio_phalanx_tally = (G.GAME.Sculio_phalanx_tally or 0) + 0.2
    end
    if context.final_scoring_step and (G.GAME.Sculio_phalanx_tally or 0) > 0 then
      local xmult = 1 + G.GAME.Sculio_phalanx_tally
      G.GAME.Sculio_phalanx_tally = nil
      return { x_mult = xmult }
    end
    if context.initial_scoring_step then
      G.GAME.Sculio_phalanx_tally = nil
    end
  end,
}
