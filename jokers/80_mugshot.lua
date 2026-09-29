SMODS.Joker {
  key = 'mugshot',
  attributes = { 'economy', 'discard', 'enhancements' },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = { dollars = 3 } },
  unlocked = true,
  discovered = false,
  rarity = 1, -- Common
  atlas = 'Sculio',
  pos = { x = 2, y = 8 },
  cost = 4,
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.m_Sculio_wandering
    return { vars = { card.ability.extra.dollars } }
  end,
  calculate = function(self, card, context)
    if context.discard and context.other_card and not context.other_card.debuff
        and SMODS.has_enhancement(context.other_card, 'm_Sculio_wandering') then
      return { dollars = card.ability.extra.dollars, card = card }
    end
  end,
  in_pool = function(self)
    return Sculio.count_enhanced('m_Sculio_wandering') > 0
  end,
}
