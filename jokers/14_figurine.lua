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
  rental_compat = true,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.x_mult, card.ability.extra.x_chips, card.ability.extra.bonus_mult * 100 } }
  end,
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.selling_card and context.card ~= card and not context.blueprint then
      local sold = context.card
      if sold.debuff or not sold.edition then return end
      local message = Sculio.absorb_edition(card, sold, card.ability.extra.bonus_mult)
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
