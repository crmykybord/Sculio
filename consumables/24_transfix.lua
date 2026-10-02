-- Spectral-style randomness: no selection, the cards are picked for you.
SMODS.Spectral {
  key = 'transfix',
  atlas = 'Sculio_Consumables',
  pos = { x = 4, y = 2 },
  cost = 4,
  config = { extra = { cards = 3 } },
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.m_Sculio_punched
    return { vars = { card.ability.consumeable.extra.cards } }
  end,
  can_use = function(self, card)
    return Sculio.hand_selection_state() and G.hand and #G.hand.cards > 0
  end,
  use = function(self, card, area, copier)
    -- Shallow copy: copy_table() deep-copies Cards and recurses forever on card.area cycles
    local targets = {}
    for _, c in ipairs(G.hand.cards) do targets[#targets + 1] = c end
    pseudoshuffle(targets, pseudoseed('sculio_transfix'))
    local picked = {}
    for i = 1, math.min(card.ability.consumeable.extra.cards, #targets) do
      picked[i] = targets[i]
    end
    Sculio.flip_highlighted(card, picked, function()
      for _, c in ipairs(picked) do
        if not c.REMOVED then c:set_ability(G.P_CENTERS.m_Sculio_punched, false) end
      end
    end)
  end,
}
