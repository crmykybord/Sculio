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
  calc_dollar_bonus = function(self, back)
    return total_joker_sell_value()
  end,
}
