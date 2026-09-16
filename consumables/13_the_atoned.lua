SMODS.Consumable {
  key = 'atoned',
  set = 'Inverted',
  atlas = 'Sculio_Consumables',
  pos = { x = 2, y = 1 },
  unlocked = true,
  discovered = false,
  cost = 3,
  config = { max_highlighted = 2, min_highlighted = 2 },
  loc_vars = function(self, info_queue, card)
    return { vars = { 65, 17.5, 17.5 } }
  end,
  can_use = function(self, card)
    local mods = G.GAME.Sculio_last_destroyed
    if not (mods and (mods.enhancement or mods.seal or mods.edition)) then return false end
    return Sculio.hand_selection_state() and #G.hand.highlighted >= card.ability.consumeable.min_highlighted
  end,
  use = function(self, card, area, copier)
    Sculio.track_inverted_use(card)
    local picked = Sculio.pick_modifier(G.GAME.Sculio_last_destroyed or {}, 'sculio_atoned')
    if not picked then return end
    Sculio.apply_highlighted(function(cards)
      for _, conv_card in ipairs(cards) do
        Sculio.apply_modifier(conv_card, picked)
      end
    end, card.ability.consumeable.max_highlighted, card)
  end,
}
