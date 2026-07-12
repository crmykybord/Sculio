SMODS.Joker {
  key = 'joker_of_nothing',
  attributes = { 'xmult', 'king' },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = { x_mult_per_rank = 0.2 } },
  unlocked = true,
  discovered = false,
  rarity = 3,
  atlas = 'Sculio',
  pos = { x = 1, y = 6 },
  cost = 8,
  loc_vars = function(self, info_queue, card)
    local missing_ranks = 0
    local existing_ranks = {}
    if G.playing_cards then
      for _, c in ipairs(G.playing_cards) do
        local rank = c:get_id()
        existing_ranks[rank] = true
      end
      for i = 2, 14 do
        if not existing_ranks[i] then
          missing_ranks = missing_ranks + 1
        end
      end
    else
      missing_ranks = 13
    end
    local total_xmult = 1 + (card.ability.extra.x_mult_per_rank * missing_ranks)
    return { vars = { card.ability.extra.x_mult_per_rank, missing_ranks, total_xmult } }
  end,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
      if context.other_card:get_id() == 13 then
        local missing_ranks = 0
        local existing_ranks = {}
        if G.playing_cards then
          for _, c in ipairs(G.playing_cards) do
            local rank = c:get_id()
            existing_ranks[rank] = true
          end
          for i = 2, 14 do
            if not existing_ranks[i] then
              missing_ranks = missing_ranks + 1
            end
          end
        else
          missing_ranks = 13
        end
        local total_xmult = 1 + (card.ability.extra.x_mult_per_rank * missing_ranks)
        return { xmult = total_xmult, card = card }
      end
    end
  end
}
