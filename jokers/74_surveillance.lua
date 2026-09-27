SMODS.Joker {
  key = 'surveillance',
  attributes = { 'mult', 'face', 'scaling' },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = { mult = 0, mult_gain = 1 } },
  unlocked = true,
  discovered = false,
  rarity = 1, -- Common
  atlas = 'Sculio',
  pos = { x = 6, y = 7 },
  cost = 4,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.mult_gain, card.ability.extra.mult } }
  end,
  calculate = function(self, card, context)
    if context.hand_drawn and context.first_hand_drawn and not context.blueprint then
      local gained = 0
      for _, c in ipairs(G.hand.cards) do
        if c:is_face() then gained = gained + 1 end
      end
      if gained > 0 then
        local gain = gained * card.ability.extra.mult_gain
        card.ability.extra.mult = card.ability.extra.mult + gain
        return { message = localize { type = 'variable', key = 'a_mult', vars = { gain } }, colour = G.C.RED, card = card }
      end
    end
    if context.joker_main and card.ability.extra.mult > 0 then
      return { mult = card.ability.extra.mult }
    end
  end,
}
