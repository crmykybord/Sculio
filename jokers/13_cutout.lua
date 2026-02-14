SMODS.Joker {
  key = 'cutout',

  config = { extra = { x_mult = 0.5 } },
  unlocked = true,
  discovered = false,
  rarity = 3, -- Rare
  atlas = 'Sculio',
  pos = { x = 2, y = 1 },
  cost = 8,
  blueprint_compat = true,
  get_x_mult_mod = function(self)
    if G.jokers and #G.jokers.cards > 1 then
      return 1 + (self.config.extra.x_mult * (#G.jokers.cards - 1))
    else
      return 1
    end
  end,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.x_mult, self:get_x_mult_mod(self) } }
  end,
  calculate = function(self, card, context)
    local x_mult_mod = self:get_x_mult_mod(self)

    if context.joker_main and x_mult_mod > 1 then
      return {
        Xmult_mod = x_mult_mod,
        message = localize { type = 'variable', key = 'a_xmult', vars = { x_mult_mod } }
      }
    end
  end
}
