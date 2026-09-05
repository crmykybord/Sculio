SMODS.Joker {
  key = 'joker_watching',
  attributes = { 'retrigger' },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  config = {},
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 6, y = 6 },
  cost = 6,
  calculate = function(self, card, context)
    if context.repetition and context.cardarea == G.play then
      for _, h in ipairs(G.hand and G.hand.cards or {}) do
        if h.base.id == 14 and not h.debuff then
          return {
            message = localize('k_again_ex'),
            repetitions = 1,
            card = card
          }
        end
      end
    end
  end
}
