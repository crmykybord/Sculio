SMODS.Joker {
  key = 'refrigerator',

  unlocked = true,
  discovered = false,
  rarity = 1, -- Common
  atlas = 'Sculio',
  pos = { x = 9, y = 2 },
  cost = 6,
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = { key = 'Sculio_refrigerable_jokers', set = 'Other' }
  end,
  juice_two = function(self, card, other_joker)
    G.E_MANAGER:add_event(Event({
      func = function()
        card:juice_up(0.5, 0.5)
        other_joker:juice_up(0.5, 0.5)
        return true
      end
    }))
  end,
  calculate = function(self, card, context)
    if not context.blueprint then
      for i = 1, #G.jokers.cards do
        if G.jokers.cards[i] == card then
          refrigerator_position = i -- BUG: refrigerator_position is global,
          -- but multiple refrigerators will conflict
          break
        end
      end

      if context.before then
        refrigerator_triggered = false
        return true
      end

      if context.joker_main then
        refrigerator_triggered = true
        return true
      end

      if context.discard then
        for i = refrigerator_position + 1, #G.jokers.cards do
          other_joker = G.jokers.cards[i]

          if other_joker.ability.name == 'Ramen' then
            other_joker.ability.x_mult = other_joker.ability.x_mult + other_joker.ability.extra
            self:juice_two(card, other_joker)
          end
        end
      end

      -- Refrigerator must be placed before the other Joker to be preserved.
      if context.other_joker and refrigerator_triggered then
        other_joker = context.other_joker

        if other_joker.ability.name == 'Ice Cream' then
          other_joker.ability.extra.chips = other_joker.ability.extra.chips + other_joker.ability.extra.chip_mod

          return {
            message = localize{type='variable',key='a_chips',vars={other_joker.ability.extra.chip_mod}},
            colour = G.C.CHIPS,
            focus = other_joker
          }
        elseif other_joker.ability.name == 'Seltzer' then
          other_joker.ability.extra = other_joker.ability.extra + 1

          return {
            message = other_joker.ability.extra .. '',
            colour = G.C.FILTER,
            focus = other_joker
          }
        end
      end

      if context.end_of_round and not context.repetition and context.game_over == false then
        for i = 1, #G.jokers.cards do
          if G.jokers.cards[i] == card then
            refrigerator_position = i
            break
          end
        end

        for i = refrigerator_position + 1, #G.jokers.cards do
          other_joker = G.jokers.cards[i]

          if other_joker.ability.name == 'Popcorn' then
            other_joker.ability.mult = other_joker.ability.mult + other_joker.ability.extra
            self:juice_two(card, other_joker)
          elseif other_joker.ability.name == 'Turtle Bean' then
            other_joker.ability.extra.h_size = other_joker.ability.extra.h_size + other_joker.ability.extra.h_mod
            G.hand:change_size(other_joker.ability.extra.h_mod)
            self:juice_two(card, other_joker)
          end
        end
      end
    end
  end
}
