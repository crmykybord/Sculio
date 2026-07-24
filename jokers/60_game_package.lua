SMODS.Joker {
  key = 'game_package',
  attributes = { 'xmult' },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  config = { x_mult = 1, extra = { x_mult = 0 } },
  unlocked = true,
  discovered = false,
  rarity = 2,
  atlas = 'Sculio',
  pos = { x = 2, y = 6 },
  cost = 5,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.x_mult } }
  end,
  calculate = function(self, card, context)
    if context.before then
      card.ability.extra.x_mult = #(context.full_hand or {})
    end
    if context.end_of_round then return nil end
    if context.individual and context.cardarea == G.hand then
      if context.other_card.base.id == 2 or context.other_card.base.id == 4 then
        return {
          xmult = card.ability.x_mult * card.ability.extra.x_mult,
          card = context.other_card,
        }
      end
    end
  end
}