SMODS.Consumable {
  key = 'immutable_wheel',
  set = 'Inverted',
  atlas = 'Sculio_Consumables',
  pos = { x = 0, y = 1 },
  unlocked = true,
  discovered = false,
  cost = 3,
  loc_vars = function(self, info_queue, card)
    return { vars = {} }
  end,
  can_use = function(self, card)
    return Sculio.hand_selection_state()
  end,
  use = function(self, card, area, copier)
    Sculio.track_inverted_use(card)
    G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.4, func = function()
      local pool = {}
      for key, center in pairs(G.P_CENTERS) do
        if (center.set == 'Tarot' or center.set == 'Inverted') and key ~= 'c_Sculio_immutable_wheel' then
          pool[#pool + 1] = key
        end
      end
      table.sort(pool)

      local hand_empty = not G.hand or #G.hand.highlighted == 0
      -- Always does something: retry until a rolled Tarot can resolve right now.
      -- Target-dependent Tarots are skipped with an empty hand so the effect
      -- doesn't open card selection.
      for i = 1, 15 do
        local key = pseudorandom_element(pool, pseudoseed('sculio_immutable' .. i))
        local center = key and G.P_CENTERS[key]
        if not center then break end
        local needs_target = center.config and center.config.max_highlighted and hand_empty and not center.can_use
        if not needs_target then
          -- Same pattern as gnasher (All in Jest) / grab_bag (Lucky Rabbit):
          -- a detached Card + G.FUNCS.use_card gives the vanilla use animation.
          local new_card = Card(
            G.play.T.x + G.play.T.w / 2 - G.CARD_W * 1.27 / 2,
            G.play.T.y + G.play.T.h / 2 - G.CARD_H * 1.27 / 2,
            G.CARD_W * 1.27, G.CARD_H * 1.27, G.P_CARDS.empty, center,
            { bypass_discovery_center = true, bypass_discovery_ui = true }
          )
          new_card.cost = 0
          G.FUNCS.use_card({ config = { ref_table = new_card } })
          new_card:start_materialize()
          break
        end
      end
      return true
    end }))
    delay(0.6)
  end,
}
