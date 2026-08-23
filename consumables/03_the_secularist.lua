SMODS.Consumable {
  key = 'secularist',
  set = 'Inverted',
  atlas = 'Sculio_Consumables',
  pos = { x = 2, y = 0 },
  unlocked = true,
  discovered = false,
  cost = 3,
  loc_vars = function(self, info_queue, card)
    return { vars = {} }
  end,
  can_use = function(self, card)
    return true
  end,
  use = function(self, card, area, copier)
    local visible_hands = {}
    for k, v in pairs(G.GAME.hands) do
      if v.visible then visible_hands[#visible_hands + 1] = k end
    end
    -- Not affected by odds: uniform pick of 1-3 hands, one level each
    local num_hands = math.floor(pseudorandom('sculio_secularist_n') * 3) + 1
    num_hands = math.min(num_hands, #visible_hands)
    for _ = 1, num_hands do
      local idx = math.floor(pseudorandom('sculio_secularist_h') * #visible_hands) + 1
      local hand_name = table.remove(visible_hands, idx)
      SMODS.smart_level_up_hand(card, hand_name, true, 1)
    end
  end,
}
