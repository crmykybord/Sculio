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
    return Sculio.can_select(card)
  end,
  use = function(self, card, area, copier)
    Sculio.track_inverted_use(card)
    Sculio.apply_highlighted(function(cards)
      for _, c in ipairs(cards) do
        SMODS.modify_rank(c, -1)
      end
    end, card.ability.consumeable.max_highlighted, card)
  end,
}
