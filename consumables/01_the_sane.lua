SMODS.Consumable {
  key = 'sane',
  set = 'Inverted',
  atlas = 'Sculio_Consumables',
  pos = { x = 0, y = 0 },
  unlocked = true,
  discovered = false,
  cost = 3,
  loc_vars = function(self, info_queue, card)
    local last = G.GAME.Sculio_last_inverted
    local name = localize('k_none')
    if last and G.P_CENTERS[last] then
      name = localize { type = 'name_text', key = G.P_CENTERS[last].key, set = G.P_CENTERS[last].set }
    end
    local cp = last and Sculio.counterpart(last)
    local cp_name = localize('k_none')
    if cp and G.P_CENTERS[cp] then
      cp_name = localize { type = 'name_text', key = cp, set = 'Tarot' }
    end
    return {
      vars = { name, 1, cp_name },
      key = Sculio.distorted_key(self),
    }
  end,
  can_use = function(self, card)
    if not (G.GAME.Sculio_last_inverted or G.GAME.last_tarot_planet) then return false end
    return #G.consumeables.cards < G.consumeables.config.card_limit or card.area == G.consumeables
  end,
  use = function(self, card, area, copier)
    local last = G.GAME.Sculio_last_inverted
    Sculio.track_inverted_use(card)
    local copies = 1
    if last == card.config.center_key then last = nil end
    if last then
      Sculio.create_center_card(last, G.consumeables, copies, 'sculio_sane')
      if Sculio.distorted() then
        local cp = Sculio.counterpart(last)
        if cp then Sculio.create_center_card(cp, G.consumeables, 1, 'sculio_sane_cp', true) end
      end
    else
      -- Becomes The Fool
      if G.GAME.last_tarot_planet and G.GAME.last_tarot_planet ~= 'c_fool' then
        Sculio.create_center_card(G.GAME.last_tarot_planet, G.consumeables, copies, 'sculio_sane')
      end
    end
  end,
}
