SMODS.Joker {
  key = 'mahjong',

  config = { extra = { chips = 0, chips_gain = 5, less_than = 7 } },
  unlocked = true,
  discovered = false,
  rarity = 1, -- Common
  atlas = 'Sculio',
  pos = { x = 3, y = 4 },
  cost = 3,
  blueprint_compat = true,
  perishable_compat = false,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.chips, card.ability.extra.chips_gain, card.ability.extra.less_than } }
  end,
  calculate = function(self, card, context)
    if context.before and (#context.full_hand == 2 or #context.full_hand == 4) then
      local less_than_count = 0

      for i = 1, #context.full_hand do
        local this_card = context.full_hand[i]

        if this_card.config.center == G.P_CENTERS.m_stone then
          -- Stone cards should not count as either higher or less than a number.
          return
        end

        if this_card:get_id() < card.ability.extra.less_than then
          less_than_count = less_than_count + 1
        end
      end

      if less_than_count == #context.full_hand / 2 then
        card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_gain
        return {
          message = localize('k_upgrade_ex'),
          colour = G.C.CHIPS
        }
      end
    end

    if context.joker_main and card.ability.extra.chips > 0 then
      return {
        chip_mod = card.ability.extra.chips,
        message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
      }
    end
  end
}
