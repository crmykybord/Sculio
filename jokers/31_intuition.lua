SMODS.Joker {
  key = 'intuition',

  config = { extra = { gold_dollar_bonus = 3, steel_x_mult_bonus = 1.5 } },
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
    return { vars = { card.ability.extra.gold_dollar_bonus, card.ability.extra.steel_x_mult_bonus } }
  end,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
      if not context.other_card.debuff then
        if context.other_card.config.center == G.P_CENTERS.m_gold then
          return {
            dollars = card.ability.extra.gold_dollar_bonus,
            card = card
          }
        elseif context.other_card.config.center == G.P_CENTERS.m_steel then
          return {
            x_mult = card.ability.extra.steel_x_mult_bonus,
            card = card
          }
        end
      end
    end
  end
}
