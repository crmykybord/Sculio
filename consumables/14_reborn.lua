SMODS.Consumable {
  key = 'reborn',
  set = 'Inverted',
  atlas = 'Sculio_Consumables',
  pos = { x = 3, y = 1 },
  unlocked = true,
  discovered = false,
  cost = 3,
  loc_vars = function(self, info_queue, card)
    return { vars = { 1, 3 } }
  end,
  can_use = function(self, card)
    return G.playing_cards and #G.playing_cards >= 4
  end,
  use = function(self, card, area, copier)
    local victim = pseudorandom_element(G.playing_cards, pseudoseed('sculio_reborn_v'))
    if not victim then return end
    local mods = {
      enhancement = (victim.config.center_key ~= 'c_base') and victim.config.center_key or nil,
      seal = victim.seal,
      edition = victim.edition and copy_table(victim.edition) or nil,
    }
    local picked = Sculio.pick_modifier(mods, 'sculio_reborn_m', 100 / 3)
    local targets = {}
    for _, c in ipairs(G.playing_cards) do
      if c ~= victim then targets[#targets + 1] = c end
    end
    pseudoshuffle(targets, pseudoseed('sculio_reborn_t'))
    for i = 1, math.min(3, #targets) do
      local target_card = targets[i]
      G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.3, func = function()
        Sculio.apply_modifier(target_card, picked)
        return true
      end }))
    end
    G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.4, func = function()
      SMODS.destroy_cards(victim)
      return true
    end }))
    delay(1.0)
  end,
}
