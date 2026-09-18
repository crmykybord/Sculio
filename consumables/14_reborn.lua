SMODS.Consumable {
  key = 'reborn',
  set = 'Inverted',
  atlas = 'Sculio_Consumables',
  pos = { x = 3, y = 1 },
  unlocked = true,
  discovered = false,
  cost = 3,
  config = { max_highlighted = 2, min_highlighted = 1 },
  loc_vars = function(self, info_queue, card)
    return { vars = { Sculio.max_highlighted(card) }, key = Sculio.distorted_key(self) }
  end,
  can_use = function(self, card)
    if not Sculio.can_select(card) then return false end
    for _, source in ipairs(G.hand.cards) do
      local selected = false
      for _, target in ipairs(G.hand.highlighted) do
        if target == source then selected = true break end
      end
      if not selected and (source.config.center_key ~= 'c_base' or source.seal or source.edition) then
        return true
      end
    end
    return false
  end,
  use = function(self, card, area, copier)
    Sculio.track_inverted_use(card)
    local distorted = Sculio.distorted()
    local hand = {}
    for _, c in ipairs(G.hand.cards) do hand[#hand + 1] = c end

    local pool = {}
    for _, c in ipairs(hand) do
      local selected = false
      for _, target in ipairs(G.hand.highlighted) do
        if target == c then selected = true break end
      end
      if not selected and (c.config.center_key ~= 'c_base' or c.seal or c.edition) then
        pool[#pool + 1] = c
      end
    end
    local victim = pseudorandom_element(pool, pseudoseed('sculio_reborn_v'))
    if not victim then return end

    local mods = {
      enhancement = (victim.config.center_key ~= 'c_base') and victim.config.center_key or nil,
      seal = victim.seal,
      edition = victim.edition and copy_table(victim.edition) or nil,
    }
    local picked = Sculio.pick_modifier(mods, 'sculio_reborn_m', 100 / 3)
    if not picked then return end

    local chosen = {}
    for _, c in ipairs(G.hand.highlighted) do chosen[#chosen + 1] = c end

    if not distorted then
      SMODS.destroy_cards(victim)
      delay(0.4)
    end
    Sculio.flip_highlighted(card, chosen, function()
      for _, tc in ipairs(chosen) do
        Sculio.apply_modifier(tc, picked)
      end
    end)
  end,
}
