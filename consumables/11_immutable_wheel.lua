SMODS.Consumable {
  key = 'immutable_wheel',
  set = 'Inverted',
  atlas = 'Sculio_Consumables',
  pos = { x = 0, y = 1 },
  unlocked = true,
  discovered = false,
  cost = 3,
  loc_vars = function(self, info_queue, card)
    return { vars = { Sculio.distorted() and 2 or 1 }, key = Sculio.distorted_key(self) }
  end,
  can_use = function(self, card)
    return Sculio.hand_selection_state() or G.STATE == G.STATES.SHOP
  end,
  use = function(self, card, area, copier)
    Sculio.track_inverted_use(card)
    -- Wait for the Wheel itself to finish dissolving before revealing the chosen Tarot
    if Sculio.distorted() then
      -- Distorted Flow: one vanilla Tarot and one Inverted Tarot
      G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 1.2, func = function()
        Sculio.invoke_random_tarot(1, 'Tarot')
        return true
      end }))
      G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 2.4, func = function()
        Sculio.invoke_random_tarot(2, 'Inverted')
        return true
      end }))
    else
      G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 1.2, func = function()
        Sculio.invoke_random_tarot(1)
        return true
      end }))
    end
  end,
}
