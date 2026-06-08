SMODS.Joker {
  key = 'joker_metro',

  config = { extra = { mult = 0, current_hand_index = 1 } },
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
    local next_mult = card.ability.extra.current_hand_index * 2
    return { vars = { card.ability.extra.mult, next_mult, localize(current_hand, 'poker_hands') } }
  end,
  calculate = function(self, card, context)
    local hand_order = { 'High Card', 'Pair', 'Two Pair', 'Three of a Kind', 'Straight', 'Flush', 'Four of a Kind' }
    local current_hand = hand_order[card.ability.extra.current_hand_index] or 'High Card'
    
    if context.before and not context.blueprint then
      if context.scoring_name == current_hand then
        -- Played the required hand, add mult based on position and advance
        local mult_gain = card.ability.extra.current_hand_index * 2
        card.ability.extra.mult = card.ability.extra.mult + mult_gain
        
        -- Advance to next hand in sequence
        card.ability.extra.current_hand_index = card.ability.extra.current_hand_index + 1
        if card.ability.extra.current_hand_index > #hand_order then
          card.ability.extra.current_hand_index = 1 -- Loop back to start
        end
        
        return {
          message = localize('k_upgrade_ex'),
          colour = G.C.MULT
        }
      end
    end
    
    if context.joker_main and card.ability.extra.mult > 0 then
      return { mult_mod = card.ability.extra.mult, message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } } }
    end
  end
}
