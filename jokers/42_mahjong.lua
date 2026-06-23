SMODS.Joker {
  key = 'mahjong',
  attributes = { 'chips', 'rank', "scaling" },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = false,
  rental_compat = true,
  config = { extra = { chips = 0, chips_gain = 5 } },
  unlocked = true,
  discovered = false,
  rarity = 1, -- Common
  atlas = 'Sculio',
  pos = { x = 3, y = 4 },
  cost = 3,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.chips, card.ability.extra.chips_gain } }
  end,
  calculate = function(self, card, context)
    if context.before then
      -- Count ranks to find pairs
      local rank_counts = {}
      local has_pair_above_7 = false
      local has_pair_below_7 = false

      for i = 1, #context.full_hand do
        local this_card = context.full_hand[i]

        if this_card.config.center == G.P_CENTERS.m_stone then
          -- Stone cards don't count
          goto continue
        end

        local id = this_card:get_id()
        rank_counts[id] = (rank_counts[id] or 0) + 1

        ::continue::
      end

      -- Check for pairs above and below 7
      for rank, count in pairs(rank_counts) do
        if count >= 2 then
          if rank > 7 then
            has_pair_above_7 = true
          end
          if rank < 7 then
            has_pair_below_7 = true
          end
        end
      end

      if has_pair_above_7 and has_pair_below_7 then
        card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_gain
        return { message = localize('k_upgrade_ex'), colour = G.C.CHIPS }
      end
    end

    if context.joker_main and card.ability.extra.chips > 0 then
      return { chips = card.ability.extra.chips, message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}} }
    end
  end
}
