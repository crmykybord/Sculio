SMODS.Joker {
  key = 'impossible_stairs',
  attributes = { 'mult', 'scaling', 'chance' },

  config = { extra = { mult = 8, mult_add_min = -2, mult_add_max = 2, mult_min = 0 } },
  unlocked = true,
  discovered = false,
  rarity = 1, -- Common
  atlas = 'Sculio',
  pos = { x = 1, y = 0 },
  cost = 3,
  eternal_compat = false,
  perishable_compat = true,
  blueprint_compat = true,
  rental_compat = true,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.mult, card.ability.extra.mult_add_min, card.ability.extra.mult_add_max, card.ability.extra.mult_min } }
  end,
  calculate = function(self, card, context)
    if context.before and not context.blueprint then
      local add = pseudorandom('impossible_stairs', card.ability.extra.mult_add_min, card.ability.extra.mult_add_max)
      card.ability.extra.mult = card.ability.extra.mult + add

      if card.ability.extra.mult <= card.ability.extra.mult_min then
        Sculio.destroy_joker(card)
      end

      if add >= 0 then
        return { message = localize{type='variable', key='a_mult', vars={add}}, colour = G.C.MULT }
      else
        return { message = localize{type='variable', key='a_mult_minus', vars={math.abs(add)}}, colour = G.C.MULT }
      end
    end

    if context.joker_main then
      return { mult = card.ability.extra.mult }
    end
  end
}
