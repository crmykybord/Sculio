SMODS.Joker {
  key = 'skipping_stones',
  attributes = { 'booster', 'ante', 'skip' },
  eternal_compat = true,
  blueprint_compat = false,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = { current = 0, max = 7, antes = -1 } },
  unlocked = true,
  discovered = false,
  rarity = 3, -- Rare
  atlas = 'Sculio',
  pos = { x = 9, y = 8 },
  cost = 6,
  loc_vars = function(self, info_queue, card)
    local extra = card.ability.extra
    return { vars = { extra.current, extra.max, extra.antes } }
  end,
  calculate = function(self, card, context)
    if not context.blueprint and context.skipping_booster then
      local extra = card.ability.extra
      extra.current = extra.current + 1
      if extra.current >= extra.max then
        extra.current = 0
        ease_ante(extra.antes)
        G.GAME.round_resets.blind_ante = (G.GAME.round_resets.blind_ante or G.GAME.round_resets.ante) + extra.antes
        return { message = localize('k_Sculio_skipped'), colour = G.C.GREEN, card = card }
      end
      return { message = extra.current .. '/' .. extra.max, colour = G.C.FILTER, card = card }
    end
  end,
}