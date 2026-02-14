SMODS.Joker {
  key = 'prescription',

  config = { extra = { rounds_until_active = 2, rounds_elapsed = 0 } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 1, y = 3 },
  cost = 8,
  eternal_compat = false,
  in_pool = function (self, args)
    return G.GAME.stake >= 4 -- Black Stake
  end,
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = { key = 'Sculio_ailments', set = 'Other' }
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
      for k, v in ipairs(G.jokers.cards) do
        local is_perishable = v.ability.perishable

        v:set_eternal(false)
        v.ability.perishable = false
        v:set_rental(false)

        if is_perishable then
          v:set_debuff(false)
        end
      end
    end
  end
}
