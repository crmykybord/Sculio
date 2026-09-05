SMODS.Joker {
  key = 'led',
  attributes = { 'mult', 'shop', 'scaling' },
  eternal_compat = true,
  blueprint_compat = false,
  perishable_compat = false,
  rental_compat = true,
  config = { extra = { mult = 0, gain = 1 } },
  unlocked = true,
  discovered = false,
  rarity = 1, -- Common
  atlas = 'Sculio',
  pos = { x = 7, y = 6 },
  cost = 4,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.mult, card.ability.extra.gain } }
  end,
  calculate = function(self, card, context)
    -- Only cards count as purchases: vouchers and booster packs are not cards.
    if context.buying_card and not context.blueprint and context.card and not context.buying_self then
      local set = context.card.ability.set
      if set ~= 'Booster' and set ~= 'Voucher' then
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
    end
    if context.joker_main and card.ability.extra.mult > 0 then
      return { mult = card.ability.extra.mult }
    end
  end
}
