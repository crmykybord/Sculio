SMODS.Joker {
  key = 'telephone',
  attributes = { 'mult', 'rank' },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = { mult = 0, mult_gain = 3 } },
  unlocked = true,
  discovered = false,
  rarity = 3, -- Rare
  atlas = 'Sculio',
  pos = { x = 0, y = 6 },
  cost = 8,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.mult_gain, card.ability.extra.mult } }
  end,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and context.other_card then
      if context.other_card.base and context.other_card.base.value == '2' then
        card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
        return { message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult_gain } }, colour = G.C.RED }
      elseif context.other_card.base and context.other_card.base.value == '3' then
        card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain * 2
        return { message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult_gain * 2 } }, colour = G.C.RED }
      end
    end
    if context.joker_main then
      return { mult = card.ability.extra.mult }
    end
  end
}