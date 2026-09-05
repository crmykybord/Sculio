SMODS.Consumable {
  key = 'impatient',
  set = 'Inverted',
  atlas = 'Sculio_Consumables',
  pos = { x = 4, y = 1 },
  unlocked = true,
  discovered = false,
  cost = 3,
  loc_vars = function(self, info_queue, card)
    return { vars = { 75 } }
  end,
  can_use = function(self, card)
    return true
  end,
  use = function(self, card, area, copier)
    local total = 0
    for _, j in ipairs(G.jokers.cards) do
      total = total + j.sell_cost
    end
    for _, c in ipairs(G.consumeables.cards) do
      if c ~= card then total = total + c.sell_cost end
    end
    local payout = math.min(math.floor(total), 75)
    G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.4, func = function()
      ease_dollars(payout)
      card:juice_up(0.3, 0.5)
      return true
    end }))
    -- Then a random Joker loses $1 of sell value
    if #G.jokers.cards > 0 then
      local joker = pseudorandom_element(G.jokers.cards, pseudoseed('sculio_impatient'))
      G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.4, func = function()
        if joker and not joker.gone then
          -- ponytail: sell_cost recalculates on cost changes; permanent $0 floor needs a hook if this matters later
          joker.sell_cost = math.max(0, joker.sell_cost - 1)
          joker:juice_up(0.3, 0.5)
        end
        return true
      end }))
    end
    delay(1.0)
  end,
}
