SMODS.Consumable {
  key = 'weakness',
  set = 'Inverted',
  atlas = 'Sculio_Consumables',
  pos = { x = 1, y = 1 },
  unlocked = true,
  discovered = false,
  cost = 3,
  config = { max_highlighted = 2 },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.consumeable.max_highlighted } }
  end,
  can_use = function(self, card)
    return Sculio.hand_selection_state() and #G.hand.highlighted >= 1
  end,
  use = function(self, card, area, copier)
    for i = 1, math.min(#G.hand.highlighted, card.ability.consumeable.max_highlighted) do
      local conv_card = G.hand.highlighted[i]
      G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.4, func = function()
        SMODS.modify_rank(conv_card, -1)
        conv_card:juice_up(0.3, 0.5)
        return true
      end }))
    end
    delay(0.8)
  end,
}
