SMODS.Joker {
  key = 'welcome_mat',
  attributes = { 'xmult', 'hand_type' },
  eternal_compat = true,
  blueprint_compat = false,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = { x_mult = 1.5 } },
  unlocked = true,
  discovered = false,
  rarity = 3, -- Rare
  atlas = 'Sculio',
  pos = { x = 8, y = 8 },
  cost = 8,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.x_mult } }
  end,
  calculate = function(self, card, context)
    -- Per scored card, so blueprint_compat is off: `individual` fires once per joker.
    if context.individual and context.cardarea == G.play and context.other_card then
      local hands = context.poker_hands or {}
      if next(hands['Full House'] or {}) or next(hands['Flush House'] or {}) then
        return { xmult = card.ability.extra.x_mult, card = context.other_card }
      end
    end
  end
}