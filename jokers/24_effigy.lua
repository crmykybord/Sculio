SMODS.Joker {
  key = 'effigy',
  attributes = { 'copying' },
  eternal_compat = true,
  blueprint_compat = false,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = { random_joker_key = nil } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 5, y = 2 },
  cost = 8,
  loc_vars = function(self, info_queue, card)
    local key = card.ability.extra.random_joker_key
    local center = key and G.P_CENTERS[key]
    local name = center and G.localization.descriptions.Joker[key] and G.localization.descriptions.Joker[key].name
      or localize('k_Sculio_none')
    return {
      vars = { name },
      main_end = (card.area and card.area == G.jokers) and {
        {n=G.UIT.C, config={align = "bm", minh = 0.4}, nodes={
          {n=G.UIT.C, config={align = "m", colour = (center and center.blueprint_compat) and G.C.GREEN or G.C.RED, r = 0.05, padding = 0.06}, nodes={
            {n=G.UIT.T, config={text = name, colour = G.C.UI.TEXT_LIGHT, scale = 0.32*0.8}},
          }}
        }}
      } or nil,
    }
  end,
  add_to_deck = function(self, card, from_debuff)
    card.ability.extra.random_joker_key = nil
  end,
  remove_from_deck = function(self, card, from_debuff)
    card.ability.extra.random_joker_key = nil
  end,
  calculate = function(self, card, context)
    local function is_bp_compat(joker)
      if not (joker and joker.config and joker.config.center) then return false end
      local c = joker.config.center.blueprint_compat
      if c == nil then return true end
      if type(c) == 'function' then
        local ok, res = pcall(c, joker.config.center, joker)
        return ok and res == true
      end
      return c == true
    end

    local function pick_random()
      if not (G.jokers and G.jokers.cards) then
        card.ability.extra.random_joker_key = nil
        return
      end

      local bp_jokers = {}
      for i = 1, #G.jokers.cards do
        local this_joker = G.jokers.cards[i]
        if this_joker ~= card and is_bp_compat(this_joker) then
          table.insert(bp_jokers, this_joker)
        end
      end

      if #bp_jokers > 0 then
        local chosen = bp_jokers[pseudorandom('scheming_idol', 1, #bp_jokers)]
        card.ability.extra.random_joker_key = chosen and chosen.config.center_key or nil
      else
        card.ability.extra.random_joker_key = nil
      end
    end

    -- Pick a compatible joker at the start of the round if none is selected yet.
    if context.setting_blind and not context.blueprint then
      if card.ability.extra.random_joker_key == nil then
        pick_random()
      end
    end

    if context.after and not context.blueprint and context.cardarea == G.jokers
      and G.jokers and G.jokers.cards then
      pick_random()
    end

    if card.ability.extra.random_joker_key and not context.blueprint then
      local jokers = SMODS.find_card(card.ability.extra.random_joker_key)
      local target = jokers and jokers[1]
      if target then
        return SMODS.blueprint_effect(card, target, context)
      else
        card.ability.extra.random_joker_key = nil
      end
    end
  end
}
