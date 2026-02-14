SMODS.Joker {
  key = 'nametag',

  config = { extra = { x_mult = 1, x_mult_gain = 0.15 } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 1, y = 4 },
  cost = 7,
  blueprint_compat = true,
  perishable_compat = false,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.x_mult, card.ability.extra.x_mult_gain } }
  end,
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.selling_card and context.card.ability.set == 'Joker' and context.card ~= card and not context.blueprint then
      card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_gain

      G.E_MANAGER:add_event(Event({
        func = function()
          card_eval_status_text(card, 'extra', nil, nil, nil, { message = '+ ' .. localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult_gain } } })
          return true
        end
      }))
    end

    if context.joker_main then
      return {
        Xmult = card.ability.extra.x_mult
      }
    end
  end
}
