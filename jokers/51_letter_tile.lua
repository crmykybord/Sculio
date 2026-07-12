SMODS.Joker {
  key = 'letter_tile',
  attributes = { 'mult', 'jack' },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = { mult = 8 } },
  unlocked = true,
  discovered = false,
  rarity = 2,
  atlas = 'Sculio',
  pos = { x = 3, y = 5 },
  cost = 5,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.mult } }
  end,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
      if context.other_card:get_id() == 11 then
        return { mult = card.ability.extra.mult }
      end
    end
  end
}
