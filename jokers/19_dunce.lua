SMODS.Joker {
  key = 'dunce',
  attributes = { 'copying' },
  unlocked = true,
  discovered = false,
  rarity = 3, -- Rare
  atlas = 'Sculio',
  pos = { x = 0, y = 2 },
  cost = 10,
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  loc_vars = function(self, info_queue, card)
    local last_joker = G.jokers and G.jokers.cards and G.jokers.cards[#G.jokers.cards]
    if last_joker and last_joker ~= card and last_joker.config.center.blueprint_compat then
      card.ability.blueprint_compat = 'compatible'
    else
      card.ability.blueprint_compat = 'incompatible'
    end
    card.ability.blueprint_compat_ui = card.ability.blueprint_compat_ui or ''
    card.ability.blueprint_compat_check = nil
    return {
      main_end = (card.area and card.area == G.jokers) and {
        {n=G.UIT.C, config={align = "bm", minh = 0.4}, nodes={
          {n=G.UIT.C, config={ref_table = card, align = "m", colour = G.C.JOKER_GREY, r = 0.05, padding = 0.06, func = 'blueprint_compat'}, nodes={
            {n=G.UIT.T, config={ref_table = card.ability, ref_value = 'blueprint_compat_ui', colour = G.C.UI.TEXT_LIGHT, scale = 0.32*0.8}},
          }}
        }}
      } or nil,
    }
  end,
  calculate = function(self, card, context)
    if context.before then
      for i = 1, #G.jokers.cards do
        if G.jokers.cards[i] == card then
          local next_i = i + 1
          local next_joker = G.jokers.cards[next_i]

          if next_joker then
            next_joker:set_debuff(true)
          end
          card.ability.debuffed_card = next_joker
        end
      end
    end

    if context.final_scoring_step then
      G.E_MANAGER:add_event(Event({
        func = function()
          if card.ability.debuffed_card then
            card.ability.debuffed_card:set_debuff(false)
          end

          return true
        end
      }))
    end

    local last_joker = G.jokers.cards[#G.jokers.cards]

    if last_joker and last_joker ~= card then
      return SMODS.blueprint_effect(card, last_joker, context)
    end
  end
}
