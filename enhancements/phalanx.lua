SMODS.Enhancement {
  key = 'phalanx',
  atlas = 'Sculio_Enhancements',
  pos = { x = 3, y = 0 },

  config = {},
  loc_vars = function(self, info_queue, card)
    local per = Sculio.distorted() and 0.4 or 0.05
    return { vars = { 1.05, per }, key = Sculio.distorted_key(self) }
  end,
  calculate = function(self, card, context)
    local distorted = Sculio.distorted()
    local per = distorted and 0.4 or 0.05
    if context.main_scoring and context.cardarea == G.play then
      -- Every scored Phalanx feeds one shared consecutive-streak multiplier
      if not G.GAME.Sculio_phalanx_scored then G.GAME.Sculio_phalanx_scored = {} end
      if not G.GAME.Sculio_phalanx_scored[card] then
        G.GAME.Sculio_phalanx_scored[card] = true
        G.GAME.Sculio_phalanx_streak = (G.GAME.Sculio_phalanx_streak or 0) + 1
      end
      local x_mult = 1.05 + per * ((G.GAME.Sculio_phalanx_streak or 1) - 1)
      return { x_mult = x_mult }
    end
    -- Distorted Flow: scored Phalanx cards reactivate once
    if context.repetition and context.cardarea == G.play and distorted then
      return { repetitions = 1 }
    end
    if context.after then
      G.GAME.Sculio_phalanx_streak = nil
      G.GAME.Sculio_phalanx_scored = nil
    end
  end,
}
