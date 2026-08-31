SMODS.Enhancement {
  key = 'pierced',
  atlas = 'Sculio_Enhancements',
  pos = { x = 6, y = 0 },

  config = {},
  loc_vars = function(self, info_queue, card)
    return { vars = { 2 } }
  end,
  calculate = function(self, card, context)
    local function pierced_in(cards)
      local n = 0
      for _, c in ipairs(cards) do
        if SMODS.has_enhancement(c, 'm_Sculio_pierced') then n = n + 1 end
      end
      return n
    end

    -- 2+ Pierced played together: they destroy each other before scoring
    if context.modify_scoring_hand and context.in_scoring and context.other_card == card then
      local n = pierced_in(context.full_hand)
      if n >= 2 then
        -- never leave an empty scoring hand: first Pierced stays if nothing else would score
        local others_score = false
        for _, c in ipairs(context.full_hand) do
          if not SMODS.has_enhancement(c, 'm_Sculio_pierced') then others_score = true break end
        end
        if others_score or context.full_hand[1] ~= card then
          card.Sculio_pierce_boom = true
          return { remove_from_hand = true }
        end
      end
    end

    if context.before and (context.cardarea == G.play or context.cardarea == 'unscored')
        and card.Sculio_pierce_boom
        and not card.destroyed and not card.getting_sliced then
      card.Sculio_pierce_boom = nil
      G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.3, func = function()
        play_sound('tarot1')
        SMODS.destroy_cards(card, nil, nil, true)
        return true
      end }))
    end

    -- X2 Mult before and after the hand scores
    if context.initial_scoring_step and context.cardarea == G.play then
      return { x_mult = 2 }
    end
    if context.final_scoring_step and context.cardarea == G.play then
      return { x_mult = 2 }
    end
  end,
}
