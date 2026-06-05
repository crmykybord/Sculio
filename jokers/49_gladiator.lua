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
    if context.destroying_card and not context.blueprint then
      local base_chips = context.destroying_card.base.nominal or 0
      if base_chips > 0 then
        card.ability.extra.mult = card.ability.extra.mult + base_chips
        return {
          message = localize('k_upgrade_ex'),
          colour = G.C.MULT,
          card = card
        }
      end
    end
    
    if context.joker_main and card.ability.extra.mult > 0 then
      return {
        mult_mod = card.ability.extra.mult,
        message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
      }
    end
  end
}
