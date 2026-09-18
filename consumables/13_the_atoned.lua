SMODS.Consumable {
  key = 'atoned',
  set = 'Inverted',
  atlas = 'Sculio_Consumables',
  pos = { x = 2, y = 1 },
  unlocked = true,
  discovered = false,
  cost = 3,
  config = { max_highlighted = 2, min_highlighted = 1 },
  loc_vars = function(self, info_queue, card)
    return { vars = { Sculio.modifier_label(G.GAME.Sculio_last_destroyed, 'enhancement') or localize('k_none'), Sculio.max_highlighted(card) } }
  end,
  can_use = function(self, card)
    local mods = G.GAME.Sculio_last_destroyed
    if not (mods and mods.enhancement) then return false end
    return Sculio.hand_selection_state() and #G.hand.highlighted >= card.ability.consumeable.min_highlighted
  end,
  use = function(self, card, area, copier)
    Sculio.track_inverted_use(card)
    local picked = { kind = 'enhancement', value = G.GAME.Sculio_last_destroyed.enhancement }
    Sculio.apply_highlighted(function(cards)
      for _, conv_card in ipairs(cards) do
        Sculio.apply_modifier(conv_card, picked)
      end
    end, Sculio.max_highlighted(card), card)
  end,
}
