SMODS.Consumable {
  key = 'regicide',
  set = 'Inverted',
  atlas = 'Sculio_Consumables',
  pos = { x = 4, y = 0 },
  unlocked = true,
  discovered = false,
  cost = 3,
  loc_vars = function(self, info_queue, card)
    return { vars = { 2 } }
  end,
  can_use = function(self, card)
    return #G.consumeables.cards < G.consumeables.config.card_limit or card.area == G.consumeables
  end,
  use = function(self, card, area, copier)
    for i = 1, 2 do
      G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.4, func = function()
        if G.consumeables.config.card_limit > #G.consumeables.cards then
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
