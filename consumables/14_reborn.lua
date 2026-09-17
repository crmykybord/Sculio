SMODS.Consumable {
  key = 'reborn',
  set = 'Inverted',
  atlas = 'Sculio_Consumables',
  pos = { x = 3, y = 1 },
  unlocked = true,
  discovered = false,
  cost = 3,
  loc_vars = function(self, info_queue, card)
    return { vars = { 1, Sculio.distorted() and 4 or 3 } }
  end,
  can_use = function(self, card)
    return G.hand and #G.hand.cards >= 1 + (Sculio.distorted() and 4 or 3)
  end,
  use = function(self, card, area, copier)
    Sculio.track_inverted_use(card)
    local hand = {}
    for _, c in ipairs(G.hand.cards) do hand[#hand + 1] = c end
    if #hand < 2 then return end

    -- Prefer destroying a modified hand card; only fall back to unmodified ones if none exist.
    local pool = {}
    for _, c in ipairs(hand) do
      if c.config.center_key ~= 'c_base' or c.seal or c.edition then
        pool[#pool + 1] = c
      end
    end
    if #pool == 0 then pool = hand end
    local victim = pseudorandom_element(pool, pseudoseed('sculio_reborn_v'))
    if not victim then return end

    local mods = {
      enhancement = (victim.config.center_key ~= 'c_base') and victim.config.center_key or nil,
      seal = victim.seal,
      edition = victim.edition and copy_table(victim.edition) or nil,
    }
    local picked = Sculio.pick_modifier(mods, 'sculio_reborn_m', 100 / 3)
    if not picked then return end

    local targets = {}
    for _, c in ipairs(hand) do
      if c ~= victim then targets[#targets + 1] = c end
    end
    pseudoshuffle(targets, pseudoseed('sculio_reborn_t'))
    local chosen = {}
    for i = 1, math.min(Sculio.distorted() and 4 or 3, #targets) do
      chosen[#chosen + 1] = targets[i]
    end

    -- Destroy the victim in hand, then flip the remaining hand cards onto which the modifier is copied
    SMODS.destroy_cards(victim)
    delay(0.4)
    Sculio.flip_highlighted(card, chosen, function()
      for _, tc in ipairs(chosen) do
        Sculio.apply_modifier(tc, picked)
      end
    end)
  end,
}
