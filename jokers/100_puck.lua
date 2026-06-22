SMODS.Joker {
  key = 'puck',
  attributes = { 'chips', 'mult', 'xmult', 'xchips', 'editions', "scaling" },
  config = { extra = { chips = 0, mult = 0, x_mult = 1, x_chips = 1, bonus_mult = 1 } },
  unlocked = true,
  discovered = false,
  rarity = 4, -- Legendary
  atlas = 'Sculio',
  pos = { x = 8, y = 1 },
  soul_pos = { x = 9, y = 1 },
  cost = 20,
  blueprint_compat = true,
  perishable_compat = false,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.x_mult, card.ability.extra.x_chips, card.ability.extra.bonus_mult * 100 } }
  end,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and not context.blueprint then
      local ed = context.other_card.edition
      if not ed or context.other_card.debuff then return end
      local ed_key = ed.type or ed.key
      local ed_center = G.P_CENTERS[ed_key] or G.P_CENTERS['e_'..ed_key]
      if not ed_center then return end
      local cfg = ed_center.config
      local bonus = card.ability.extra.bonus_mult
      local message, gain
      if cfg.chips and cfg.chips > 0 then
        gain = cfg.chips * bonus
        card.ability.extra.chips = card.ability.extra.chips + gain
        message = localize({ type = 'variable', key = 'a_chips', vars = { gain } })
      elseif cfg.mult and cfg.mult > 0 then
        gain = cfg.mult * bonus
        card.ability.extra.mult = card.ability.extra.mult + gain
        message = localize({ type = 'variable', key = 'a_mult', vars = { gain } })
      elseif cfg.x_mult and cfg.x_mult > 1 then
        gain = (cfg.x_mult - 1) * bonus
        card.ability.extra.x_mult = card.ability.extra.x_mult + gain
        message = '+ ' .. localize({ type = 'variable', key = 'a_xmult', vars = { gain } })
      elseif (cfg.x_chips and cfg.x_chips > 1) or (cfg.Xchips and cfg.Xchips > 1) then
        local xchips_val = cfg.x_chips or cfg.Xchips
        gain = (xchips_val - 1) * bonus
        card.ability.extra.x_chips = card.ability.extra.x_chips + gain
        message = '+ ' .. localize({ type = 'variable', key = 'a_xchips', vars = { gain } })
      end
      if message then
        return { extra = { message = message, focus = card }, card = card }
      end
    end
    if context.joker_main then
      return { chips = card.ability.extra.chips, mult = card.ability.extra.mult, xmult = card.ability.extra.x_mult, x_chips = card.ability.extra.x_chips }
    end
  end
}
