SMODS.Joker {
  key = 'frequent_flyer',

  config = { extra = { money_gain = 3, mult = 0, mult_gain = 4, spend_per_gain = 30, spent_since_gain = 0 } },
  unlocked = true,
  discovered = false,
  rarity = 1, -- Common
  atlas = 'Sculio',
  pos = { x = 1, y = 2 },
  cost = 4,
  blueprint_compat = true,
  perishable_compat = false,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.money_gain, card.ability.extra.mult, card.ability.extra.mult_gain, card.ability.extra.spend_per_gain, card.ability.extra.spent_since_gain } }
  end,
  -- NOTE could look at instances of inc_career_stat('c_shop_dollars_spent', ...)
  -- to accurately determine how much was spent
  calculate = function(self, card, context)
    rerolls_were_free = rerolls_are_free or G.GAME.current_round.reroll_cost == 0

    if (context.buying_card or context.open_booster or context.reroll_shop) and not context.blueprint and context.card ~= card then
      if context.buying_card or context.open_booster then
        card.ability.extra.spent_since_gain = card.ability.extra.spent_since_gain + context.card.cost
      elseif context.reroll_shop then
        if not rerolls_were_free then
          card.ability.extra.spent_since_gain = card.ability.extra.spent_since_gain + G.GAME.current_round.reroll_cost - 1
        else
          rerolls_were_free = false
        end
      end

      if card.ability.extra.spent_since_gain >= card.ability.extra.spend_per_gain then
        card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
        card.ability.extra.spent_since_gain = card.ability.extra.spent_since_gain - card.ability.extra.spend_per_gain

        return {
          dollars = card.ability.extra.money_gain,
          message = localize('k_upgrade_ex')
        }
      end
    end

    if context.joker_main and card.ability.extra.mult > 0 then
      return {
        mult_mod = card.ability.extra.mult,
        message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
      }
    end
  end
}
