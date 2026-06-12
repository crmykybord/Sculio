SMODS.Joker {
  key = 'jimbo_says',

  config = { extra = { suit_index = 1, triggered_this_round = false } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 9, y = 4 },
  cost = 10,
  blueprint_compat = false,
  loc_vars = function(self, info_queue, card)
    local suits = { 'Hearts', 'Clubs', 'Diamonds', 'Spades' }
    local current_suit = suits[card.ability.extra.suit_index] or 'Hearts'
    return { vars = { localize(current_suit, 'suits_plural'), colours = { G.C.SUITS[current_suit] } } }
  end,
  calculate = function(self, card, context)
    if context.before and not context.blueprint then
      if not card.ability.extra.triggered_this_round then
        local suits = { 'Hearts', 'Clubs', 'Diamonds', 'Spades' }
        local current_suit = suits[card.ability.extra.suit_index] or 'Hearts'
        
        -- Check if hand is a flush of current suit
        local is_flush = false
        local hand_name = context.scoring_name or ''
        
        if hand_name == 'Flush' or hand_name == 'Straight Flush' or hand_name == 'Royal Flush' then
          -- Check if all cards match current suit
          local suit_match = true
          for _, c in ipairs(context.full_hand) do
            if c.ability.name ~= 'Wild Card' then
              local card_suit = c.base.suit
              if card_suit ~= current_suit then
                suit_match = false
                break
              end
            end
          end
          is_flush = suit_match
        end
        
        if is_flush then
          card.ability.extra.triggered_this_round = true
          
          -- Create random tag
          G.E_MANAGER:add_event(Event({
            func = function()
              local tag = Tag(get_next_tag_key())
              add_tag(tag)
              play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
              return true
            end
          }))
          
          return { message = localize('k_plus_tag') }
        end
      end
    end
    
    if context.end_of_round and not context.repetition and context.game_over == false and not context.blueprint then
      card.ability.extra.triggered_this_round = false
      -- Cycle to next suit
      card.ability.extra.suit_index = card.ability.extra.suit_index + 1
      if card.ability.extra.suit_index > 4 then
        card.ability.extra.suit_index = 1
      end
    end
  end
}
