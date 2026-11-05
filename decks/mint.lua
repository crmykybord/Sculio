local function total_joker_sell_value()
  local total = 0
  for _, joker in ipairs((G.jokers and G.jokers.cards) or {}) do
    total = total + (joker.sell_cost or 0)
  end
  return total
end

Sculio.total_joker_sell_value = total_joker_sell_value

SMODS.Back {
  key = 'mint',
  atlas = 'Sculio_Enhancements',
  pos = { x = 5, y = 4 },
  config = { no_interest = true },
  apply = function(self, back)
    G.GAME.banned_keys = G.GAME.banned_keys or {}
    G.GAME.banned_keys['v_seed_money'] = true
    G.GAME.banned_keys['v_money_tree'] = true
  end,
  calc_dollar_bonus = function(self, back)
    return total_joker_sell_value()
  end,
}
