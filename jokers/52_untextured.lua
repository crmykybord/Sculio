SMODS.Joker {
  key = 'untextured',
  attributes = { 'mult', 'full_deck', 'enhancements', "scaling" },

  config = { extra = { mult_per_wild = 2 } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 4, y = 5 },
  cost = 6,
  blueprint_compat = true,
  in_pool = function(self)
    if G.playing_cards then
      for _, c in ipairs(G.playing_cards) do
        if SMODS.has_enhancement(c, 'm_wild') then
          return true
        end
      end
    end
    return false
  end,
  loc_vars = function(self, info_queue, card)
    -- Count wild cards in deck
    local wild_count = 0
    if G.playing_cards then
      for _, c in ipairs(G.playing_cards) do
        if SMODS.has_enhancement(c, 'm_wild') then
          wild_count = wild_count + 1
        end
      end
    end
    return { vars = { card.ability.extra.mult_per_wild, wild_count } }
  end,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
      if SMODS.has_enhancement(context.other_card, 'm_wild') then
        -- Count wild cards in deck
        local wild_count = 0
        if G.playing_cards then
          for _, c in ipairs(G.playing_cards) do
            if SMODS.has_enhancement(c, 'm_wild') then
              wild_count = wild_count + 1
            end
          end
        end

        local total_mult = wild_count * card.ability.extra.mult_per_wild
        if total_mult > 0 then
          return {
            mult = total_mult,
            message = localize { type = 'variable', key = 'a_mult', vars = { total_mult } }
          }
        end
      end
    end
  end
}
