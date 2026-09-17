SMODS.Consumable {
  key = 'immutable_wheel',
  set = 'Inverted',
  atlas = 'Sculio_Consumables',
  pos = { x = 0, y = 1 },
  unlocked = true,
  discovered = false,
  cost = 3,
  loc_vars = function(self, info_queue, card)
    return { vars = { Sculio.distorted() and 2 or 1 } }
  end,
  can_use = function(self, card)
    return Sculio.hand_selection_state() or G.STATE == G.STATES.SHOP
  end,
  use = function(self, card, area, copier)
    Sculio.track_inverted_use(card)
    -- Wait for the Wheel itself to finish dissolving before revealing the chosen Tarot
    local count = Sculio.distorted() and 2 or 1
    for i = 1, count do
      G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 1.2 + (i - 1) * 1.2, func = function()
        Sculio.invoke_random_tarot(i)
        return true
      end }))
    end
  end,
}
