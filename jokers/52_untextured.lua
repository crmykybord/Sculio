SMODS.Joker {
  key = 'untextured',
  attributes = { 'mult', 'full_deck', 'enhancements', "scaling" },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = false,
  rental_compat = true,
  config = { extra = { mult_per_wild = 2 } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 4, y = 5 },
  cost = 6,
  in_pool = function(self)
    if G.playing_cards then
      for _, c in ipairs(G.playing_cards) do
        if SMODS.has_enhancement(c, 'm_wild') then
          return true
        end
      end
    end
    return false
  end,
  loc_vars = function(self, info_queue, card)
    local total_mult = Sculio.count_enhanced('m_wild') * card.ability.extra.mult_per_wild
    return { vars = { card.ability.extra.mult_per_wild, total_mult } }
  end,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
      if SMODS.has_enhancement(context.other_card, 'm_wild') then
        local total_mult = Sculio.count_enhanced('m_wild') * card.ability.extra.mult_per_wild
        if total_mult > 0 then
          return { mult = total_mult, }
        end
      end
    end
  end
}
