SMODS.Joker {
  key = 'vintage_comic',
  attributes = { 'retrigger', 'enhancements' },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = { repetitions = 2 } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 9, y = 7 },
  cost = 7,
  in_pool = function(self, args)
    return Sculio.count_enhanced('m_steel') > 0
  end,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.repetitions } }
  end,
  calculate = function(self, card, context)
    if context.cardarea == G.play and context.repetition and not context.repetition_only
        and context.other_card and SMODS.has_enhancement(context.other_card, 'm_steel') then
      return {
        message = localize('k_again_ex'),
        repetitions = card.ability.extra.repetitions,
        card = card,
      }
    end
  end,
}
