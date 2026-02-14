SMODS.Joker {
  key = 'dunce',

  unlocked = true,
  discovered = false,
  rarity = 3, -- Rare
  atlas = 'Sculio',
  pos = { x = 0, y = 2 },
  cost = 10,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.before then
      for i = 1, #G.jokers.cards do
        if G.jokers.cards[i] == card then
          local next_i = i + 1
          local next_joker = G.jokers.cards[next_i]

          if next_joker then
            next_joker:set_debuff(true)
          end
          card.ability.debuffed_card = next_joker
        end
      end
    end

    if context.final_scoring_step then
      G.E_MANAGER:add_event(Event({
        func = function()
          if card.ability.debuffed_card then
            card.ability.debuffed_card:set_debuff(false)
          end

          return true
        end
      }))
    end

    local last_joker = G.jokers.cards[#G.jokers.cards]

    if last_joker and last_joker ~= card then
      return SMODS.blueprint_effect(card, last_joker, context)
    end
  end
}
