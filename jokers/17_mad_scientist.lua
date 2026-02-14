SMODS.Joker {
  key = 'mad_scientist',

  unlocked = true,
  discovered = false,
  rarity = 3, -- Rare
  atlas = 'Sculio',
  pos = { x = 6, y = 1 },
  cost = 9,
  calculate = function(self, card, context)
    -- Based off of Ceremonial Dagger
    if context.setting_blind and not card.debuff and not context.blueprint then
      local my_pos = nil

      for i = 1, #G.jokers.cards do
        if G.jokers.cards[i] == card then my_pos = i; break end
      end

      if my_pos and G.jokers.cards[my_pos + 1] and not card.getting_sliced and not G.jokers.cards[my_pos + 1].ability.eternal and not G.jokers.cards[my_pos + 1].getting_sliced then
        local sliced_card = G.jokers.cards[my_pos + 1]
        sliced_card.getting_sliced = true
        G.GAME.joker_buffer = G.GAME.joker_buffer - 1

        local rarity_index = sliced_card.config.center.rarity
        local legendary = false
        local rarity
        local rarity_text

        if rarity_index == 2 then
          rarity = 0.71
          rarity_text = 'Uncommon'
        elseif rarity_index == 3 then
          rarity = 0.96
          rarity_text = 'Rare'
        elseif rarity_index == 4 then
          rarity = nil
          legendary = true
          rarity_text = 'Legendary'
        else
          rarity = 0
          rarity_text = 'Common'
        end

        G.E_MANAGER:add_event(Event({
          func = function()
            G.GAME.joker_buffer = 0
            card:juice_up(0.8, 0.8)
            sliced_card:start_dissolve({HEX('57ecab')}, nil, 1.6)
            play_sound('tarot1')
            return true
          end
        }))

        -- Based off of Riff-raff
        G.GAME.joker_buffer = G.GAME.joker_buffer + 1

        G.E_MANAGER:add_event(Event({
          func = function()
            local card = create_card('Joker', G.jokers, legendary, rarity, nil, nil, nil, sliced_card.key)
            card:add_to_deck()
            G.jokers:emplace(card)
            card:start_materialize()
            G.GAME.joker_buffer = 0

            return true
          end
        }))

        return { message = rarity_text .. '!' }
      end
    end
  end
}
