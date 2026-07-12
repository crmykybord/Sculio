SMODS.Joker {
  key = 'intuition',
  attributes = { 'chance', 'enhancements' },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = {} },
  unlocked = true,
  discovered = false,
  rarity = 3,
  atlas = 'Sculio',
  pos = { x = 2, y = 3 },
  cost = 9,
  loc_vars = function(self, info_queue, card)
    return { vars = {} }
  end,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and not context.other_card.debuff then
      local scoring_card = nil
      for _, c in ipairs(context.scoring_hand) do
        if SMODS.has_enhancement(c) then
          scoring_card = c
          break
        end
      end
      if not scoring_card then return nil end

      local held_cards = {}
      for _, c in ipairs(G.hand.cards) do
        if c ~= context.other_card and not c.debuff and not SMODS.has_enhancement(c) then
          table.insert(held_cards, c)
        end
      end
      if #held_cards == 0 then return nil end

      if pseudorandom('intuition_copy') < 0.25 then
        local target_card = held_cards[pseudorandom('intuition_target', 1, #held_cards)]
        if not target_card then return nil end

        local center = G.P_CENTERS[scoring_card.config.center.key]
        if not center or not center.config then return nil end
        local cfg = center.config
        local effect = {}
        -- map scored keys to held-in-hand equivalents
        if cfg.bonus and cfg.bonus ~= 0 then effect.h_chips = (effect.h_chips or 0) + cfg.bonus end
        if cfg.mult and cfg.mult ~= 0 then effect.h_mult = (effect.h_mult or 0) + cfg.mult end
        if cfg.p_dollars and cfg.p_dollars ~= 0 then effect.h_dollars = (effect.h_dollars or 0) + cfg.p_dollars end
        if cfg.x_mult and cfg.x_mult ~= 1 then effect.h_x_mult = cfg.x_mult end
        if cfg.x_chips and cfg.x_chips ~= 1 then effect.h_x_chips = cfg.x_chips end
        -- also pass through native held effects from the enhancement
        if cfg.h_chips and cfg.h_chips ~= 0 then effect.h_chips = (effect.h_chips or 0) + cfg.h_chips end
        if cfg.h_mult and cfg.h_mult ~= 0 then effect.h_mult = (effect.h_mult or 0) + cfg.h_mult end
        if cfg.h_dollars and cfg.h_dollars ~= 0 then effect.h_dollars = (effect.h_dollars or 0) + cfg.h_dollars end
        if cfg.h_x_mult and cfg.h_x_mult ~= 1 then effect.h_x_mult = cfg.h_x_mult end
        if cfg.h_x_chips and cfg.h_x_chips ~= 1 then effect.h_x_chips = cfg.h_x_chips end
        -- fallback: Lucky has empty config, replicate its 1-in-5 mult + 1-in-15 money
        if not next(effect) and scoring_card.config.center.key == 'm_lucky' then
          if pseudorandom('intuition_lucky_mult') < G.GAME.probabilities.normal / 5 then
            effect.h_mult = 20
          end
          if pseudorandom('intuition_lucky_money') < G.GAME.probabilities.normal / 15 then
            effect.h_dollars = 20
          end
        end
        if next(effect) then
          effect.card = card
          return effect
        end
      end
    end
  end
}
