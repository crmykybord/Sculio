SMODS.Enhancement {
  key = 'profane',
  atlas = 'Sculio_Enhancements',
  pos = { x = 5, y = 0 },

  config = { bonus = 0, extra = { drain = 1, gain = 5, distorted_gain = 8 } },
  loc_vars = function(self, info_queue, card)
    local extra = card and card.ability and card.ability.extra or self.config.extra
    if Sculio.distorted() then
      return { vars = { extra.distorted_gain }, key = Sculio.distorted_key(self) }
    end
    return { vars = { extra.drain, extra.gain }, key = Sculio.distorted_key(self) }
  end,
  calculate = function(self, card, context)
    if context.main_scoring and context.cardarea == G.play then
      local extra = card.ability.extra or self.config.extra
      local gain = Sculio.distorted() and extra.distorted_gain or extra.gain
      -- Distorted Flow: no drain, just a stronger bonus
      if not Sculio.distorted() then
        -- Prefer cards that don't share this enhancement (70-30)
        local different, same = {}, {}
        for _, c in ipairs(G.hand and G.hand.cards or {}) do
          if c ~= card and not c.debuff then
            if SMODS.has_enhancement(c, 'm_Sculio_profane') then
              same[#same + 1] = c
            else
              different[#different + 1] = c
            end
          end
        end
        local pool = pseudorandom('sculio_profane') < 0.7 and different or same
        if not next(pool) then pool = next(different) and different or same end
        local victim = pool and #pool > 0 and pseudorandom_element(pool, pseudoseed('sculio_profane_v'))
        if victim then
          G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.2, func = function()
            -- ponytail: scaling drain, never touches base so deck order is stable
            victim.ability.perma_bonus = (victim.ability.perma_bonus or 0) - extra.drain
            victim:juice_up(0.3, 0.4)
            local total = (victim.base.nominal or 0) + (victim.ability.bonus or 0) + (victim.ability.perma_bonus or 0)
            if total <= 0 then SMODS.modify_rank(victim, -1) end
            return true
          end }))
        end
      else
        -- Distorted Flow: no drain, and heals the negative bonus left on drained cards
        for _, c in ipairs(G.hand and G.hand.cards or {}) do
          if c ~= card and (c.ability.perma_bonus or 0) < 0 then
            c.ability.perma_bonus = 0
            G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.2, func = function()
              c:juice_up(0.3, 0.4)
              return true
            end }))
          end
        end
      end
      card.ability.perma_bonus = (card.ability.perma_bonus or 0) + gain
      return {
        chips = gain,
        message = localize { type = 'variable', key = 'a_chips', vars = { gain } },
        colour = G.C.CHIPS,
      }
    end
  end,
}
