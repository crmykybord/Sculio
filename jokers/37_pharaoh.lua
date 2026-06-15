SMODS.Joker {
  key = 'pharaoh',

  config = { extra = { x_mult_bonus = 1.5 } },
  unlocked = true,
  discovered = false,
  rarity = 3, -- Rare
  atlas = 'Sculio',
  pos = { x = 8, y = 3 },
  cost = 10,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.x_mult_bonus } }
  end,
  add_to_deck = function(self, card, from_debuff)
    if G.hand then
      for _, v in ipairs(G.hand.cards) do
        if not v:is_face() then v:set_debuff(true) end
      end
    end
  end,
  remove_from_deck = function(self, card, from_debuff)
    if G.hand then
      for _, v in ipairs(G.hand.cards) do
        v:set_debuff(false)
      end
    end
  end,
  calculate = function(self, card, context)
    if context.before then
      for _, v in ipairs(G.hand.cards) do
        if not v:is_face() then
          v:set_debuff(true)
        end
      end
    end

    if context.individual and context.cardarea == G.play then
      if not context.other_card.debuff and context.other_card:is_face() then
        return {
          xmult = card.ability.extra.x_mult_bonus,
          card = card
        }
      end
    end
  end
}
