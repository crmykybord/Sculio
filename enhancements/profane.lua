SMODS.Enhancement {
  key = 'profane',
  atlas = 'Sculio_Enhancements',
  pos = { x = 5, y = 0 },

  config = { bonus = 0 },
  loc_vars = function(self, info_queue, card)
    return { vars = { 3 } }
  end,
  calculate = function(self, card, context)
    if context.main_scoring and context.cardarea == G.play then
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
          victim.ability.perma_bonus = (victim.ability.perma_bonus or 0) - 3
          victim:juice_up(0.3, 0.4)
          local total = (victim.base.nominal or 0) + (victim.ability.bonus or 0) + (victim.ability.perma_bonus or 0)
          if total <= 0 then SMODS.modify_rank(victim, -1) end
          return true
        end }))
      end
      card.ability.bonus = (card.ability.bonus or 0) + 3
      return {
        chips = 3,
        message = localize { type = 'variable', key = 'a_chips', vars = { 3 } },
        colour = G.C.CHIPS,
      }
    end
  end,
}
