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
      -- Distorted Flow: one vanilla Tarot, then one Inverted Tarot, run sequentially
      -- so their hand highlights can never overlap
      G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 1.2, func = function()
        Sculio.invoke_random_tarot(1, 'Tarot', -G.CARD_W * 0.6, function()
          Sculio.invoke_random_tarot(2, 'Inverted', G.CARD_W * 0.6)
        end)
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
