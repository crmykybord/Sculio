SMODS.Consumable {
  key = 'secularist',
  set = 'Inverted',
  atlas = 'Sculio_Consumables',
  pos = { x = 2, y = 0 },
  unlocked = true,
  discovered = false,
  cost = 3,
  loc_vars = function(self, info_queue, card)
    return { vars = { Sculio.distorted() and 2 or 1, Sculio.distorted() and 7 or 3 } }
  end,
  can_use = function(self, card)
    return true
  end,
  use = function(self, card, area, copier)
    Sculio.track_inverted_use(card)
    local lo = Sculio.distorted() and 2 or 1
    local hi = Sculio.distorted() and 7 or 3
    local visible_hands = {}
    for k, v in pairs(G.GAME.hands) do
      if v.visible then visible_hands[#visible_hands + 1] = k end
    end
    local num_hands = lo + math.floor(pseudorandom('sculio_secularist_n') * (hi - lo + 1))
    num_hands = math.min(num_hands, #visible_hands)
    local picked = {}
    for i = 1, num_hands do
      local idx = math.floor(pseudorandom('sculio_secularist_h' .. tostring(i)) * #visible_hands) + 1
      picked[#picked + 1] = table.remove(visible_hands, idx)
    end
    SMODS.upgrade_poker_hands({ hands = picked, from = card, level_up = 1, instant = false })
  end,
}
