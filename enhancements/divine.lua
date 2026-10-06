SMODS.Enhancement {
  key = 'divine',
  atlas = 'centers',
  pos = { x = 6, y = 0 },
  prefix_config = { atlas = false },
  config = { extra = { money = 1 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.money } }
  end,
  calculate = function(self, card, context)
    if context.main_scoring and context.cardarea == G.play and not card.debuff
        and not card.repetition_trigger then
      local extra = card.ability.extra
      local suits = {}
      for _, c in ipairs(context.full_hand or context.scoring_hand or {}) do
        local suit = c.base and c.base.suit
        if suit then suits[suit] = true end
      end
      local unique = 0
      for _ in pairs(suits) do unique = unique + 1 end
      if unique > 0 then return { money = extra.money * unique } end
    end
  end,
}