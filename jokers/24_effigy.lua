SMODS.Joker {
  key = 'effigy',

  config = { extra = { copying = '' } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 5, y = 2 },
  cost = 8,
  blueprint_compat = true,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.copying } }
  end,
  calculate = function(self, card, context)
    if context.before then
      local bp_jokers = {}
      local all_jokers = {}

      for i = 1, #G.jokers.cards do
        local this_joker = G.jokers.cards[i]
        if this_joker ~= card then
          table.insert(all_jokers, this_joker)
          if this_joker.config.center.blueprint_compat then
            table.insert(bp_jokers, this_joker)
          end
        end
      end

      local pool = #bp_jokers > 0 and bp_jokers or all_jokers

      if #pool > 0 and not card.ability.extra.random_joker then
        card.ability.extra.random_joker = pool[pseudorandom('scheming_idol', 1, #pool)]
        card.ability.extra.copying = card.ability.extra.random_joker.ability.name or ''
      end
    end

    if context.after then
      card.ability.extra.random_joker = nil
      card.ability.extra.copying = ''
    end

    if card.ability.extra.random_joker then
      local random_joker_ret = SMODS.blueprint_effect(card, card.ability.extra.random_joker, context)
      return random_joker_ret
    end
  end
}
