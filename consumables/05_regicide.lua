SMODS.Consumable {
  key = 'regicide',
  set = 'Inverted',
  atlas = 'Sculio_Consumables',
  pos = { x = 4, y = 0 },
  unlocked = true,
  discovered = false,
  cost = 3,
  loc_vars = function(self, info_queue, card)
    return { vars = { Sculio.distorted() and 3 or 2 }, key = Sculio.distorted_key(self) }
  end,
  can_use = function(self, card)
    if Sculio.distorted() then return true end
    return #G.consumeables.cards < G.consumeables.config.card_limit or card.area == G.consumeables
  end,
  use = function(self, card, area, copier)
    Sculio.track_inverted_use(card)
    local count = Sculio.distorted() and 3 or 2
    local no_room = Sculio.distorted()
    for i = 1, count do
      G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.4, func = function()
        if no_room or G.consumeables.config.card_limit > #G.consumeables.cards then
          play_sound('timpani')
          local key = pseudorandom_element(Sculio.inverted_pool(), pseudoseed('sculio_regicide' .. i))
          if key then
            local new_card = create_card('Inverted', G.consumeables, nil, nil, nil, nil, key, 'sculio_regicide' .. i)
            new_card:add_to_deck()
            G.consumeables:emplace(new_card)
            card:juice_up(0.3, 0.5)
          end
        end
        return true
      end }))
    end
    delay(0.9)
  end,
}
