SMODS.Joker {
  key = 'jokerium',

  config = { extra = { black_holes_per_cycle = 1, boss_blinds_per_cycle = 1, boss_blinds_since_last_cycle = 0 } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 4, y = 2 },
  cost = 7,
  blueprint_compat = true,
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.e_negative
    info_queue[#info_queue+1] = G.P_CENTERS.c_black_hole
    return { vars = { card.ability.extra.black_holes_per_cycle, card.ability.extra.boss_blinds_per_cycle, card.ability.extra.boss_blinds_per_cycle - card.ability.extra.boss_blinds_since_last_cycle } }
  end,
  calculate = function(self, card, context)
    if context.end_of_round and not context.repetition and context.game_over == false and G.GAME.blind.boss then
      card.ability.extra.boss_blinds_since_last_cycle = card.ability.extra.boss_blinds_since_last_cycle + 1

      if card.ability.extra.boss_blinds_since_last_cycle >= card.ability.extra.boss_blinds_per_cycle then
        card.ability.extra.boss_blinds_since_last_cycle = 0

        for i = 1, card.ability.extra.black_holes_per_cycle, 1 do
          G.E_MANAGER:add_event(Event({
            delay = 0.0,
            func = function()
              local card = create_card('Spectral', G.consumeables, nil, nil, nil, nil, 'c_black_hole')
              card:set_edition({negative = true}, true)
              card:add_to_deck()
              G.consumeables:emplace(card)
              return true
            end
          }))
        end

        return {
            message = '+' .. card.ability.extra.black_holes_per_cycle .. ' Black Hole',
            colour = G.C.SECONDARY_SET.Spectral
        }
      else
        return {
          message = card.ability.extra.boss_blinds_since_last_cycle .. '/' .. card.ability.extra.boss_blinds_per_cycle,
          colour = G.C.FILTER
        }
      end
    end
  end
}
