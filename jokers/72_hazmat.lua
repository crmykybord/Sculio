local function unique_enhancements()
  local seen, n = {}, 0
  for _, c in ipairs(G.playing_cards or {}) do
    for key in pairs(SMODS.get_enhancements(c)) do
      if not seen[key] then
        seen[key] = true
        n = n + 1
      end
    end
  end
  return n
end

SMODS.Joker {
  key = 'hazmat',
  attributes = { 'xmult', 'full_deck', 'enhancements' },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = { x_mult_gain = 0.25 } },
  unlocked = true,
  discovered = false,
  rarity = 1, -- Common
  atlas = 'Sculio',
  pos = { x = 4, y = 7 },
  cost = 4,
  loc_vars = function(self, info_queue, card)
    local n = unique_enhancements()
    return { vars = { card.ability.extra.x_mult_gain, n, 1 + card.ability.extra.x_mult_gain * n } }
  end,
  calculate = function(self, card, context)
    if context.joker_main then
      local n = unique_enhancements()
      if n > 0 then
        return { xmult = 1 + card.ability.extra.x_mult_gain * n }
      end
    end
  end,
}
