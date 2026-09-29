local function wander_self_discard(card)
  if not card.area or card.area ~= G.hand or card.ability.discarded then return end

  card.ability.Sculio_wandering_self = true
  card:calculate_seal({ discard = true })
  local discarded = { card }
  for _, joker in ipairs(G.jokers.cards) do
    local eval = joker:calculate_joker({ discard = true, other_card = card, full_hand = discarded })
    if eval then
      card_eval_status_text(joker, 'jokers', nil, 1, nil, eval)
    end
  end
  card.ability.Sculio_wandering_self = nil

  card.ability.discarded = true
  inc_career_stat('c_cards_discarded', 1)
  G.GAME.round_scores.cards_discarded.amt = G.GAME.round_scores.cards_discarded.amt + 1
  check_for_unlock({ type = 'discard_custom', cards = discarded })
  draw_card(G.hand, G.discard, 100, 'down', false, card)
end

SMODS.Enhancement {
  key = 'wandering',
  atlas = 'Sculio_Enhancements',
  pos = { x = 4, y = 0 },

  config = {},
  loc_vars = function(self, info_queue, card)
    return { vars = { Sculio.distorted() and 3 or 1 } }
  end,
  calculate = function(self, card, context)
    -- Like The Hook: when a hand is played, leftover Wandering Cards
    -- discard themselves and permanently gain Mult.
    if context.press_play and context.cardarea == G.hand and not card.highlighted and not context.blueprint then
      local per = Sculio.distorted() and 3 or 1
      card.ability.perma_mult = (card.ability.perma_mult or 0) + per
      G.E_MANAGER:add_event(Event({ func = function()
        play_sound('card1', 1)
        wander_self_discard(card)
        return true
      end }))
      return { message = localize('k_upgrade_ex'), colour = G.C.MULT }
    end
    -- Also gains Mult when the player discards it from hand
    if context.discard and context.other_card == card and not card.ability.Sculio_wandering_self then
      local per = Sculio.distorted() and 3 or 1
      card.ability.perma_mult = (card.ability.perma_mult or 0) + per
      return { message = localize('k_upgrade_ex'), colour = G.C.MULT }
    end
  end,
}
