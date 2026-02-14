SMODS.Joker {
  key = 'figurine',

  config = { extra = { chips = 0, mult = 0, x_mult = 1, bonus_mult = 1 } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 3, y = 1 },
  cost = 8,
  blueprint_compat = true,
  perishable_compat = false,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.x_mult, card.ability.extra.bonus_mult * 100 } }
  end,
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.selling_card and context.card ~= card and not context.blueprint then
      local sold_joker = context.card
      local message = nil
      local gain

      if not sold_joker.debuff and sold_joker.edition then
        if sold_joker.edition.type == 'foil' then
          gain = 50 * card.ability.extra.bonus_mult
          message = localize { type = 'variable', key = 'a_chips', vars = { gain } }
          card.ability.extra.chips = card.ability.extra.chips + gain
        end

        if sold_joker.edition.type == 'holo' then
          gain = 10 * card.ability.extra.bonus_mult
          message = localize { type = 'variable', key = 'a_mult', vars = { gain } }
          card.ability.extra.mult = card.ability.extra.mult + gain
        end

        if sold_joker.edition.type == 'polychrome' then
          gain = 0.5 * card.ability.extra.bonus_mult
          message = '+ ' .. localize { type = 'variable', key = 'a_xmult', vars = { gain } }
          card.ability.extra.x_mult = card.ability.extra.x_mult + gain
        end
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
      return {
        chips = card.ability.extra.chips,
        mult = card.ability.extra.mult,
        Xmult = card.ability.extra.x_mult
      }
    end
  end
}
