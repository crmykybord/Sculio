SMODS.Joker {
  key = 'googly_eyes',
  attributes = { 'mult', 'rank' },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  config = { },
  unlocked = true,
  discovered = false,
  rarity = 1, -- Common
  atlas = 'Sculio',
  pos = { x = 6, y = 4 },
  cost = 4,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
      -- Check if this is the first scored card
      local is_first = true
      for i = 1, #context.scoring_hand do
        if context.scoring_hand[i] == context.other_card then
          break
        end
        -- If we find a non-debuffed card before this one, it's not first
        if not context.scoring_hand[i].debuff then
          is_first = false
          break
        end
      end

      if is_first and not context.other_card.debuff then
        local base_chips = context.other_card.base.nominal or 0
        if base_chips > 0 then
          return { mult = base_chips } }
        end
      end
    end
  end
}
