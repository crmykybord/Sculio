SMODS.Consumable {
  key = 'twilight',
  set = 'Inverted',
  atlas = 'Sculio_Consumables',
  pos = { x = 9, y = 1 },
  unlocked = true,
  discovered = false,
  cost = 3,
  loc_vars = function(self, info_queue, card)
    local stacks = math.floor(Sculio.count_suit_deck('Hearts') / 10)
    return { vars = { 10, stacks * 2 } }
  end,
  can_use = function(self, card)
    return G.playing_cards and #G.playing_cards > 0
      and math.floor(Sculio.count_suit_deck('Hearts') / 10) >= 1
  end,
  use = function(self, card, area, copier)
    local stacks = math.floor(Sculio.count_suit_deck('Hearts') / 10)
    local options = {}
    for _, center in pairs(G.P_CENTERS) do
      if center.set == 'Enhanced' and not center.no_rank then
        options[#options + 1] = center.key
      end
    end
    local targets = copy_table(G.playing_cards)
    pseudoshuffle(targets, pseudoseed('sculio_twilight'))
    for i = 1, math.min(stacks * 2, #targets) do
      local target_card = targets[i]
      G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.4, func = function()
        local enh_key = SMODS.poll_enhancement({ key = 'sculio_twilight' .. i, guaranteed = true, options = options })
        if enh_key then
          target_card:set_ability(G.P_CENTERS[enh_key], false)
          target_card:juice_up(0.3, 0.5)
        end
        return true
      end }))
    end
    delay(0.45 * math.min(stacks * 2, #targets))
  end,
}
