SMODS.Joker {
  key = 'gold_ore',
  attributes = { 'modify_card', 'money', 'enhancements' },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Common
  atlas = 'Sculio',
  pos = { x = 5, y = 0 },
  cost = 6,
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  enhancement_gate = 'm_stone',
  config = { extra = { money = 3 } },
  in_pool = function(self)
    return Sculio.count_enhanced('m_stone') > 0
  end,
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_stone
  end,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and not context.repetition
        and context.other_card and not context.other_card.repetition_trigger
        and SMODS.has_enhancement(context.other_card, 'm_stone') then
      local money = card.ability.extra.money
      ease_dollars(money)
      context.other_card:juice_up(0.3, 0.5)
      card_eval_status_text(context.other_card, 'dollars', money)
    end
  end
}