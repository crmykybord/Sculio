SMODS.Joker {
  key = 'dong_fang',
  attributes = { 'mult', 'discard', 'scaling' },
  eternal_compat = true,
  blueprint_compat = false,
  perishable_compat = false,
  rental_compat = true,
  config = { extra = { mult = 0, gain = 1 } },
  unlocked = true,
  discovered = false,
  rarity = 1, -- Common
  atlas = 'Sculio',
  pos = { x = 9, y = 6 },
  cost = 4,
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.m_Sculio_wandering
    return { vars = { card.ability.extra.mult, card.ability.extra.gain } }
  end,
  calculate = function(self, card, context)
    if context.discard and not context.blueprint and context.other_card
        and not context.other_card.debuff
        and SMODS.has_enhancement(context.other_card, 'm_Sculio_wandering') then
      card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.gain
      return {
        extra = {
          message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.gain } },
          colour = G.C.MULT,
          focus = card
        },
        card = card
      }
    end
    if context.joker_main and card.ability.extra.mult > 0 then
      return { mult = card.ability.extra.mult }
    end
  end,
  in_pool = function(self)
    return Sculio.count_enhanced('m_Sculio_wandering') > 0
  end,
}
