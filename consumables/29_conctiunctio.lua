-- Conctiunctio: Sigil/Ouija's enhancement twin — one roll, every card in hand
-- wears the same {C:attention}Enhancement{}. Then it bills one max discard for
-- the run (vanilla pattern: G.GAME.round_resets.discards - extra + ease_discard).
SMODS.Spectral {
  key = 'conctiunctio',
  atlas = 'Sculio_Consumables',
  pos = { x = 9, y = 2 },
  cost = 4,
  config = { extra = { discards = 1 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.discards } }
  end,
  can_use = function(self, card)
    return Sculio.hand_selection_state() and G.hand and #G.hand.cards > 0
  end,
  use = function(self, card, area, copier)
    -- Rolled once: all cards share this enhancement.
    local enh = SMODS.poll_enhancement({ key = 'sculio_conctiunctio', guaranteed = true })
    local targets = {}
    for _, c in ipairs(G.hand.cards) do targets[#targets + 1] = c end
    Sculio.flip_highlighted(card, targets, function()
      for _, c in ipairs(targets) do
        if enh and not c.REMOVED then c:set_ability(G.P_CENTERS[enh], false) end
      end
    end)
    G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.4, func = function()
      G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.discards
      ease_discard(-card.ability.extra.discards)
      return true
    end }))
  end,
}
