SMODS.Joker {
  key = 'leader',

  config = { extra = { current_mult = 0 } },
  unlocked = true,
  discovered = false,
  rarity = 3, -- Rare
  atlas = 'Sculio',
  pos = { x = 5, y = 5 },
  cost = 10,
  blueprint_compat = true,
  loc_vars = function(self, info_queue, card)
    local times_played = G.GAME and G.GAME.hands and G.GAME.hands['High Card'] and G.GAME.hands['High Card'].played or 0
    return { vars = { 2, times_played * 2 } }
  end,
  calculate = function(self, card, context)
    if context.before and context.scoring_name == 'High Card' then
      local times_played = G.GAME.hands['High Card'].played or 0
      local mult_gain = times_played * 2
      card.ability.extra.current_mult = mult_gain
      if mult_gain > 0 then
        local text = context.scoring_name
        G.GAME.hands[text].s_mult = G.GAME.hands[text].s_mult + mult_gain
        G.GAME.hands[text].mult = G.GAME.hands[text].mult + mult_gain
        local mult = mod_mult(G.GAME.hands[text].mult)
        update_hand_text({ delay = 0 }, { chips = hand_chips, mult = mult })
        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {
          message = localize { type = 'variable', key = 'a_mult', vars = { mult_gain } },
          colour = G.C.MULT,
          sound = 'multhit1'
        })
      end
    end

    if context.after and context.scoring_name == 'High Card' then
      local applied = card.ability.extra.current_mult
      if applied > 0 then
        local text = context.scoring_name
        G.GAME.hands[text].s_mult = G.GAME.hands[text].s_mult - applied
        G.GAME.hands[text].mult = G.GAME.hands[text].mult - applied
      end
      card.ability.extra.current_mult = 0
    end
  end
}
