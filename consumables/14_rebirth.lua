SMODS.Consumable {
  key = 'rebirth',
  set = 'Inverted',
  atlas = 'Sculio_Consumables',
  pos = { x = 3, y = 1 },
  unlocked = true,
  discovered = false,
  cost = 3,
  config = { max_highlighted = 2, min_highlighted = 2 },
  loc_vars = function(self, info_queue, card)
    local target_count = Sculio.distorted() and 4 or 3
    return { vars = { Sculio.max_highlighted(card), target_count }, key = Sculio.distorted_key(self) }
  end,
  can_use = function(self, card)
    if not Sculio.can_select(card) then return false end
    local target_count = Sculio.distorted() and 4 or 3
    if #G.hand.cards - #G.hand.highlighted < target_count then return false end
    if Sculio.distorted() then
      for _, source in ipairs(G.hand.highlighted) do
        if source.config.center_key ~= 'c_base' or source.seal or source.edition then
          return true
        end
      end
      return false
    end
    return true
  end,
  use = function(self, card, area, copier)
    Sculio.track_inverted_use(card)
    local distorted = Sculio.distorted()
    local target_count = distorted and 4 or 3
    local sources = {}
    for _, c in ipairs(G.hand.highlighted) do sources[#sources + 1] = c end

    local hand = {}
    for _, c in ipairs(G.hand.cards) do hand[#hand + 1] = c end

    local modifiers = {}
    for i, source in ipairs(sources) do
      local picked = Sculio.pick_modifier({
        enhancement = (source.config.center_key ~= 'c_base') and source.config.center_key or nil,
        seal = source.seal,
        edition = source.edition and copy_table(source.edition) or nil,
      }, 'sculio_reborn_m' .. i, 100 / 3)
      if picked then modifiers[#modifiers + 1] = picked end
    end
    local targets = {}
    for _, c in ipairs(hand) do
      local selected = false
      for _, source in ipairs(sources) do
        if source == c then selected = true break end
      end
      if not selected then
        targets[#targets + 1] = c
      end
    end
    pseudoshuffle(targets, pseudoseed('sculio_reborn_t'))
    local chosen = {}
    for i = 1, math.min(target_count, #targets) do chosen[#chosen + 1] = targets[i] end

    if not distorted then
      for _, source in ipairs(sources) do SMODS.destroy_cards(source) end
      delay(0.4)
    end
    if #modifiers == 0 then return end
    Sculio.flip_highlighted(card, chosen, function()
      for i, target in ipairs(chosen) do
        local picked = pseudorandom_element(modifiers, pseudoseed('sculio_reborn_target' .. i))
        Sculio.apply_modifier(target, picked)
      end
    end)
  end,
}
