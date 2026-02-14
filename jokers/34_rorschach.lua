SMODS.Joker {
  key = 'rorschach',

  config = { extra = { card_ids_to_draw_next = {} } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 5, y = 3 },
  cost = 6,
  -- See shuffle.lua for additional implementation code.
  calculate = function(self, card, context)
    if context.first_hand_drawn and not context.blueprint then
      card.ability.extra.card_ids_to_draw_next = {}

      local eval = function() return #card.ability.extra.card_ids_to_draw_next == 0 and not G.RESET_JIGGLES end
      juice_card_until(card, eval, true)
    end

    -- If discarding, this is the rightmost Joker, no cards have been marked for the next blind, this is the first card being discarded in the set, and this is not being copied, then:
    if context.discard and G.jokers.cards[#G.jokers.cards] == card and #card.ability.extra.card_ids_to_draw_next == 0 and context.other_card.ID == context.full_hand[1].ID and not context.blueprint then
      -- Skip if Trading Card is also triggered.
      if #context.full_hand == 1 then
        for i = 1, #G.jokers.cards do
          local joker = G.jokers.cards[i]
      
          if joker and joker.ability.name == 'Trading Card' then
            return
          end
        end
      end

      for _, v in ipairs(context.full_hand) do
        table.insert(card.ability.extra.card_ids_to_draw_next, v.ID)
      end

      return {
        message = 'See you soon!'
      }
    end
  end
}
