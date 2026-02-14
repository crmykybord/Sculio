SMODS.Joker {
  key = 'effigy',

  config = { extra = {} },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 5, y = 2 },
  cost = 8,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.before then
      local other_jokers = {}

      for i = 1, #G.jokers.cards do
        local this_joker = G.jokers.cards[i]

        if this_joker ~= card then
          table.insert(other_jokers, this_joker)
        end
      end

      if #other_jokers > 0 and not card.ability.extra.random_joker then
        card.ability.extra.random_joker = other_jokers[pseudorandom('scheming_idol', 1, #other_jokers)]
      end
    end

    if context.after then
      card.ability.extra.random_joker = nil
    end

    if card.ability.extra.random_joker then
      local random_joker_ret = SMODS.blueprint_effect(card, card.ability.extra.random_joker, context)
      return random_joker_ret
    end
  end
}
