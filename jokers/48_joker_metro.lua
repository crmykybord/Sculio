SMODS.Joker {
  key = 'joker_metro',

  config = { extra = { mult = 0, mult_gain = 2, current_hand_index = 1, times_played = 0 } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 0, y = 5 },
  cost = 7,
  blueprint_compat = true,
  perishable_compat = false,
  loc_vars = function(self, info_queue, card)
    local hand_order = { 'High Card', 'Pair', 'Two Pair', 'Three of a Kind', 'Straight', 'Flush', 'Four of a Kind' }
    local current_hand = hand_order[card.ability.extra.current_hand_index] or 'High Card'
    return { vars = { card.ability.extra.mult, card.ability.extra.mult_gain, localize(current_hand, 'poker_hands') } }
  end,
  calculate = function(self, card, context)
    local hand_order = { 'High Card', 'Pair', 'Two Pair', 'Three of a Kind', 'Straight', 'Flush', 'Four of a Kind' }
    local current_hand = hand_order[card.ability.extra.current_hand_index] or 'High Card'
    
    if context.before and not context.blueprint then
      if context.scoring_name == current_hand then
        -- Played the current hand, add current gain and increase next gain
        card.ability.extra.times_played = card.ability.extra.times_played + 1
        card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
        card.ability.extra.mult_gain = card.ability.extra.mult_gain + 2
        return {
          message = localize('k_upgrade_ex'),
          colour = G.C.MULT
        }
      else
        -- Played a different hand, check if we should advance
        local next_hand_index = nil
        for i, hand in ipairs(hand_order) do
          if hand == context.scoring_name then
            next_hand_index = i
            break
          end
        end
        
        if next_hand_index and next_hand_index == card.ability.extra.current_hand_index + 1 then
          -- Advanced to next hand in sequence
          card.ability.extra.current_hand_index = next_hand_index
          card.ability.extra.times_played = 1
          card.ability.extra.mult_gain = 2 -- Reset gain to base
          card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain -- Add the base gain
          return {
            message = localize('k_upgrade_ex'),
            colour = G.C.MULT
          }
        end
      end
    end
    
    if context.joker_main and card.ability.extra.mult > 0 then
      return { mult_mod = card.ability.extra.mult, message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } } }
    end
  end
}
