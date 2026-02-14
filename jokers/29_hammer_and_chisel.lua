SMODS.Joker {
  key = 'hammer_and_chisel',

  config = { extra = { chip_perma_bonus = 15, shatter_odds = 10 } },
  unlocked = true,
  discovered = false,
  rarity = 1, -- Common
  atlas = 'Sculio',
  pos = { x = 0, y = 3 },
  cost = 6,
  enhancement_gate = 'm_stone',
  blueprint_compat = true,
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_stone
    local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.shatter_odds, 'hammer_and_chisel')
    return { vars = { numerator, denominator, card.ability.extra.chip_perma_bonus } }
  end,
  calculate = function(self, card, context)
    if context.before then
      card.ability.cards_to_shatter = {}
    end

    if context.individual and context.cardarea == G.play and not context.other_card.debuff and context.other_card.config.center == G.P_CENTERS.m_stone then
      if SMODS.pseudorandom_probability(card, 'hammer_and_chisel', 1, card.ability.extra.shatter_odds) then
        table.insert(card.ability.cards_to_shatter, context.other_card)
      end

      -- Based off of Hiker.
      context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus or 0
      context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus + card.ability.extra.chip_perma_bonus

      return {
        extra = {message = localize('k_upgrade_ex'), colour = G.C.CHIPS},
        colour = G.C.CHIPS,
        card = card
      }
    end

    if context.after then
      G.E_MANAGER:add_event(Event({
        func = function()
          for _, card_to_shatter in pairs(card.ability.cards_to_shatter) do
            card_to_shatter:shatter()
          end

          return true
        end
      }))
    end
  end
}
