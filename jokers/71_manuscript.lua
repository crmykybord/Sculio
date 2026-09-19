SMODS.Joker {
  key = 'manuscript',
  attributes = { 'chips', 'scaling' },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = { chips = 0, gain = 6 } },
  unlocked = true,
  discovered = false,
  rarity = 1, -- Common
  atlas = 'Sculio',
  pos = { x = 3, y = 7 },
  cost = 4,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.chips, card.ability.extra.gain } }
  end,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and context.other_card
        and SMODS.has_enhancement(context.other_card, 'm_Sculio_profane') and not context.blueprint then
      card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.gain
      return {
        extra = { message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.gain } }, colour = G.C.CHIPS, focus = card },
        card = card,
      }
    end
    if context.joker_main and card.ability.extra.chips > 0 then
      return { chips = card.ability.extra.chips }
    end
  end,
  in_pool = function(self)
    return Sculio.count_enhanced('m_Sculio_profane') > 0
  end,
}
