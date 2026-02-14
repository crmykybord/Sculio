SMODS.Joker {
  key = 'pop_star',

  config = { extra = { odds = 4 } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 6, y = 0 },
  cost = 7,
  loc_vars = function(self, info_queue, card)
    local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'pop_star')
    return { vars = { numerator, denominator } }
  end,
  calculate = function(self, card, context)
    if context.before and not context.blueprint then
      for k, v in ipairs(context.scoring_hand) do
        if not v.debuff and SMODS.pseudorandom_probability(card, 'pop_star', 1, card.ability.extra.odds) then
          local enhancement = SMODS.poll_enhancement({guaranteed = true, key = 'pop_star_enh'})
          v:set_ability(enhancement, nil, true)

          G.E_MANAGER:add_event(Event({
            func = function()
              v:juice_up()
              return true
            end
          }))
        end
      end
    end
  end
}
