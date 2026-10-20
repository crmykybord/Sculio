-- Quincunx: rolls ONE random seal and ONE random edition, slaps both on up to
-- two blank cards in hand (vanilla-style randomness: you do not choose), then
-- destroys a random Joker. Eternals are immune (vanilla Hex convention).
SMODS.Spectral {
  key = 'quincunx',
  atlas = 'Sculio_Consumables',
  pos = { x = 5, y = 2 },
  cost = 4,
  config = { extra = { cards = 2 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.cards } }
  end,
  can_use = function(self, card)
    return Sculio.hand_selection_state()
      and G.hand and #Sculio.blank_in_hand() > 0
      and #Sculio.destroyable_jokers() > 0
  end,
  use = function(self, card, area, copier)
    -- Shallow copy: copy_table() deep-copies Cards and recurses forever on card.area cycles
    local targets = Sculio.blank_in_hand()
    pseudoshuffle(targets, pseudoseed('sculio_quincunx'))
    local picked = {}
    for i = 1, math.min(card.ability.extra.cards, #targets) do picked[i] = targets[i] end

    local seal = SMODS.poll_seal({ key = 'sculio_quincunx', guaranteed = true })
    local edition = SMODS.poll_edition({ key = 'sculio_quincunx_ed', no_negative = true, guaranteed = true })

    Sculio.flip_highlighted(card, picked, function()
      for _, c in ipairs(picked) do
        if not c.REMOVED then
          if seal then c:set_seal(seal, true) end
          if edition then c:set_edition(copy_table(edition), true) end
        end
      end
    end)

    local jokers = Sculio.destroyable_jokers()
    local victim = jokers[math.floor(pseudoseed('sculio_quincunx_joker') * #jokers) + 1]
    if victim then
      G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.5, func = function()
        if not victim.REMOVED then Sculio.destroy_joker(victim) end
        return true
      end }))
    end
  end,
}
