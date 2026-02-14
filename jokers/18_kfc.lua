SMODS.Joker {
  key = 'kfc',

  config = { extra = { x_mult = 1, dollar_steal = 1, x_mult_scale = 0.1, dollar_scale = 1 } },
  unlocked = true,
  discovered = false,
  rarity = 3, -- Rare
  atlas = 'Sculio',
  pos = { x = 7, y = 1 },
  cost = 10,
  blueprint_compat = true,
  perishable_compat = false,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.x_mult, card.ability.extra.dollar_steal, card.ability.extra.x_mult_scale, card.ability.extra.dollar_scale } }
  end,
  calculate = function(self, card, context)
    if context.end_of_round and not context.repetition and context.game_over == false and not context.blueprint then
      local stolen = 0

      for k, v in ipairs(G.jokers.cards) do
        if v.ability.name ~= 'j_Sculio_kfc' and v.set_cost and v.sell_cost > 0 then
          local steal
          if v.sell_cost < card.ability.extra.dollar_steal then
            steal = v.sell_cost
          else
            steal = card.ability.extra.dollar_steal
          end

          v.ability.extra_value = (v.ability.extra_value or 0) - steal
          v:set_cost()

          stolen = stolen + steal
        end
      end

      if stolen > 0 then
        card.ability.extra_value = (card.ability.extra_value or 0) + stolen
        card:set_cost()

        local x_mult_gain = card.ability.extra.x_mult_scale * (stolen / card.ability.extra.dollar_scale)
        card.ability.extra.x_mult = card.ability.extra.x_mult + x_mult_gain

        return {
          message = 'Stole $' .. stolen,
          colour = G.C.MONEY
        }
      end
    end

    if context.joker_main and card.ability.extra.x_mult > 1 then
      return {
        Xmult_mod = card.ability.extra.x_mult,
        message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult } }
      }
    end
  end
}
