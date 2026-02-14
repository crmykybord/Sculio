SMODS.Joker {
  key = 'puck',

  config = { extra = { chips = 0, mult = 0, x_mult = 1, bonus_mult = 1 } },
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
    return { vars = { card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.x_mult, card.ability.extra.bonus_mult * 100 } }
  end,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and not context.blueprint then
      local message = nil

      if not context.other_card.debuff and context.other_card.edition then
        if context.other_card.edition.type == 'foil' then
          local gain = 50 * card.ability.extra.bonus_mult
          message = localize { type = 'variable', key = 'a_chips', vars = { gain } }
          card.ability.extra.chips = card.ability.extra.chips + gain
        end

        if context.other_card.edition.type == 'holo' then
          local gain = 10 * card.ability.extra.bonus_mult
          message = localize { type = 'variable', key = 'a_mult', vars = { gain } }
          card.ability.extra.mult = card.ability.extra.mult + gain
        end

        if context.other_card.edition.type == 'polychrome' then
          local gain = 0.5 * card.ability.extra.bonus_mult
          message = '+ ' .. localize { type = 'variable', key = 'a_xmult', vars = { gain } }
          card.ability.extra.x_mult = card.ability.extra.x_mult + gain
        end
      end

      if message then
        return {
          extra = {
            message = message,
            focus = card
          },
          card = card
        }
      end
    end

    if context.joker_main then
      return {
        chips = card.ability.extra.chips,
        mult = card.ability.extra.mult,
        Xmult = card.ability.extra.x_mult,
      }
    end
  end
}
