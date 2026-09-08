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
    local center = key and G.P_CENTERS[key]
    local name = center and G.localization.descriptions.Joker[key] and G.localization.descriptions.Joker[key].name
      or localize('k_Sculio_none')
    card.ability.effigy_copy_ui = name
    return {
      vars = { name },
      main_end = (card.area and card.area == G.jokers) and {
        {n=G.UIT.C, config={align = "bm", minh = 0.4}, nodes={
          {n=G.UIT.C, config={align = "m", colour = (center and center.blueprint_compat) and G.C.GREEN or G.C.RED, r = 0.05, padding = 0.06}, nodes={
            {n=G.UIT.T, config={ref_table = card.ability, ref_value = 'effigy_copy_ui', colour = G.C.UI.TEXT_LIGHT, scale = 0.32*0.8}},
          }}
        }}
      } or nil,
    }
  end,
  add_to_deck = function(self, card, from_debuff)
    card.ability.extra.random_joker_key = nil
  end,
  remove_from_deck = function(self, card, from_debuff)
    card.ability.extra.random_joker_key = nil
  end,
  calculate = function(self, card, context)
    if context.after and not context.blueprint and context.cardarea == G.jokers
      and G.jokers and G.jokers.cards then
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
      if #pool > 0 then
        local chosen = pool[pseudorandom('scheming_idol', 1, #pool)]
        card.ability.extra.random_joker_key = chosen and chosen.config.center_key or nil
      else
        card.ability.extra.random_joker_key = nil
      end
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
