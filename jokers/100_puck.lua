SMODS.Joker {
  key = 'puck',
  attributes = { 'chips', 'mult', 'xmult', 'xchips', 'editions', "scaling" },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = false,
  rental_compat = true,
  config = { extra = { chips = 0, mult = 0, x_mult = 1, x_chips = 1, bonus_mult = 1 } },
  unlocked = true,
  discovered = false,
  rarity = 4, -- Legendary
  atlas = 'Sculio',
  pos = { x = 8, y = 1 },
  soul_pos = { x = 9, y = 1 },
  cost = 20,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.x_mult, card.ability.extra.x_chips, card.ability.extra.bonus_mult * 100 } }
  end,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and not context.blueprint then
      local ed = context.other_card.edition
      if not ed or context.other_card.debuff then return end
      local message = Sculio.absorb_edition(card, context.other_card, card.ability.extra.bonus_mult)
      if message then
        return { extra = { message = message, focus = card }, card = card }
      end
    end
    if context.joker_main then
      return { chips = card.ability.extra.chips, mult = card.ability.extra.mult, xmult = card.ability.extra.x_mult, x_chips = card.ability.extra.x_chips }
    end
  end
}
