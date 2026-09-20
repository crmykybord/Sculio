SMODS.Joker {
  key = 'pop_star',
  attributes = { 'modify_card', 'enhancements', 'chance' },
  config = { extra = { odds = 4 } },
  unlocked = true,
  discovered = false,
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 6, y = 0 },
  cost = 7,
  loc_vars = function(self, info_queue, card)
    local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'pop_star')
    return { vars = { numerator, denominator } }
  end,
  calculate = function(self, card, context)
    if context.after and not context.blueprint then
      local to_enhance = {}
      for _, v in ipairs(context.scoring_hand) do
        if not v.debuff and v.config.center_key == 'c_base' and SMODS.pseudorandom_probability(card, 'pop_star', 1, card.ability.extra.odds) then
          to_enhance[#to_enhance + 1] = { card = v, enhancement = SMODS.poll_enhancement({guaranteed = true, key = 'pop_star_enh'}) }
        end
      end
      if #to_enhance > 0 then
        local cards_to_flip = {}
        for _, e in ipairs(to_enhance) do cards_to_flip[#cards_to_flip + 1] = e.card end
        Sculio.flip_highlighted(card, cards_to_flip, function()
          for _, e in ipairs(to_enhance) do
            if not e.card.REMOVED then e.card:set_ability(e.enhancement, nil, true) end
          end
        end)
      end
    end
  end
}
