SMODS.Consumable {
  key = 'mercy',
  set = 'inverted_tarot_sculio',
  atlas = 'Sculio_Consumables',
  pos = { x = 0, y = 2 },
  unlocked = true,
  discovered = false,
  cost = 3,
  config = { extra = { sell_penalty = 1, distorted_sell = 0 } },
  loc_vars = function(self, info_queue, card)
    local last = G.GAME.Sculio_last_joker_sold
    local name = localize('k_none')
    if last then
      name = localize { type = 'name_text', key = G.P_CENTERS[last].key, set = G.P_CENTERS[last].set }
    end
    if Sculio.distorted() then
      return { vars = { name }, key = Sculio.distorted_key(self) }
    end
    local penalty = '-$' .. self.config.extra.sell_penalty
    return { vars = { name, localize('Sculio_perishable_suffix'), penalty } }
  end,
  can_use = function(self, card)
    return G.GAME.Sculio_last_joker_sold ~= nil
  end,
  use = function(self, card, area, copier)
    Sculio.track_inverted_use(card)
    local last_joker = G.GAME.Sculio_last_joker_sold
    local extra = self.config.extra
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
      new_card.sell_cost = distorted and extra.distorted_sell or -extra.sell_penalty
      card:juice_up(0.3, 0.5)
      return true
    end }))
    delay(0.6)
  end,
}
