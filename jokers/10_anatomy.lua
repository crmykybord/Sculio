SMODS.Joker {
  key = 'anatomy',
  loc_txt = {
    name = 'Anatomy',
    text = {
      'Scored {C:attention}number cards{} have',
      '{C:green}#1#% of their rank out of #2#{}',
      'to be retriggered once'
    }
  },

  config = { extra = { odds = 10 } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 9, y = 0 },
  cost = 7,
  blueprint_compat = true,
  loc_vars = function(self, info_queue, card)
    local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'anatomy')
    return { vars = { numerator * 100, denominator } }
  end,
  calculate = function(self, card, context)
    if context.cardarea == G.play and context.repetition and not context.repetition_only then
      local card_id = context.other_card:get_id()

      if card_id < 11 then
        local n, d = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'anatomy')
        -- careful: multiply the numerator `n` by card_id after any modifications to `n`.
        if SMODS.pseudorandom_probability(card, 'anatomy', n * card_id, d, nil, true) then
          return {
            message = localize('k_again_ex'),
            repetitions = 1
          }
        end
      end
    end
  end
}
