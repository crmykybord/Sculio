SMODS.Consumable {
  key = 'cave',
  set = 'Inverted',
  atlas = 'Sculio_Consumables',
  pos = { x = 1, y = 2 },
  unlocked = true,
  discovered = false,
  cost = 3,
  loc_vars = function(self, info_queue, card)
    local stacks = math.floor(Sculio.count_suit_deck('Spades') / 10)
    return { vars = { 10, stacks * 5 } }
  end,
  can_use = function(self, card)
    return G.hand and #G.hand.cards > 0
      and math.floor(Sculio.count_suit_deck('Spades') / 10) >= 1
  end,
  use = function(self, card, area, copier)
    local stacks = math.floor(Sculio.count_suit_deck('Spades') / 10)
    for _, held in ipairs(G.hand.cards) do
      held.ability.perma_bonus = (held.ability.perma_bonus or 0) + stacks * 5
      G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.3, func = function()
        held:juice_up(0.3, 0.5)
        return true
      end }))
    end
    delay(0.4)
  end,
}
