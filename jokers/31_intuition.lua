SMODS.Joker {
  key = 'intuition',
  attributes = { 'economy', 'xmult', 'enhancements' },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = { gold_dollars = 10, steel_x_mult = 3 } },
  unlocked = true,
  discovered = false,
  rarity = 3, -- Rare
  atlas = 'Sculio',
  pos = { x = 2, y = 3 },
  cost = 9,
  in_pool = function(self, args)
    if G.playing_cards then
      for _, card in ipairs(G.playing_cards) do
        if SMODS.has_enhancement(card, 'm_gold') or SMODS.has_enhancement(card, 'm_steel') then
          return true
        end
      end
    end
  end,
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_gold
    info_queue[#info_queue+1] = G.P_CENTERS.m_steel
    return { vars = { card.ability.extra.gold_dollars, card.ability.extra.steel_x_mult } }
  end,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and not context.other_card.debuff then
      if SMODS.has_enhancement(context.other_card, 'm_gold') then
        if Sculio.find_first_enhanced(context.scoring_hand, 'm_gold') == context.other_card then
          return {
            dollars = card.ability.extra.gold_dollars,
            card = card
          }
        end
      elseif SMODS.has_enhancement(context.other_card, 'm_steel') then
        if Sculio.find_first_enhanced(context.scoring_hand, 'm_steel') == context.other_card then
          return { xmult = card.ability.extra.steel_x_mult, card = card }
        end
      end
    end
  end
}
