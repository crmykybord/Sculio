SMODS.Consumable {
  key = 'mercy',
  set = 'Inverted',
  atlas = 'Sculio_Consumables',
  pos = { x = 0, y = 2 },
  unlocked = true,
  discovered = false,
  cost = 3,
  loc_vars = function(self, info_queue, card)
    local last = G.GAME.Sculio_last_joker_sold
    local name = localize('k_none')
    if last and G.P_CENTERS[last] then
      name = localize { type = 'name_text', key = G.P_CENTERS[last].key, set = G.P_CENTERS[last].set }
    end
    return { vars = { name } }
  end,
  can_use = function(self, card)
    return G.GAME.Sculio_last_joker_sold
      and (#G.jokers.cards < G.jokers.config.card_limit or card.area == G.jokers)
  end,
  use = function(self, card, area, copier)
    Sculio.track_inverted_use(card)
    G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.4, func = function()
      play_sound('timpani')
      local new_card = create_card('Joker', G.jokers, nil, nil, nil, nil, G.GAME.Sculio_last_joker_sold, 'sculio_mercy')
      new_card:add_to_deck()
      G.jokers:emplace(new_card)
      new_card:set_edition({ negative = true }, true)
      if SMODS.Stickers.perishable and SMODS.Stickers.perishable.apply then
        SMODS.Stickers.perishable:apply(new_card, true)
      end
      -- ponytail: sell_cost recalculates on cost changes; permanent $0 needs a hook if this matters later
      new_card.cost = 0
      new_card.sell_cost = 0
      card:juice_up(0.3, 0.5)
      return true
    end }))
    delay(0.6)
  end,
}
