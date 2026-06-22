SMODS.Joker {
  key = 'figurine',
  attributes = { 'chips', 'mult', 'xmult', 'xchips', 'editions', 'scaling' },

  config = { extra = { chips = 0, mult = 0, x_mult = 1, x_chips = 1, bonus_mult = 1 } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 3, y = 1 },
  cost = 8,
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = false,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.x_mult, card.ability.extra.x_chips, card.ability.extra.bonus_mult * 100 } }
  end,
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.selling_card and context.card ~= card and not context.blueprint then
      local sold = context.card
      if sold.debuff or not sold.edition then return end
      local ed_key = sold.edition.type or sold.edition.key
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
        G.E_MANAGER:add_event(Event({
          func = function()
            card_eval_status_text(card, 'extra', nil, nil, nil, { message = message })
            return true
          end
        }))
      end
    end
    if context.joker_main then
      return { chips = card.ability.extra.chips, mult = card.ability.extra.mult, xmult = card.ability.extra.x_mult, x_chips = card.ability.extra.x_chips }
    end
  end
}
