SMODS.Joker {
  key = 'untextured',
  attributes = { 'mult', 'full_deck', 'enhancements', "scaling" },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = false,
  rental_compat = true,
  config = { extra = { mult_per_wild = 2 } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 4, y = 5 },
  cost = 6,
  in_pool = function(self)
    if not G.playing_cards then return false end
    for _, card in ipairs(G.playing_cards) do
      if card.config.center_key == 'm_wild' then return true end
    end
    return false
  end,
  loc_vars = function(self, info_queue, card)
    local wild_count = 0
    if G.playing_cards then
      for _, playing_card in ipairs(G.playing_cards) do
        if playing_card.config.center_key == 'm_wild' then wild_count = wild_count + 1 end
      end
    end
    return { vars = { card.ability.extra.mult_per_wild, card.ability.extra.mult_per_wild * wild_count } }
  end,
  calculate = function(self, card, context)
    if context.joker_main then
      local wild_count = 0
      for _, playing_card in ipairs(G.playing_cards) do
        if playing_card.config.center_key == 'm_wild' then wild_count = wild_count + 1 end
      end
      return { mult = card.ability.extra.mult_per_wild * wild_count, }
    end
  end
}
