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
    return { vars = { name, Sculio.distorted() and 2 or 1 } }
  end,
  can_use = function(self, card)
    if not (G.GAME.Sculio_last_inverted or G.GAME.last_tarot_planet) then return false end
    return #G.consumeables.cards < G.consumeables.config.card_limit or card.area == G.consumeables
  end,
  use = function(self, card, area, copier)
    local last = G.GAME.Sculio_last_inverted
    Sculio.track_inverted_use(card)
    local copies = Sculio.distorted() and 2 or 1
    if sendDebugMessage then sendDebugMessage('Sculio: Sane use, last=' .. tostring(last) .. ' last_tarot_planet=' .. tostring(G.GAME.last_tarot_planet), 'SCULIO') end
    if last then
      Sculio.create_center_card(last, G.consumeables, copies, 'sculio_sane')
    else
      -- Becomes The Fool
      if G.GAME.last_tarot_planet and G.GAME.last_tarot_planet ~= 'c_fool' then
        Sculio.create_center_card(G.GAME.last_tarot_planet, G.consumeables, copies, 'sculio_sane')
      end
    end
  end,
}
