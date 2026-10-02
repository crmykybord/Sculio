SMODS.Joker {
  key = 'scrawlings',
  attributes = { 'chance', 'tag', 'enhancements' },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = false,
  rental_compat = true,
  config = { extra = { odds = 4 } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 6, y = 8 },
  cost = 5,
  loc_vars = function(self, info_queue, card)
    local n, d = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'scrawlings')
    return { vars = { n, d } }
  end,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and context.other_card
        and not context.other_card.debuff
        and SMODS.has_enhancement(context.other_card, 'm_Sculio_experimental')
        and SMODS.pseudorandom_probability(card, 'scrawlings', 1, card.ability.extra.odds, 'scrawlings') then
      G.E_MANAGER:add_event(Event({
        trigger = 'after',
        func = function()
          add_tag(Tag('tag_double', false, 'Small'))
          return true
        end
      }))
    end
  end,
  in_pool = function(self)
    return Sculio.count_enhanced('m_Sculio_experimental') > 0
  end,
}