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
    local picked = Sculio.pick_modifier(G.GAME.Sculio_last_destroyed or {}, 'sculio_atoned')
    for i = 1, math.min(#G.hand.highlighted, card.ability.consumeable.max_highlighted) do
      local conv_card = G.hand.highlighted[i]
      G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.4, func = function()
        Sculio.apply_modifier(conv_card, picked)
        return true
      end }))
    end
    delay(0.8)
  end,
}
