SMODS.Joker {
  key = 'critical_failure',
  attributes = { 'xmult', 'chance', 'reset', 'enhancements' },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = false,
  rental_compat = true,
  config = { extra = { x_mult = 1, x_mult_gain = 0.25 } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 6, y = 3 },
  cost = 8,
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_lucky
    return { vars = { card.ability.extra.x_mult, card.ability.extra.x_mult_gain } }
  end,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and context.other_card.config.center == G.P_CENTERS.m_lucky and not context.blueprint then
      if not context.other_card.lucky_trigger then
        card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_gain

        return { extra = {focus = card, message = localize('k_upgrade_ex'), colour = G.C.MULT}, card = card }
      elseif card.ability.extra.x_mult > 1 then
        card.ability.extra.x_mult = 1

        return { extra = {focus = card, message = localize('k_reset'), colour = G.C.MULT}, card = card }
      end
    end

    if context.joker_main and card.ability.extra.x_mult > 1 then
      return { xmult = card.ability.extra.x_mult, message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult } } }
    end
  end
}
