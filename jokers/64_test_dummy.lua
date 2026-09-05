SMODS.Joker {
  key = 'test_dummy',
  attributes = { 'xchips', 'scaling', 'destroy' },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = false,
  rental_compat = true,
  config = { extra = { x_chips = 1, x_chips_gain = 0.25 } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 5, y = 6 },
  cost = 6,
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.m_glass
    return { vars = { card.ability.extra.x_chips_gain, card.ability.extra.x_chips } }
  end,
  calculate = function(self, card, context)
    if context.remove_playing_cards and not context.blueprint then
      local gained = 0
      for _, c in ipairs(context.removed or {}) do
        if SMODS.has_enhancement(c, 'm_glass') then
          gained = gained + 1
        end
      end
      if gained > 0 then
        local gain = card.ability.extra.x_chips_gain * gained
        card.ability.extra.x_chips = card.ability.extra.x_chips + gain
        return {
          extra = { message = localize { type = 'variable', key = 'a_xchips', vars = { gain } }, focus = card },
          card = card
        }
      end
    end
    if context.joker_main and card.ability.extra.x_chips > 1 then
      return { x_chips = card.ability.extra.x_chips }
    end
  end,
  in_pool = function(self)
    return Sculio.count_enhanced('m_glass') > 0
  end,
}
