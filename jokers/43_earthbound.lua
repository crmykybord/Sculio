-- This works with Four Fingers and Shortcut when the code is copied and pasted.
-- Otherwise, it does not.
-- TODO: Figure out why and remove the copy.
function get_straight_copy(hand)
  local ret = {}
  local four_fingers = next(find_joker('Four Fingers'))
  if #hand > 5 or #hand < (5 - (four_fingers and 1 or 0)) then return ret else
    local t = {}
    local IDS = {}
    for i=1, #hand do
      local id = hand[i]:get_id()
      if id > 1 and id < 15 then
        if IDS[id] then
          IDS[id][#IDS[id]+1] = hand[i]
        else
          IDS[id] = {hand[i]}
        end
      end
    end

    local straight_length = 0
    local straight = false
    local can_skip = next(find_joker('Shortcut')) 
    local skipped_rank = false
    for j = 1, 14 do
      if IDS[j == 1 and 14 or j] then
        straight_length = straight_length + 1
        skipped_rank = false
        for k, v in ipairs(IDS[j == 1 and 14 or j]) do
          t[#t+1] = v
        end
      elseif can_skip and not skipped_rank and j ~= 14 then
          skipped_rank = true
      else
        straight_length = 0
        skipped_rank = false
        if not straight then t = {} end
        if straight then break end
      end
      if straight_length >= (5 - (four_fingers and 1 or 0)) then straight = true end 
    end
    if not straight then return ret end
    table.insert(ret, t)
    return ret
  end
end

SMODS.Joker {
  key = 'earthbound',
  loc_txt = {
    name = 'Auto Battle',
    text = {
      'Automatically selects {C:attention}highest{}',
      '{C:attention}level{} hand available'
    }
  },

  unlocked = true,
  discovered = false,
  rarity = 2, -- Common
  atlas = 'Sculio',
  pos = { x = 4, y = 4 },
  cost = 6,
  get_suits_and_ids = function(self, cards)
    suits = { Hearts = {}, Diamonds = {}, Clubs = {}, Spades = {} }
    ids = {}

    for k, v in ipairs(cards) do
      if v.config.center ~= G.P_CENTERS.m_stone then
        for suit, _ in pairs(suits) do
          if v:is_suit(suit) then
            table.insert(suits[suit], v)
          end
        end

        if not ids[v:get_id()] then
          ids[v:get_id()] = {}
        end

        table.insert(ids[v:get_id()], v)
      end
    end

    local descending_ids = {}

    for i = 14, 2, -1 do
      if ids[i] then
        table.insert(descending_ids, ids[i])
      end
    end

    return suits, descending_ids
  end,
  select_hand = function(self, hand_name, suits, ids)
    if string.find(hand_name, 'Flush') then
      for _, suit_cards in pairs(suits) do
        if #suit_cards >= 5 or (#suit_cards >= 4 and next(find_joker('Four Fingers'))) then
          local flush_suits, flush_ids = self:get_suits_and_ids(suit_cards)

          if hand_name == 'Flush Five' then
            return self:select_hand('Five of a Kind', flush_suits, flush_ids)
          elseif hand_name == 'Flush House' then
            return self:select_hand('Full House', flush_suits, flush_ids)
          elseif hand_name == 'Straight Flush' then
            return self:select_hand('Straight', flush_suits, flush_ids)
          else
            for i = 1, 5 do
              if suit_cards[i] then
                G.hand:add_to_highlighted(suit_cards[i])
              end
            end

            return true
          end
        end
      end
    elseif hand_name == 'Straight' then
      local first_card_of_each_id = {}

      for _, id_cards in pairs(ids) do
        if id_cards and #id_cards >= 1 then
          table.insert(first_card_of_each_id, id_cards[1])
        end
      end

      table.sort(first_card_of_each_id, function(a, b)
        return a:get_id() > b:get_id()
      end)

      for i = 1, #first_card_of_each_id do
        local possible_straight_cards = {}

        for j = i, i + 4 do
          if j <= #first_card_of_each_id then
            table.insert(possible_straight_cards, first_card_of_each_id[j])
          elseif j == #first_card_of_each_id + 1 and #possible_straight_cards < 5 and first_card_of_each_id[1]:get_id() == 14 and first_card_of_each_id[j - 1]:get_id() == 2 then
            -- Ace Low Straight
            table.insert(possible_straight_cards, first_card_of_each_id[1])
          end
        end

        if #possible_straight_cards >= 4 then
          straight_cards = get_straight_copy(possible_straight_cards)

          if #straight_cards >= 1 then
            for k = 1, 5 do
              if possible_straight_cards[k] then
                G.hand:add_to_highlighted(possible_straight_cards[k])
              end
            end

            return true
          end
        end
      end

      return false
    else
      two_of_a_kinds = {}
      three_of_a_kinds = {}
      four_of_a_kinds = {}
      five_of_a_kinds = {}

      for _, id_cards in pairs(ids) do
        if hand_name == 'High Card' and #id_cards >= 1 then
          G.hand:add_to_highlighted(id_cards[1])
          return true
        end

        if #id_cards >= 2 then
          table.insert(two_of_a_kinds, id_cards)
        end

        if #id_cards >= 3 then
          table.insert(three_of_a_kinds, id_cards)
        end

        if #id_cards >= 4 then
          table.insert(four_of_a_kinds, id_cards)
        end

        if #id_cards >= 5 then
          table.insert(five_of_a_kinds, id_cards)
        end
      end

      if hand_name == 'Pair' then
        if #two_of_a_kinds >= 1 then
          G.hand:add_to_highlighted(two_of_a_kinds[1][1])
          G.hand:add_to_highlighted(two_of_a_kinds[1][2])
          return true
        end
      elseif hand_name == 'Three of a Kind' then
        if #three_of_a_kinds >= 1 then
          G.hand:add_to_highlighted(three_of_a_kinds[1][1])
          G.hand:add_to_highlighted(three_of_a_kinds[1][2])
          G.hand:add_to_highlighted(three_of_a_kinds[1][3])
          return true
        end
      elseif hand_name == 'Four of a Kind' then
        if #four_of_a_kinds >= 1 then
          G.hand:add_to_highlighted(four_of_a_kinds[1][1])
          G.hand:add_to_highlighted(four_of_a_kinds[1][2])
          G.hand:add_to_highlighted(four_of_a_kinds[1][3])
          G.hand:add_to_highlighted(four_of_a_kinds[1][4])
          return true
        end
      elseif hand_name == 'Five of a Kind' then
        if #five_of_a_kinds >= 1 then
          G.hand:add_to_highlighted(five_of_a_kinds[1][1])
          G.hand:add_to_highlighted(five_of_a_kinds[1][2])
          G.hand:add_to_highlighted(five_of_a_kinds[1][3])
          G.hand:add_to_highlighted(five_of_a_kinds[1][4])
          G.hand:add_to_highlighted(five_of_a_kinds[1][5])
          return true
        end
      elseif hand_name == 'Two Pair' then
        if #two_of_a_kinds >= 2 then
          G.hand:add_to_highlighted(two_of_a_kinds[1][1])
          G.hand:add_to_highlighted(two_of_a_kinds[1][2])
          G.hand:add_to_highlighted(two_of_a_kinds[2][1])
          G.hand:add_to_highlighted(two_of_a_kinds[2][2])
          return true
        end
      elseif hand_name == 'Full House' then
        if #two_of_a_kinds >= 2 and #three_of_a_kinds >= 1 then
          G.hand:add_to_highlighted(three_of_a_kinds[1][1])
          G.hand:add_to_highlighted(three_of_a_kinds[1][2])
          G.hand:add_to_highlighted(three_of_a_kinds[1][3])

          -- Three of a Kinds are also Two of a Kinds. Make sure not to select the rank twice.
          if two_of_a_kinds[1][1]:get_id() == three_of_a_kinds[1][1]:get_id() then
            G.hand:add_to_highlighted(two_of_a_kinds[2][1])
            G.hand:add_to_highlighted(two_of_a_kinds[2][2])
          else
            G.hand:add_to_highlighted(two_of_a_kinds[1][1])
            G.hand:add_to_highlighted(two_of_a_kinds[1][2])
          end
          return true
        end
      end
    end

    return false
  end,
  calculate = function(self, card, context)
    if context.hand_drawn and not context.blueprint then
      local suits, ids = self:get_suits_and_ids(G.hand.cards)

      local hands_sorted_by_level = {}

      for k, v in pairs(G.GAME.hands) do
        local hand = { name = k, level = v.level, order = v.order }
        table.insert(hands_sorted_by_level, hand)
      end

      table.sort(hands_sorted_by_level, function(a, b)
        if a.level == b.level then
          return a.order < b.order
        end

        return a.level > b.level
      end)

      local selected_hand = nil

      for _, hand in ipairs(hands_sorted_by_level) do
        if self:select_hand(hand.name, suits, ids) then
          selected_hand = hand.name
          break
        end
      end

      if selected_hand then
        update_hand_text({}, {handname=localize(selected_hand, 'poker_hands'),chips = G.GAME.hands[selected_hand].chips, mult = G.GAME.hands[selected_hand].mult, level=G.GAME.hands[selected_hand].level})
      end
    end
  end
}
