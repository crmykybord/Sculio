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
    Sculio.morph_wheel_into_tarot(card, 1, Sculio.distorted() and 'Tarot' or nil)
    if Sculio.distorted() then
      -- Distorted Flow: the second (Inverted) Tarot appears only once the Wheel
      -- has fully dissolved.
      G.E_MANAGER:add_event(Event({ trigger = 'condition', blocking = false, blockable = false,
        ref_table = card, ref_value = 'REMOVED', stop_val = true,
        func = function()
          if not card.REMOVED then return false end
          Sculio.invoke_random_tarot(2, 'Inverted', 0)
          return true
        end
      }))
    end
  end,
}
