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
      and (#G.consumeables.cards < G.consumeables.config.card_limit or card.area == G.consumeables)
  end,
  use = function(self, card, area, copier)
    G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.4, func = function()
      local pool = {}
      for key, center in pairs(G.P_CENTERS) do
        if (center.set == 'Tarot' or center.set == 'Inverted') and key ~= 'c_Sculio_immutable_wheel' then
          pool[#pool + 1] = key
        end
      end
      local hand_empty = not G.hand or #G.hand.highlighted == 0
      -- Always does something: retry until a rolled Tarot is usable right now
      for i = 1, 15 do
        if #G.consumeables.cards >= G.consumeables.config.card_limit and card.area ~= G.consumeables then break end
        if #G.consumeables.cards >= G.consumeables.config.card_limit then break end
        local key = pseudorandom_element(pool, pseudoseed('sculio_immutable' .. i))
        local center = key and G.P_CENTERS[key]
        if not center then break end
        -- Vanilla tarots have no can_use; skip target-dependent ones with an empty hand
        if not center.can_use and center.config and center.config.max_highlighted and hand_empty then
          -- unusable right now, retry
        else
          local new_card = create_card(center.set, G.consumeables, nil, nil, nil, nil, key, 'sculio_immutable_c' .. i)
          if center.can_use and not center:can_use(new_card) then
            new_card:remove()
          else
            play_sound('timpani')
            new_card:add_to_deck()
            G.consumeables:emplace(new_card)
            new_card:use_consumeable(G.consumeables)
            break
          end
        end
      end
      return true
    end }))
    delay(0.6)
  end,
}
