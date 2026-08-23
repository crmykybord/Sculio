SMODS.Consumable {
  key = 'collapse',
  set = 'Inverted',
  atlas = 'Sculio_Consumables',
  pos = { x = 7, y = 1 },
  unlocked = true,
  discovered = false,
  cost = 3,
  loc_vars = function(self, info_queue, card)
    local stacks = math.floor(Sculio.count_suit_deck('Diamonds') / 10)
    return { vars = { 10, stacks } }
  end,
  can_use = function(self, card)
    return G.playing_cards and #G.playing_cards > 0
      and math.floor(Sculio.count_suit_deck('Diamonds') / 10) >= 1
  end,
  use = function(self, card, area, copier)
    local stacks = math.floor(Sculio.count_suit_deck('Diamonds') / 10)
    local targets = copy_table(G.playing_cards)
    pseudoshuffle(targets, pseudoseed('sculio_collapse'))
    for i = 1, math.min(stacks, #targets) do
      local target_card = targets[i]
      G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.4, func = function()
        local edition = SMODS.poll_edition({ key = 'sculio_collapse' .. i, no_negative = true, guaranteed = true })
        if edition then
          target_card:set_edition(edition, true)
          target_card:juice_up(0.3, 0.5)
        end
        return true
      end }))
    end
    delay(0.45 * math.min(stacks, #targets))
  end,
}
