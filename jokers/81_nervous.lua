SMODS.Joker {
  key = 'nervous',
  attributes = { 'retrigger', 'mult', 'enhancements' },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = { x_mult = 1.25 } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 3, y = 8 },
  cost = 6,
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.m_mult
    return { vars = { card.ability.extra.x_mult } }
  end,
  calculate = function(self, card, context)
    -- Retrigger self once for each scored Mult Card
    if context.retrigger_joker_check and context.other_card == card
        and context.other_context and context.other_context.joker_main then
      local n = 0
      for _, c in ipairs(context.other_context.scoring_hand or {}) do
        if SMODS.has_enhancement(c, 'm_mult') then n = n + 1 end
      end
      if n > 0 then return { repetitions = n } end
    end
    if context.joker_main then
      return { x_mult = card.ability.extra.x_mult }
    end
  end,
  in_pool = function(self)
    return Sculio.count_enhanced('m_mult') > 0
  end,
}
