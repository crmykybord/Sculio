SMODS.Consumable {
  key = 'twilight',
  set = 'Inverted',
  atlas = 'Sculio_Consumables',
  pos = { x = 9, y = 1 },
  unlocked = true,
  discovered = false,
  cost = 3,
  loc_vars = function(self, info_queue, card)
    local per = Sculio.distorted() and 4 or 2
    local stacks = math.floor(Sculio.count_suit_deck('Hearts') / 10)
    return { vars = { 10, stacks * per, per } }
  end,
  can_use = function(self, card)
    return G.playing_cards and #G.playing_cards > 0
      and math.floor(Sculio.count_suit_deck('Hearts') / 10) >= 1
  end,
  use = function(self, card, area, copier)
    Sculio.track_inverted_use(card)
    local per = Sculio.distorted() and 4 or 2
    local stacks = math.floor(Sculio.count_suit_deck('Hearts') / 10)
    local options = {}
    for _, center in pairs(G.P_CENTERS) do
      if center.set == 'Enhanced' and not center.no_rank and Sculio.in_pool(center) then
        options[#options + 1] = center.key
      end
    end
    -- Shallow copy: copy_table() deep-copies Cards and recurses forever on card.area cycles
    local targets = {}
    for _, c in ipairs(G.playing_cards) do targets[#targets + 1] = c end
    pseudoshuffle(targets, pseudoseed('sculio_twilight'))
    for i = 1, math.min(stacks * per, #targets) do
      local target_card = targets[i]
      local in_hand = target_card.area == G.hand
      if in_hand then
        G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.4, func = function()
          if not target_card.REMOVED then
            target_card:flip()
            play_sound('card1', 1, 0.6)
          end
          return true
        end }))
      end
      G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.15, func = function()
        local enh_key = SMODS.poll_enhancement({ key = 'sculio_twilight' .. i, guaranteed = true, options = options })
        if enh_key then
          target_card:set_ability(G.P_CENTERS[enh_key], false)
          target_card:juice_up(0.3, 0.5)
        end
        return true
      end }))
      if in_hand then
        G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.15, func = function()
          if not target_card.REMOVED then
            target_card:flip()
            play_sound('tarot2', 1, 0.6)
          end
          return true
        end }))
      end
    end
    delay(0.45 * math.min(stacks * per, #targets))
  end,
}
