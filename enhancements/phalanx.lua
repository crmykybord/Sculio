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
      -- Every scoring pass feeds the shared streak, retriggers included. SMODS runs
      -- calculate once per repetition (card.repetition_trigger tells which pass this
      -- is), so a card that scores again keeps climbing instead of sitting on the
      -- multiplier it got the first time.
      G.GAME.Sculio_phalanx_streak = (G.GAME.Sculio_phalanx_streak or 0) + 1
      return { x_mult = 1.05 + per * (G.GAME.Sculio_phalanx_streak - 1) }
    end
    -- Distorted Flow: scored Phalanx cards reactivate once
    if context.repetition and context.cardarea == G.play and distorted then
      return { repetitions = 1 }
    end
    if context.after then
      G.GAME.Sculio_phalanx_streak = nil
    end
  end,
}
