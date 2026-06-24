local hand_order = { 'High Card', 'Pair', 'Two Pair', 'Three of a Kind', 'Straight', 'Flush', 'Four of a Kind' }

SMODS.Joker {
  key = 'joker_metro',
  attributes = { 'mult', 'hand_type', "scaling" },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = false,
  rental_compat = true,
  config = { extra = { mult = 0, gain = 4, gain_increase = 2, current_hand_index = 1 } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 0, y = 5 },
  cost = 7,
  loc_vars = function(self, info_queue, card)
    local current_hand = hand_order[card.ability.extra.current_hand_index] or 'High Card'
    return { vars = { card.ability.extra.mult, card.ability.extra.gain, localize(current_hand, 'poker_hands'), card.ability.extra.gain_increase } }
  end,
  calculate = function(self, card, context)
    local current_hand = hand_order[card.ability.extra.current_hand_index] or 'High Card'

    if context.before and not context.blueprint then
      if context.scoring_name == current_hand then
        -- Played the required hand, add flat gain and advance the cycle
        card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.gain

        card.ability.extra.current_hand_index = card.ability.extra.current_hand_index + 1
        if card.ability.extra.current_hand_index > #hand_order then
          card.ability.extra.current_hand_index = 1 -- Loop back to start
          card.ability.extra.gain = card.ability.extra.gain + card.ability.extra.gain_increase
        end

        return { message = localize('k_upgrade_ex'), colour = G.C.MULT }
      end
    end

    if context.joker_main and card.ability.extra.mult > 0 then
      return { mult = card.ability.extra.mult, message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } } }
    end
  end
}
