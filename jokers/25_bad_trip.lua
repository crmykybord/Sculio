SMODS.Joker {
  key = 'bad_trip',
  attributes = { 'on_sell', "generation" },
  eternal_compat = false,
  blueprint_compat = false,
  perishable_compat = false,
  rental_compat = true,
  config = { extra = { rounds_until_active = 2, rounds_elapsed = 0 } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 6, y = 2 },
  cost = 7,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.rounds_until_active, card.ability.extra.rounds_elapsed } }
  end,
  calculate = function(self, card, context)
    -- Based off of Invisible Joker.
    if context.end_of_round and context.main_eval and not context.game_over and not context.blueprint then
      card.ability.extra.rounds_elapsed = card.ability.extra.rounds_elapsed + 1

      if card.ability.extra.rounds_elapsed >= card.ability.extra.rounds_until_active then
        local eval = function(card) return not card.REMOVED end
        juice_card_until(card, eval, true)
      end

      return { message = (card.ability.extra.rounds_elapsed < card.ability.extra.rounds_until_active) and (card.ability.extra.rounds_elapsed .. '/' .. card.ability.extra.rounds_until_active) or localize('k_active_ex'), colour = G.C.FILTER }
    end

    if context.selling_self and card.ability.extra.rounds_elapsed >= card.ability.extra.rounds_until_active and not context.blueprint then
      local card_code
      for k, v in ipairs(G.deck.cards) do
        card_code, _ = pseudorandom_element(G.P_CARDS, pseudoseed('bad_trip'))
        v:set_base(card_code)
      end

      for k, v in ipairs(G.hand.cards) do
        card_code, _ = pseudorandom_element(G.P_CARDS, pseudoseed('bad_trip'))
        v:set_base(card_code)
      end

      return { message = localize('k_Sculio_bad_trip_randomized') }
    end
  end
}
