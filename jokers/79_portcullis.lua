SMODS.Joker {
  key = 'portcullis',
  attributes = { 'retrigger', 'enhancements' },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  config = {},
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 1, y = 8 },
  cost = 5,
  calculate = function(self, card, context)
    if context.cardarea == G.play and context.repetition and not context.repetition_only
        and context.other_card and SMODS.has_enhancement(context.other_card, 'm_Sculio_phalanx') then
      return {
        message = localize('k_again_ex'),
        repetitions = 1,
        card = card,
      }
    end
  end,
  in_pool = function(self)
    return Sculio.count_enhanced('m_Sculio_phalanx') > 0
  end,
}
