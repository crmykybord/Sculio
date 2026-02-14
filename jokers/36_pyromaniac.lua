SMODS.Joker {
  key = 'pyromaniac',

  config = { extra = { levels_to_increase = 1 } },
  unlocked = true,
  discovered = false,
  rarity = 3, -- Rare
  atlas = 'Sculio',
  pos = { x = 7, y = 3 },
  cost = 10,
  blueprint_compat = true,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.levels_to_increase } }
  end,
  calculate = function(self, card, context)
    if context.first_hand_drawn and not context.blueprint then
      local eval = function() return G.GAME.current_round.hands_played == 0 end
      juice_card_until(card, eval, true)
    end

    if context.before then
      if G.GAME.current_round.hands_played == 0 then
        -- Based off of Obelisk.
        local most_played = true
        local most_played_count = (G.GAME.hands[context.scoring_name].played or 0)

        for k, v in pairs(G.GAME.hands) do
          if k ~= context.scoring_name and v.played >= most_played_count and v.visible then
            most_played = false
          end
        end

        if most_played then
          local text, disp_text = context.scoring_name

          for i = 1, card.ability.extra.levels_to_increase, 1 do
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex')})
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(text, 'poker_hands'),chips = G.GAME.hands[text].chips, mult = G.GAME.hands[text].mult, level=G.GAME.hands[text].level})
            level_up_hand(context.blueprint_card or card, text, nil, 1)
          end

          card.ability.extra.burn_hand = true
        end
      end
    end

    if context.destroying_card and not context.blueprint and card.ability.extra.burn_hand then
      return { remove = true }
    end

    if context.after then
      card.ability.extra.burn_hand = nil
    end
  end
}
