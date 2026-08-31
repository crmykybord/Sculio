SMODS.Joker {
  key = 'frequent_flyer',
  attributes = { 'mult', 'economy', "scaling" },

  config = { extra = { money_gain = 3, mult = 0, mult_gain = 4, spend_per_gain = 30, spent_since_gain = 0 } },
  unlocked = true,
  discovered = false,
  rarity = 1, -- Common
  atlas = 'Sculio',
  pos = { x = 1, y = 2 },
  cost = 4,
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = false,
  rental_compat = true,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.money_gain, card.ability.extra.mult, card.ability.extra.mult_gain, card.ability.extra.spend_per_gain, card.ability.extra.spent_since_gain } }
  end,
  -- NOTE could look at instances of inc_career_stat('c_shop_dollars_spent', ...)
  -- to accurately determine how much was spent
  calculate = function(self, card, context)
    local rerolls_were_free = rerolls_are_free or G.GAME.current_round.reroll_cost == 0

    if (context.buying_card or context.open_booster or context.reroll_shop) and context.card ~= card then
      -- Token identifies this exact purchase; cost is this trigger's spend
      local token = context.card and tostring(context.card)
          or ('reroll_' .. G.GAME.round .. '_' .. (G.GAME.current_round.reroll_cost or 0))
      local cost = 0
      if context.buying_card or context.open_booster then
        cost = context.card.cost
      elseif context.reroll_shop and not rerolls_were_free then
        cost = G.GAME.current_round.reroll_cost - 1
      end

      if context.blueprint then
        -- Copiers copy only the money, never the scaling. Blueprint sits left of
        -- its target so it runs first: predict the payout from current spent.
        -- If this card already paid this exact trigger (Brainstorm/chains),
        -- match its token instead.
        if card.ability.extra.spent_since_gain + cost >= card.ability.extra.spend_per_gain
            or card.ability.extra.last_money_token == token then
          return { dollars = card.ability.extra.money_gain }
        end
      else
        card.ability.extra.spent_since_gain = card.ability.extra.spent_since_gain + cost

        if card.ability.extra.spent_since_gain >= card.ability.extra.spend_per_gain then
          card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
          card.ability.extra.spent_since_gain = card.ability.extra.spent_since_gain - card.ability.extra.spend_per_gain
          card.ability.extra.last_money_token = token

          return { dollars = card.ability.extra.money_gain, message = localize('k_upgrade_ex') }
        end
      end
    end

    if context.joker_main and card.ability.extra.mult > 0 then
      return { mult = card.ability.extra.mult, message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } } }
    end
  end
}
