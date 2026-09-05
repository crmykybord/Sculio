SMODS.Enhancement {
  key = 'divine',
  atlas = 'centers',
  pos = { x = 6, y = 0 },
  prefix_config = { atlas = false },

  config = {},
  loc_vars = function(self, info_queue, card)
    return { vars = { 7, 3 } }
  end,
  calculate = function(self, card, context)
    -- Mode alternates between hands
    if context.before and context.cardarea == G.hand and not context.blueprint then
      local hand_id = tostring(G.GAME.round_resets.ante) .. ':' .. (G.GAME.current_round.hands_left or 0)
      if G.GAME.Sculio_divine_hand_id ~= hand_id then
        G.GAME.Sculio_divine_hand_id = hand_id
        G.GAME.Sculio_divine_mode = (G.GAME.Sculio_divine_mode == 'chips') and 'mult' or 'chips'
      end
    end
    -- While held in hand, buff the scoring cards with the current mode
    if context.main_scoring and context.cardarea == G.hand and not card.debuff then
      if G.GAME.Sculio_divine_mode == 'mult' then
        return { mult = 3 }
      else
        return { chips = 7 }
      end
    end
  end,
}
