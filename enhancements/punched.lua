SMODS.Enhancement {
  key = 'punched',
  atlas = 'Sculio_Enhancements',
  pos = { x = 0, y = 1 },

  config = { extra = { x_mult = 1.5 } },
  loc_vars = function(self, info_queue, card)
    local extra = card and card.ability and card.ability.extra or {}
    return { vars = { extra.x_mult or 1.5 } }
  end,
  calculate = function(self, card, context)
    if context.discard and context.other_card == card then
      return { remove = true }
    end
    if context.main_scoring and context.cardarea == G.play then
      return { x_mult = card.ability.extra.x_mult, }
    end
  end,
}
