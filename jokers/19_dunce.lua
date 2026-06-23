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
    local last_joker = G.jokers and G.jokers.cards[#G.jokers.cards]
    local name = ''
    local compat = localize('k_Sculio_incompatible')
    if last_joker and last_joker ~= card then
      local joker_key = last_joker.config and last_joker.config.center and last_joker.config.center.key
      name = joker_key and localize({ type = 'name_text', set = 'Joker', key = joker_key }) or (last_joker.ability.name or '')
      compat = last_joker.config.center.blueprint_compat and localize('k_Sculio_compatible') or localize('k_Sculio_incompatible')
    end
    return { vars = { name, compat } }
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
