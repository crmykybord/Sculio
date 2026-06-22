SMODS.Joker {
  key = 'pipe',
  attributes = { 'on_sell', 'hands', 'discard', 'editions', "joker", "joker_slot" },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  config = { extra = { rounds_until_active = 2, rounds_elapsed = 0, already_active = false } },
  unlocked = true,
  discovered = false,
  rarity = 3, -- Rare
  atlas = 'Sculio',
  pos = { x = 0, y = 4 },
  cost = 9,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.rounds_until_active, card.ability.extra.rounds_elapsed } }
  end,
  add_to_deck = function(self, card, from_debuff)
    G.GAME.round_resets.hands = G.GAME.round_resets.hands - 1
    ease_hands_played(-1)
    G.GAME.round_resets.discards = G.GAME.round_resets.discards - 1
    ease_discard(-1)
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.GAME.round_resets.hands = G.GAME.round_resets.hands + 1
    ease_hands_played(1)
    G.GAME.round_resets.discards = G.GAME.round_resets.discards + 1
    ease_discard(1)
  end,
  calculate = function(self, card, context)
    -- Based off of Invisible Joker.
    if context.end_of_round and context.main_eval and not context.game_over and not context.blueprint then
      card.ability.extra.rounds_elapsed = card.ability.extra.rounds_elapsed + 1

      local now_active = card.ability.extra.rounds_elapsed >= card.ability.extra.rounds_until_active

      if now_active and not card.ability.extra.already_active then
        card.ability.extra.already_active = true
        local eval = function(card) return not card.REMOVED end
        juice_card_until(card, eval, true)
      end

      return {
        message = (not now_active) and (card.ability.extra.rounds_elapsed .. '/' .. card.ability.extra.rounds_until_active) or localize('k_active_ex'),
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
