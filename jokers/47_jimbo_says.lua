-- Roll a random suit that can make a Flush (5+ suited cards in the full deck).
-- Crossmod-safe: counts base.suit keys present in the deck instead of a fixed
-- suit list, so custom suits work. Falls back to any present suit.
local function roll_suit(card)
  local counts = {}
  for _, v in ipairs(G.playing_cards or {}) do
    if v.base and v.base.suit and not SMODS.has_no_suit(v) then
      counts[v.base.suit] = (counts[v.base.suit] or 0) + 1
    end
  end
  local flushable, any = {}, {}
  for suit, n in pairs(counts) do
    any[#any + 1] = suit
    if n >= 5 then flushable[#flushable + 1] = suit end
  end
  table.sort(any)
  table.sort(flushable)
  local pool = #flushable > 0 and flushable or any
  if #pool > 0 then
    card.ability.extra.suit = pseudorandom_element(pool, pseudoseed('jimbo_says'))
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
  cost = 8,
  loc_vars = function(self, info_queue, card)
    local current_suit = card.ability.extra.suit
    local suit_obj = SMODS.Suits and SMODS.Suits[current_suit]
    local name = (suit_obj and suit_obj.loc_txt and suit_obj.loc_txt.plural)
      or localize(current_suit, 'suits_plural')
      or current_suit
    local colour = (G.C.SUITS and G.C.SUITS[current_suit]) or G.C.UI.TEXT_LIGHT
    return { vars = { name }, colours = { colour } }
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

        if hand_name:find('Flush', 1, true) then
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
