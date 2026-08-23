SMODS.Consumable {
  key = 'pikeman',
  set = 'Inverted',
  atlas = 'Sculio_Consumables',
  pos = { x = 7, y = 0 },
  unlocked = true,
  discovered = false,
  cost = 3,
  config = { max_highlighted = 1 },
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.m_Sculio_phalanx
    return { vars = {} }
  end,
  can_use = function(self, card)
    return Sculio.hand_selection_state() and #G.hand.highlighted >= 1
  end,
  use = function(self, card, area, copier)
    Sculio.enhance_highlighted('m_Sculio_phalanx', card.ability.consumeable.max_highlighted)
  end,
}
