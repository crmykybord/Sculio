SMODS.Consumable {
  key = 'eclipse',
  set = 'Inverted',
  atlas = 'Sculio_Consumables',
  pos = { x = 8, y = 1 },
  unlocked = true,
  discovered = false,
  cost = 3,
  loc_vars = function(self, info_queue, card)
    local per = Sculio.distorted() and 2 or 1
    local stacks = math.floor(Sculio.count_suit_deck('Clubs') / 10)
    return { vars = { 10, stacks * per, per } }
  end,
  can_use = function(self, card)
    return G.hand and #G.hand.cards > 0
      and math.floor(Sculio.count_suit_deck('Clubs') / 10) >= 1
  end,
  use = function(self, card, area, copier)
    Sculio.track_inverted_use(card)
    local per = Sculio.distorted() and 2 or 1
    local stacks = math.floor(Sculio.count_suit_deck('Clubs') / 10)
    local gain = stacks * per
    local held = {}
    for _, c in ipairs(G.hand.cards) do held[#held + 1] = c end
    for _, c in ipairs(held) do
      c.ability.perma_mult = (c.ability.perma_mult or 0) + gain
    end
    G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.3, func = function()
      for _, c in ipairs(held) do
        if not c.REMOVED then c:juice_up(0.3, 0.5) end
      end
      play_sound('gold_seal', 1.2, 0.4)
      return true
    end }))
    delay(0.4)
  end,
}
