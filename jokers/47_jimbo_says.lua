local function roll_suit(card)
  local valid_cards = {}
  for _, v in ipairs(G.playing_cards or {}) do
    if not SMODS.has_no_suit(v) then valid_cards[#valid_cards + 1] = v end
  end
  if valid_cards[1] then
    card.ability.extra.suit = pseudorandom_element(valid_cards, pseudoseed('jimbo_says')).base.suit
  end
end

SMODS.Joker {
  key = 'jimbo_says',
  attributes = { 'suit', 'tag', 'hand_type' },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = { suit = 'Hearts', triggered_this_round = false } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 9, y = 4 },
  cost = 10,
  loc_vars = function(self, info_queue, card)
    local current_suit = card.ability.extra.suit
    return { vars = { localize(current_suit, 'suits_plural'), colours = { G.C.SUITS[current_suit] } } }
  end,
  add_to_deck = function(self, card, from_debuff)
    roll_suit(card)
  end,
  calculate = function(self, card, context)
    if context.setting_blind and not context.blueprint then
      roll_suit(card)
    end

    if context.before then
      if context.blueprint or not card.ability.extra.triggered_this_round then
        local current_suit = card.ability.extra.suit

        local is_flush = false
        local hand_name = context.scoring_name or ''

        if hand_name == 'Flush' or hand_name == 'Straight Flush' or hand_name == 'Royal Flush' then
          local suit_match = true
          for _, c in ipairs(context.full_hand) do
            if not SMODS.has_enhancement(c, 'm_wild') then
              local card_suit = c:is_suit(current_suit, false, true) and current_suit or c.base.suit
              if card_suit ~= current_suit then
                suit_match = false
                break
              end
            end
          end
          is_flush = suit_match
        end

        if is_flush then
          if not context.blueprint then
            card.ability.extra.triggered_this_round = true
          end

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

    if context.end_of_round and context.main_eval and not context.game_over and not context.blueprint then
      card.ability.extra.triggered_this_round = false
    end
  end
}
