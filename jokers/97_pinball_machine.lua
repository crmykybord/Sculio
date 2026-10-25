SMODS.Joker {
  key = 'pinball_machine',
  attributes = { 'chips', 'mult', 'money', 'hand_type' },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = { chips = 10, mult = 3, dollars = 1 } },
  unlocked = true,
  discovered = false,
  rarity = 3, -- Rare
  atlas = 'Sculio',
  pos = { x = 8, y = 9 },
  cost = 7,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.dollars } }
  end,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and context.other_card
        and not context.repetition and context.scoring_hand
        and SMODS.in_scoring(context.other_card, context.scoring_hand) then
      local hands = context.poker_hands or {}
      local is_flush = next(hands['Flush'] or {}) or next(hands['Flush House'] or {})
        or next(hands['Straight Flush'] or {}) or next(hands['Royal Flush'] or {})
      if is_flush then
        local roll = pseudorandom('pinball_machine', 1, 3)
        if roll == 1 then
          return { chips = card.ability.extra.chips, card = context.other_card }
        elseif roll == 2 then
          return { mult = card.ability.extra.mult, card = context.other_card }
        else
          return { dollars = card.ability.extra.dollars, card = context.other_card }
        end
      end
    end
  end
}