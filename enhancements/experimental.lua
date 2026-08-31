SMODS.Enhancement {
  key = 'experimental',
  atlas = 'Sculio_Enhancements',
  pos = { x = 1, y = 0 },

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
        if sendDebugMessage then sendDebugMessage('Sculio: experimental -> lead (count ' .. card.ability.extra.count .. ')', 'SCULIO') end
        G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.3, func = function()
          local tag_pool = get_current_pool('Tag')
          local selected_tag = pseudorandom_element(tag_pool, pseudoseed('sculio_experimental'))
          local it = 1
          while selected_tag == 'UNAVAILABLE' do
            it = it + 1
            selected_tag = pseudorandom_element(tag_pool, pseudoseed('sculio_experimental_resample' .. it))
          end
          local tag = Tag(selected_tag, false, 'Small')
          add_tag(tag)
          play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
          play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
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
