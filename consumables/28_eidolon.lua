-- Eidolon: 1 in N roll to hand the run a Cloning Tag. Vanilla rule from the
-- DOX applies: check G.P_TAGS before building Tag(nil).
SMODS.Spectral {
  key = 'eidolon',
  atlas = 'Sculio_Consumables',
  pos = { x = 8, y = 2 },
  cost = 4,
  config = { extra = { odds = 3 } },
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_TAGS['tag_Sculio_cloning']
    return { vars = { 1, card.ability.extra.odds } }
  end,
  use = function(self, card, area, copier)
    if SMODS.pseudorandom_probability(card, 'eidolon', 1, card.ability.extra.odds) then
      G.E_MANAGER:add_event(Event({ func = function()
        local key = 'tag_Sculio_cloning'
        if G.P_TAGS[key] then add_tag(Tag(key)) end
        play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
        return true
      end }))
      card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize('k_Sculio_plus_tag'), colour = G.C.GREEN })
    else
      card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize('k_nope_ex'), colour = G.C.RED })
    end
  end,
}
