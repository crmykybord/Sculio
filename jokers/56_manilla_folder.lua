SMODS.Joker {
  key = 'manilla_folder',
  attributes = { 'consumables', 'secret_hand' },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = {} },
  unlocked = true,
  discovered = false,
  rarity = 3,
  atlas = 'Sculio',
  pos = { x = 8, y = 5 },
  cost = 7,
  loc_vars = function(self, info_queue, card)
    return { vars = {} }
  end,
  calculate = function(self, card, context)
    if context.evaluate_poker_hand and not context.blueprint then
      local hand_name = context.scoring_name
      local secret_hands = {
        ['Five of a Kind'] = true,
        ['Flush Five'] = true,
        ['Flush House'] = true
      }
      if secret_hands[hand_name] then
        G.E_MANAGER:add_event(Event({
          func = function()
            for i = 1, #G.consumeables.cards do
              G.consumeables.cards[i]:remove()
            end
            G.consumeables.cards = {}
            local num_slots = G.consumeables.config.card_limit or 3
            for i = 1, num_slots do
              if pseudorandom('manilla_folder_type') < 0.9 then
                local consume_type = pseudorandom('manilla_folder_consumable')
                local new_consumable
                if consume_type < 0.4 then
                  new_consumable = SMODS.create_card({ set = 'Tarot', rarity = 1, no_soul = true })
                elseif consume_type < 0.7 then
                  new_consumable = SMODS.create_card({ set = 'Planet', rarity = 1, no_soul = true })
                else
                  new_consumable = SMODS.create_card({ set = 'Spectral', rarity = 1, no_soul = true })
                end
                if new_consumable then
                  G.consumeables:emplace(new_consumable)
                end
              else
                local new_consumable = SMODS.create_card({ set = 'Spectral', rarity = 1, no_soul = true })
                if new_consumable then
                  G.consumeables:emplace(new_consumable)
                end
              end
            end
            return true
          end
        }))
      end
    end
  end
}
