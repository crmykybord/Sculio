local Sculio_refrigerator_vanilla_food = {
  j_gros_michel = true,
  j_egg = true,
  j_ice_cream = true,
  j_cavendish = true,
  j_turtle_bean = true,
  j_diet_cola = true,
  j_popcorn = true,
  j_ramen = true,
  j_selzer = true
}

-- Mod-specific food jokers (populate with entries like: j_aij_omlette = true)
local Sculio_refrigerator_modded_food = {
  -- Add modded food jokers here
}

local function Sculio_refrigerator_is_food(card)
  if not card or not card.config or not card.config.center then
    return false
  end

  if PB_UTIL and PB_UTIL.is_food and PB_UTIL.is_food(card) then
    return true
  end

  local center = card.config.center

  if center.pools and center.pools.Food then
    return true
  end

  return Sculio_refrigerator_vanilla_food[center.key] or Sculio_refrigerator_modded_food[center.key] or false
end

local function Sculio_refrigerator_get_left(card)
  local refrigerators = {}

  if not G or not G.jokers or not G.jokers.cards then
    return refrigerators
  end

  for k, v in ipairs(G.jokers.cards) do
    if v == card then
      return refrigerators
    end

    if v.config and v.config.center and v.config.center.key == 'j_Sculio_refrigerator' then
      table.insert(refrigerators, v)
    end
  end

  return {}
end

local function Sculio_refrigerator_restore_ability(card, ability)
  for k, v in pairs(card.ability) do
    card.ability[k] = nil
  end

  for k, v in pairs(ability) do
    card.ability[k] = v
  end
end

local function Sculio_refrigerator_lost_value(before, after)
  for k, v in pairs(before) do
    if type(v) == 'number' and type(after[k]) == 'number' and after[k] < v then
      return true
    end

    if type(v) == 'table' and type(after[k]) == 'table' and Sculio_refrigerator_lost_value(v, after[k]) then
      return true
    end
  end

  return false
end

local function Sculio_refrigerator_juice(refrigerators, food)
  G.E_MANAGER:add_event(Event({
    func = function()
      for k, v in ipairs(refrigerators) do
        v:juice_up(0.5, 0.5)
      end

      food:juice_up(0.5, 0.5)
      return true
    end
  }))
end

-- Prevent probabilistic destruction (e.g., Gros Michel explosion)
if not Sculio_refrigerator_dissolve_ref then
  Sculio_refrigerator_dissolve_ref = Card.start_dissolve

  Card.start_dissolve = function(self, dissolve_colours, silent, dissolve_time_fac, no_juice)
    -- Only intercept food jokers being destroyed (not sold)
    if self.ability.set == 'Joker' and Sculio_refrigerator_is_food(self) then
      local refrigerators = Sculio_refrigerator_get_left(self)
      if next(refrigerators) then
        Sculio_refrigerator_juice(refrigerators, self)
        return self  -- Cancel dissolve
      end
    end
    return Sculio_refrigerator_dissolve_ref(self, dissolve_colours, silent, dissolve_time_fac, no_juice)
  end
end

if not Sculio_refrigerator_calculate_joker_ref then
  Sculio_refrigerator_calculate_joker_ref = Card.calculate_joker

  Card.calculate_joker = function(self, context)
    local refrigerators = Sculio_refrigerator_is_food(self) and Sculio_refrigerator_get_left(self) or {}
    local preserve = next(refrigerators) ~= nil and not context.selling_self
    local ability = preserve and copy_table(self.ability) or nil
    local h_size = preserve and ability and ability.extra and ability.extra.h_size or nil
    local ret = Sculio_refrigerator_calculate_joker_ref(self, context)

    if preserve and ability then
      local removed = ret and ret.remove and not context.selling_self
      local lost_value = Sculio_refrigerator_lost_value(ability, self.ability)
      local perished = self.debuff and self.ability and self.ability.perishable

      if h_size and self.ability and self.ability.extra and self.ability.extra.h_size and self.ability.extra.h_size < h_size and G.hand then
        G.hand:change_size(h_size - self.ability.extra.h_size)
      end

      if removed then
        ret.remove = nil
      end

      if removed or lost_value or perished then
        Sculio_refrigerator_restore_ability(self, ability)
        self:set_debuff(false)
        Sculio_refrigerator_juice(refrigerators, self)
      end
    end

    return ret
  end
end

SMODS.Joker {
  key = 'refrigerator',

  unlocked = true,
  discovered = false,
  rarity = 1, -- Common
  atlas = 'Sculio',
  pos = { x = 9, y = 2 },
  cost = 6,
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = { key = 'Sculio_refrigerable_jokers', set = 'Other' }
  end
}
