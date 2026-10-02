local mult_cards_scored = {}

SMODS.Joker {
  key = 'nervous_wreck',
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
    if context.before then mult_cards_scored = {} end
    if context.individual and not context.repetition
        and context.cardarea == G.play and context.other_card
        and SMODS.has_enhancement(context.other_card, 'm_mult') then
      local c = context.other_card
      mult_cards_scored[c] = math.max(mult_cards_scored[c] or 0, (c.repetition_trigger or 0) + 1)
    end
    if context.retrigger_joker_check and context.other_card == card
        and context.other_context and context.other_context.joker_main then
      local n = 0
      for _, times in pairs(mult_cards_scored) do n = n + times end
      -- `remove_default_message` drops SMODS' built-in "Again" bubble. Every retrigger
      -- used to spawn one, which both clutters the hand and stalls the scoring queue.
      if n > 0 then return { repetitions = n, remove_default_message = true } end
    end
    if context.joker_main then
      return { x_mult = card.ability.extra.x_mult }
    end
  end,
  in_pool = function(self)
    return Sculio.count_enhanced('m_mult') > 0
  end,
}
