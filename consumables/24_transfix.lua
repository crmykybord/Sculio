SMODS.Spectral {
  key = 'transfix',
  atlas = 'Sculio_Consumables',
  pos = { x = 4, y = 2 },
  cost = 4,
  config = { max_highlighted = 3, min_highlighted = 3 },
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.m_Sculio_punched
    return { vars = { card.ability.consumeable.max_highlighted } }
  end,
  can_use = function(self, card)
    return Sculio.can_select(card)
  end,
  use = function(self, card, area, copier)
    Sculio.enhance_highlighted('m_Sculio_punched', card.ability.consumeable.max_highlighted, card)
  end,
}
