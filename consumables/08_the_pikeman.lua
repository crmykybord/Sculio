SMODS.Consumable {
  key = 'pikeman',
  set = 'Inverted',
  atlas = 'Sculio_Consumables',
  pos = { x = 7, y = 0 },
  unlocked = true,
  discovered = false,
  cost = 3,
  config = { max_highlighted = 2 },
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.m_Sculio_phalanx
    return { vars = {} }
  end,
  can_use = function(self, card)
    return Sculio.can_select(card)
  end,
  use = function(self, card, area, copier)
    Sculio.track_inverted_use(card)
    Sculio.enhance_highlighted('m_Sculio_phalanx', card.ability.consumeable.max_highlighted, card)
  end,
}
