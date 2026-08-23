SMODS.Enhancement {
  key = 'siege',
  atlas = 'centers',
  pos = { x = 5, y = 0 },
  prefix_config = { atlas = false },

  no_rank = true,
  no_suit = true,
  replace_base_card = true,
  always_scores = true,

  config = { extra = { reward = nil } },
  loc_vars = function(self, info_queue, card)
    return { vars = { 2, 4, 6 } }
  end,
  calculate = function(self, card, context)
    -- Immune to debuffs
    if context.debuff_card and context.other_card == card then
      return { prevent_debuff = true }
    end
    -- Part of the hand that defeated the Blind: earn a reward by Blind type
    if context.after and context.cardarea == G.play then
      if G.GAME.blind and G.GAME.chips and G.GAME.blind.chips and G.GAME.chips >= G.GAME.blind.chips then
        local blind_type = G.GAME.blind:get_type()
        card.ability.extra.reward = (blind_type == 'Small' and 2) or (blind_type == 'Big' and 4) or 6
      end
    end
    if context.playing_card_end_of_round and card.ability.extra.reward then
      local reward = card.ability.extra.reward
      card.ability.extra.reward = nil
      return { dollars = reward }
    end
  end,
}
