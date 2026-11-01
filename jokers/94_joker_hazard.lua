SMODS.Joker {
  key = 'joker_hazard',
  attributes = { 'chance', 'destroy_card', 'hand_size' },
  eternal_compat = true,
  blueprint_compat = false,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = { gain = 1, max = 4, hand_size_bonus = 0, odds = 3 } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 5, y = 9 },
  cost = 7,
  loc_vars = function(self, info_queue, card)
    local n, d = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'joker_hazard')
    return { vars = { n, d, card.ability.extra.gain, card.ability.extra.hand_size_bonus, card.ability.extra.max } }
  end,
  add_to_deck = function(self, card, from_debuff)
    if card.ability.extra.hand_size_bonus > 0 then
      G.hand:change_size(card.ability.extra.hand_size_bonus)
    end
  end,
  remove_from_deck = function(self, card, from_debuff)
    if card.ability.extra.hand_size_bonus > 0 then
      G.hand:change_size(-card.ability.extra.hand_size_bonus)
    end
  end,
  calculate = function(self, card, context)
    if context.end_of_round and context.main_eval and not context.game_over then
      if SMODS.pseudorandom_probability(card, 'joker_hazard', 1, card.ability.extra.odds, 'joker_hazard') then
        local idx
        if G.jokers and G.jokers.cards then
        for i, joker in ipairs(G.jokers.cards) do
          if joker == card then idx = i break end
        end
        end
        local left = idx and G.jokers.cards[idx - 1]
        if left and not left.getting_sliced and not SMODS.is_eternal(left, card) then
          left.getting_sliced = true
          Sculio.destroy_joker(left)
          if card.ability.extra.hand_size_bonus < card.ability.extra.max then
            card.ability.extra.hand_size_bonus = card.ability.extra.hand_size_bonus + card.ability.extra.gain
            G.hand:change_size(card.ability.extra.gain)
            return {
              message = localize { type = 'variable', key = 'a_handsize', vars = { card.ability.extra.gain } },
              colour = G.C.BLUE,
            }
          end
          return { message = localize('k_eaten_ex'), colour = G.C.MULT }
        end
      end
    end
  end
}
