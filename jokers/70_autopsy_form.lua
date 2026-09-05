SMODS.Joker {
  key = 'autopsy_form',
  attributes = { 'mult', 'destroy', 'scaling' },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = false,
  rental_compat = true,
  config = { extra = { mult = 8, gain = 8, drain = 1 } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 1, y = 7 },
  cost = 6,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.mult, card.ability.extra.gain, card.ability.extra.drain } }
  end,
  calculate = function(self, card, context)
    if context.remove_playing_cards and not context.blueprint then
      local gained = 0
      for _, c in ipairs(context.removed or {}) do
        if c.ability and c.ability.set == 'Enhanced' then
          gained = gained + 1
        end
      end
      if gained > 0 then
        card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.gain * gained
        return {
          extra = {
            message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.gain * gained } },
            colour = G.C.MULT,
            focus = card
          },
          card = card
        }
      end
    end
    if context.after and not context.blueprint and card.ability.extra.mult > 0 then
      card.ability.extra.mult = math.max(0, card.ability.extra.mult - card.ability.extra.drain)
      return {
        extra = {
          message = localize { type = 'variable', key = 'a_mult_minus', vars = { card.ability.extra.drain } },
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
    for _, c in ipairs(G.playing_cards or {}) do
      if c.ability.set == 'Enhanced' then
        return true
      end
    end
    return false
  end,
}
