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
    if last then
      name = localize { type = 'name_text', key = G.P_CENTERS[last].key, set = G.P_CENTERS[last].set }
    end
    if Sculio.distorted() then
      return { vars = { name }, key = Sculio.distorted_key(self) }
    end
    return { vars = { name, localize('Sculio_perishable_suffix') } }
  end,
  can_use = function(self, card)
    return G.GAME.Sculio_last_joker_sold ~= nil
  end,
  use = function(self, card, area, copier)
    Sculio.track_inverted_use(card)
    local last_joker = G.GAME.Sculio_last_joker_sold
    local distorted = Sculio.distorted()
    G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.4, func = function()
      play_sound('timpani')
      local new_card = SMODS.create_card({
        set = 'Joker',
        area = G.jokers,
        key = last_joker,
        key_append = 'sculio_mercy',
        no_edition = true,
      })
      new_card:add_to_deck()
      G.jokers:emplace(new_card)
      new_card:set_edition({ negative = true }, true)
      if not distorted and SMODS.Stickers.perishable and SMODS.Stickers.perishable.apply then
        SMODS.Stickers.perishable:apply(new_card, true)
      end
      -- ponytail: sell_cost recalculates on cost changes; permanent $0 needs a hook if this matters later
      new_card.cost = 0
      new_card.sell_cost = 0
      card:juice_up(0.3, 0.5)
      return true
    end }))
    if distorted then
      -- Distorted Flow: also spawn a random Negative, Perishable, $0 Joker
      G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 1.0, func = function()
        local pool = get_current_pool('Joker')
        local key = pseudorandom_element(pool, pseudoseed('sculio_mercy_random'))
        local it = 1
        while key == 'UNAVAILABLE' do
          it = it + 1
          key = pseudorandom_element(pool, pseudoseed('sculio_mercy_random_' .. it))
        end
        play_sound('timpani')
        local rnd = create_card('Joker', G.jokers, nil, nil, nil, nil, key, 'sculio_mercy_random')
        rnd:add_to_deck()
        G.jokers:emplace(rnd)
        rnd:set_edition({ negative = true }, true)
        if SMODS.Stickers.perishable and SMODS.Stickers.perishable.apply then
          SMODS.Stickers.perishable:apply(rnd, true)
        end
        rnd.cost = 0
        rnd.sell_cost = 0
        card:juice_up(0.3, 0.5)
        return true
      end }))
    end
    delay(0.6)
  end,
}
