SMODS.Joker {
  key = 'effigy',
  attributes = { 'copying' },
  eternal_compat = true,
  blueprint_compat = false,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = { random_joker_key = nil } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 5, y = 2 },
  cost = 8,
  loc_vars = function(self, info_queue, card)
    local key = card.ability.extra.random_joker_key
    local name = key and G.localization.descriptions.Joker[key] and G.localization.descriptions.Joker[key].name
      or localize('k_Sculio_none')
    return { vars = { name } }
  end,
  add_to_deck = function(self, card, from_debuff)
    card.ability.extra.random_joker_key = nil
  end,
  remove_from_deck = function(self, card, from_debuff)
    card.ability.extra.random_joker_key = nil
  end,
  calculate = function(self, card, context)
    if context.after and not context.blueprint and context.cardarea == G.jokers then
      local bp_jokers = {}
      local all_jokers = {}

      for i = 1, #G.jokers.cards do
        local this_joker = G.jokers.cards[i]
        if this_joker ~= card then
          table.insert(all_jokers, this_joker)
          if this_joker.config.center.blueprint_compat then
            table.insert(bp_jokers, this_joker)
          end
        end
      end

      local pool = #bp_jokers > 0 and bp_jokers or all_jokers
      local chosen = pool[pseudorandom('scheming_idol', 1, #pool)]
      card.ability.extra.random_joker_key = chosen and chosen.config.center_key or nil
    end

    if card.ability.extra.random_joker_key and not context.blueprint then
      local jokers = SMODS.find_card(card.ability.extra.random_joker_key)
      local target = jokers and jokers[1]
      if target then
        return SMODS.blueprint_effect(card, target, context)
      else
        card.ability.extra.random_joker_key = nil
      end
    end
  end
}
