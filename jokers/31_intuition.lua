SMODS.Joker {
  key = 'intuition',

  config = { extra = { gold_dollars = 10, steel_x_mult = 3 } },
  unlocked = true,
  discovered = false,
  rarity = 3, -- Rare
  atlas = 'Sculio',
  pos = { x = 2, y = 3 },
  cost = 9,
  blueprint_compat = true,
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
        local is_first_gold = false
        for i = 1, #context.scoring_hand do
          if SMODS.has_enhancement(context.scoring_hand[i], 'm_gold') then
            is_first_gold = context.scoring_hand[i] == context.other_card
            break
          end
        end
        if is_first_gold then
          return {
            dollars = card.ability.extra.gold_dollars,
            card = card
          }
        end
      elseif SMODS.has_enhancement(context.other_card, 'm_steel') then
        local is_first_steel = false
        for i = 1, #context.scoring_hand do
          if SMODS.has_enhancement(context.scoring_hand[i], 'm_steel') then
            is_first_steel = context.scoring_hand[i] == context.other_card
            break
          end
        end
        if is_first_steel then
          return {
            x_mult = card.ability.extra.steel_x_mult,
            card = card
          }
        end
      end
    end
  end
}
