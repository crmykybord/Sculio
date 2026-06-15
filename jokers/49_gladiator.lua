SMODS.Joker {
  key = 'gladiator',

  config = { extra = { mult = 0 } },
  unlocked = true,
  discovered = false,
  rarity = 3, -- Rare
  atlas = 'Sculio',
  pos = { x = 1, y = 5 },
  cost = 10,
  blueprint_compat = true,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.mult } }
  end,
  calculate = function(self, card, context)
    if not context.blueprint and context.remove_playing_cards and #context.removed > 0 then
      local mult_gained = 0

      for _, v in ipairs(context.removed) do
        mult_gained = mult_gained + (v.base.nominal or 0)
      end

      if mult_gained > 0 then
        card.ability.extra.mult = card.ability.extra.mult + mult_gained

        return {
          message = localize {
            type = 'variable',
            key = 'a_mult',
            vars = { mult_gained }
          },
          colour = G.C.MULT
        }
      end
    end

    if context.joker_main and card.ability.extra.mult > 0 then
      return { mult = card.ability.extra.mult, message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } } }
    end
  end
}
