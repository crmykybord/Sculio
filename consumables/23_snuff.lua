SMODS.Spectral {
  key = 'snuff',
  atlas = 'Sculio_Consumables',
  pos = { x = 3, y = 2 },
  cost = 4,
  config = { max_highlighted = 1, min_highlighted = 1 },
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_SEALS['Sculio_inverted']
    return {}
  end,
  can_use = function(self, card)
    return Sculio.can_select(card)
  end,
  use = function(self, card, area, copier)
    local conv_card = G.hand.highlighted[1]
    G.E_MANAGER:add_event(Event({ func = function()
      play_sound('tarot1')
      card:juice_up(0.3, 0.5)
      return true
    end }))
    G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.1, func = function()
      conv_card:set_seal('Sculio_inverted', nil, true)
      return true
    end }))
    delay(0.5)
    G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.2, func = function()
      G.hand:unhighlight_all()
      return true
    end }))
  end,
}
