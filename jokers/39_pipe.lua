SMODS.Joker {
  key = 'pipe',

  config = { extra = { rounds_until_active = 2, rounds_elapsed = 0 } },
  unlocked = true,
  discovered = false,
  rarity = 3, -- Rare
  atlas = 'Sculio',
  pos = { x = 0, y = 4 },
  cost = 9,
  eternal_compat = false,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.rounds_until_active, card.ability.extra.rounds_elapsed } }
  end,
  calculate = function(self, card, context)
    -- Based off of Invisible Joker.
    if context.end_of_round and not context.repetition and context.game_over == false and not context.blueprint then
      card.ability.extra.rounds_elapsed = card.ability.extra.rounds_elapsed + 1

      if card.ability.extra.rounds_elapsed >= card.ability.extra.rounds_until_active then
        local eval = function(card) return not card.REMOVED end
        juice_card_until(card, eval, true)
      end

      return {
        message = (card.ability.extra.rounds_elapsed < card.ability.extra.rounds_until_active) and (card.ability.extra.rounds_elapsed .. '/' .. card.ability.extra.rounds_until_active) or localize('k_active_ex'),
        colour = G.C.FILTER
      }
    end

    if context.selling_self and card.ability.extra.rounds_elapsed >= card.ability.extra.rounds_until_active and not context.blueprint then
      -- Based on Ectoplasm.
      local eligible_jokers = {}
      for k, v in pairs(G.jokers.cards) do
        if v.ability.set == 'Joker' and (not v.edition) and v.ability.name ~= 'j_Sculio_pipe' then
          table.insert(eligible_jokers, v)
        end
      end

      local eligible_card = pseudorandom_element(eligible_jokers, pseudoseed('pipe'))

      if eligible_card then
        eligible_card:set_edition({negative = true}, true)
      end
    end
  end
}
