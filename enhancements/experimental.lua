SMODS.Enhancement {
  key = 'experimental',
  atlas = 'centers',
  pos = { x = 5, y = 1 },
  prefix_config = { atlas = false },

  config = { extra = { count = 0, max = 7 } },
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.m_Sculio_lead
    local extra = card and card.ability and card.ability.extra or self.config.extra
    return { vars = { extra.count, extra.max } }
  end,
  calculate = function(self, card, context)
    if context.main_scoring and context.cardarea == G.play then
      card.ability.extra.count = card.ability.extra.count + 1
      if card.ability.extra.count >= card.ability.extra.max then
        G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.3, func = function()
          add_tag(Tag(pseudorandom_element(G.P_TAGS, pseudoseed('sculio_experimental'))))
          return true
        end }))
        G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.3, func = function()
          card:set_ability(G.P_CENTERS.m_Sculio_lead, false)
          card:juice_up(0.3, 0.5)
          return true
        end }))
        return { message = localize('k_upgrade_ex'), colour = G.C.FILTER }
      end
      return { message = card.ability.extra.count .. '/' .. card.ability.extra.max, colour = G.C.FILTER }
    end
  end,
}
