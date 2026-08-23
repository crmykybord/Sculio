SMODS.Joker {
  key = 'nonogram_joker',
  attributes = { 'chips', 'mult' },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = { chips = 12, mult = 4, flip = false } },
  unlocked = true,
  discovered = false,
  rarity = 1, -- Common
  atlas = 'Sculio',
  pos = { x = 9, y = 5 },
  cost = 4,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.chips, card.ability.extra.mult } }
  end,
  calculate = function(self, card, context)
    if context.before then
      card.ability.extra.flip = false
    end

    if context.individual and context.cardarea == G.play then
      local ret
      if card.ability.extra.flip then
        ret = { mult = card.ability.extra.mult, card = card }
      else
        ret = { chips = card.ability.extra.chips, card = card }
      end
      card.ability.extra.flip = not card.ability.extra.flip
      return ret
    end
  end
}
