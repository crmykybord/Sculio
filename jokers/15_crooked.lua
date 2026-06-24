SMODS.Joker {
  key = 'crooked',
  attributes = { 'hand_size', 'economy' },

  config = { extra = { hand_size_bonus = 3, steal = 3, money_min = 0 } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 4, y = 1 },
  cost = 7,
  eternal_compat = true,
  blueprint_compat = false,
  perishable_compat = true,
  rental_compat = true,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.hand_size_bonus, card.ability.extra.steal, card.ability.extra.money_min } }
  end,
  add_to_deck = function(self, card, from_debuff)
    G.hand:change_size(card.ability.extra.hand_size_bonus)
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.hand:change_size(-card.ability.extra.hand_size_bonus)
  end,
  calculate = function(self, card, context)
    if context.end_of_round and context.main_eval and not context.game_over and not context.blueprint then
      ease_dollars(-card.ability.extra.steal)

      if to_big(G.GAME.dollars - card.ability.extra.steal) <= to_big(card.ability.extra.money_min) then
        Sculio.destroy_joker(card)

        return { message = 'Stole $' .. card.ability.extra.steal .. ', bailed!', colour = G.C.FILTER }
      else
        return { message = 'Stole $' .. card.ability.extra.steal, colour = G.C.FILTER }
      end
    end
  end
}
