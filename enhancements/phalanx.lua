SMODS.Enhancement {
  key = 'phalanx',
  atlas = 'Sculio_Enhancements',
  pos = { x = 3, y = 0 },

  config = { extra = { base = 1.05, per_card = 0.05 } },
  loc_vars = function(self, info_queue, card)
    local extra = self.config.extra
    return { vars = { extra.base, extra.per_card }, key = Sculio.distorted_key(self) }
  end,
  calculate = function(self, card, context)
    local extra = self.config.extra
    local distorted = Sculio.distorted()
    if context.main_scoring and context.cardarea == G.play then
      G.GAME.Sculio_phalanx_streak = (G.GAME.Sculio_phalanx_streak or 0) + 1
      return { x_mult = extra.base + extra.per_card * (G.GAME.Sculio_phalanx_streak - 1) }
    end
    -- Distorted Flow effect
    if context.repetition and context.cardarea == G.play and distorted then
      return { repetitions = 1 }
    end
    if context.after then
      G.GAME.Sculio_phalanx_streak = nil
    end
  end,
}
