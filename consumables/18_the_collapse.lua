SMODS.Consumable {
  key = 'collapse',
  set = 'Inverted',
  atlas = 'Sculio_Consumables',
  pos = { x = 7, y = 1 },
  unlocked = true,
  discovered = false,
  cost = 3,
  loc_vars = function(self, info_queue, card)
    local step = Sculio.distorted() and 5 or 10
    local stacks = math.floor(Sculio.count_suit_deck('Diamonds') / step)
    return { vars = { step, stacks }, key = Sculio.distorted_key(self) }
  end,
  can_use = function(self, card)
    local step = Sculio.distorted() and 5 or 10
    return G.hand and #G.hand.cards > 0
      and math.floor(Sculio.count_suit_deck('Diamonds') / step) >= 1
  end,
  use = function(self, card, area, copier)
    Sculio.track_inverted_use(card)
    local step = Sculio.distorted() and 5 or 10
    local stacks = math.floor(Sculio.count_suit_deck('Diamonds') / step)
    -- Shallow copy: copy_table() deep-copies Cards and recurses forever on card.area cycles
    local targets = {}
    for _, c in ipairs(G.hand.cards) do targets[#targets + 1] = c end
    pseudoshuffle(targets, pseudoseed('sculio_collapse'))
    for i = 1, math.min(stacks, #targets) do
      local target_card = targets[i]
      G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.15, func = function()
        local edition = SMODS.poll_edition({ key = 'sculio_collapse' .. i, no_negative = true, guaranteed = true })
        if edition and not target_card.REMOVED then
          target_card:set_edition(edition, true)
          if Sculio.distorted() then
            -- Distorted Flow: affected cards pay $1 when scored (SMODS perma bonus, Aperol-style)
            target_card.ability.perma_p_dollars = (target_card.ability.perma_p_dollars or 0) + 1
          end
          target_card:juice_up(0.3, 0.5)
        end
        return true
      end }))
    end
    delay(0.45 * math.min(stacks, #targets))
  end,
}
