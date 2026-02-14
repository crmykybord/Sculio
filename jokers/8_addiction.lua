SMODS.Joker {
  key = 'addiction',

  config = { extra = { hand_count_mult = 0.5 } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 7, y = 0 },
  cost = 7,
  blueprint_compat = true,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.hand_count_mult * 100 } }
  end,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
      -- Based off of Obelisk.
      local most_played = true
      local most_played_count = (G.GAME.hands[context.scoring_name].played or 0)

      for k, v in pairs(G.GAME.hands) do
        if k ~= context.scoring_name and v.played >= most_played_count and v.visible then
          most_played = false
        end
      end

      if most_played then
        local perma_bonus_gain = most_played_count * card.ability.extra.hand_count_mult

        -- Based off of Hiker.
        context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus or 0
        context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus + perma_bonus_gain

        return {
          extra = {message = localize('k_upgrade_ex'), colour = G.C.CHIPS},
          colour = G.C.CHIPS,
          card = card
        }
      end
    end
  end
}
