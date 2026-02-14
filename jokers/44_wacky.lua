SMODS.Joker {
  key = 'wacky',

  config = { extra = { required_chip_percentage = 1.5 } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 5, y = 4 },
  cost = 6,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.required_chip_percentage * 100 } }
  end,
  calculate = function(self, card, context)
    if context.final_scoring_step then
      G.E_MANAGER:add_event(Event({
        func = function()
          card.ability.current_hand_chips = G.GAME.current_round.current_hand.chips
          card.ability.current_hand_mult = G.GAME.current_round.current_hand.mult

          return true
        end
      }))
    end

    if context.end_of_round and not context.repetition and context.game_over == false and not context.blueprint and card.ability.current_hand_chips and card.ability.current_hand_mult then
      local chips = card.ability.current_hand_chips
      local mult = card.ability.current_hand_mult
      local required_score = G.ARGS.score_intensity.required_score

      if G.GAME.selected_back:get_name() == "Plasma Deck" then
        local total = chips + mult
        chips = math.floor(total / 2)
        mult = math.floor(total / 2)
      end

      local score = chips * mult

      if to_big(score) >= to_big(required_score * card.ability.extra.required_chip_percentage) and to_big(required_score) > to_big(0) and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1

        return {
          extra = {
            focus = card,
            message = '+1 Fool',
            func = function()
              G.E_MANAGER:add_event(Event({
                delay = 0.0,
                func = function()
                  local card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, 'c_fool')
                  card:add_to_deck()
                  G.consumeables:emplace(card)
                  G.GAME.consumeable_buffer = 0
                  return true
                end
              }))
            end
          },
          colour = G.C.SECONDARY_SET.Tarot,
          card = card
        }
      end
    end
  end
}
