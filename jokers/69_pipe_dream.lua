SMODS.Joker {
  key = 'pipe_dream',
  attributes = { 'chance', 'chips' },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = { odds = 3, chips = 30 } },
  unlocked = true,
  discovered = false,
  rarity = 1, -- Common
  atlas = 'Sculio',
  pos = { x = 0, y = 7 },
  cost = 5,
  loc_vars = function(self, info_queue, card)
    local n, d = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'pipe_dream')
    return { vars = { n, d, card.ability.extra.chips } }
  end,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and context.other_card
        and not context.other_card.debuff
        and SMODS.pseudorandom_probability(card, 'pipe_dream', 1, card.ability.extra.odds, 'pipe_dream') then
      return { chips = card.ability.extra.chips, card = context.other_card }
    end
  end
}
