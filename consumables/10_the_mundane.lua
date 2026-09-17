SMODS.Consumable {
  key = 'mundane',
  set = 'Inverted',
  atlas = 'Sculio_Consumables',
  pos = { x = 9, y = 0 },
  unlocked = true,
  discovered = false,
  cost = 3,
  loc_vars = function(self, info_queue, card)
    local pct = Sculio.distorted() and 0.5 or 0.3
    local cap = Sculio.distorted() and 50 or 30
    local refund = math.min(math.ceil((G.GAME.Sculio_ante_spend or 0) * pct), cap)
    return { vars = { math.floor(pct * 100), cap, refund } }
  end,
  can_use = function(self, card)
    return true
  end,
  use = function(self, card, area, copier)
    Sculio.track_inverted_use(card)
    local pct = Sculio.distorted() and 0.5 or 0.3
    local cap = Sculio.distorted() and 50 or 30
    local refund = math.min(math.ceil((G.GAME.Sculio_ante_spend or 0) * pct), cap)
    if refund > 0 then
      ease_dollars(refund)
      G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.4, func = function()
        card:juice_up(0.3, 0.5)
        return true
      end }))
    end
  end,
}
