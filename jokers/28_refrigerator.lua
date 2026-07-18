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
  -- Bunco
  j_bunc_starfruit = true,
  -- Handsome Devils
  j_hnds_coffee_break = true,
  -- Prism
  j_prism_pizza_cap = true,
  j_prism_pizza_mar = true,
  j_prism_pizza_for = true,
  j_prism_pizza_ruc = true,
  j_prism_pizza_haw = true,
  j_prism_pizza_det = true,
  j_prism_pizza_con = true,
  -- Artbox
  j_artb_energy_drink = true,
  -- KC Vanilla
  j_kcvanilla_fortunecookie = true,
  -- Ortalab
  j_ortalab_taliaferro = true,
  j_ortalab_hot_chocolate = true,
  j_ortalab_royal_gala = true,
  j_ortalab_popcorn_bag = true,
  j_ortalab_salad = true,
  -- Paperback
  j_paperback_ice_cube = true,
  j_paperback_complete_breakfast = true,
  j_paperback_apple = true,
  j_paperback_double_dutchman = true,
  j_paperback_nachos = true,
  j_paperback_crispy_taco = true,
  j_paperback_soft_taco = true,
  j_paperback_watermelon = true,
  j_paperback_marble_soda = true,
  j_paperback_black_forest_cake = true,
  j_paperback_cream_liqueur = true,
  j_paperback_deviled_egg = true,
  j_paperback_chocolate_coins = true,
  j_paperback_golden_apple = true,
  j_paperback_champagne = true,
  j_paperback_coffee = true,
  j_paperback_matcha = true,
  j_paperback_pinot_noir = true,
  j_paperback_milk_tea = true,
  j_paperback_epic_sauce = true,
  j_paperback_aperol = true,
  j_paperback_grenadine = true,
  j_paperback_blue_curacao = true,
  j_paperback_stout = true,
  j_paperback_pear = true,
  j_paperback_nigori = true,
  j_paperback_lager = true,
  j_paperback_shabu_shabu = true,
  j_paperback_b_soda = true,
  j_paperback_jjs = true,
  -- Plantain
  j_pl_plantain = true,
  j_pl_apple_pie = true,
  j_pl_croissant = true,
  j_pl_lasagna = true,
  -- Lucky Rabbit
  j_fmod_pub_burger = true,
  j_fmod_edibles = true,
  -- Extra Credit
  j_ExtraCredit_starfruit = true,
  j_ExtraCredit_candynecklace = true,
  j_ExtraCredit_espresso = true,
  j_ExtraCredit_ambrosia = true,
  -- All in Jest
  j_aij_silly_sausage = true,
  j_aij_totally_nuts = true,
  j_aij_banana_man = true,
  j_aij_fortune_cookie = true,
  j_aij_chips_n_dip = true,
  j_aij_fish_fingers = true,
  j_aij_candy_floss = true,
  j_aij_stargazy_pie = true,
  j_aij_cheese_squigglies = true,
  j_aij_corndog = true,
  j_aij_triple_sundae = true,
  -- Monarchy
  j_monarchy_sushi_rolls = true,
  -- Bundles of Fun
  j_bof_dragonfruit = true,
  j_bof_blueberry = true,
  j_bof_grapes = true,
  j_bof_leek = true,
  j_bof_durian = true,
  j_bof_wonderous_bread = true,
  j_bof_jelly_beans = true,
  j_bof_apple = true,
  j_bof_apple_core = true,
  j_bof_tomato = true,
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
if not Sculio.refrigerator_dissolve_ref then
  Sculio.refrigerator_dissolve_ref = Card.start_dissolve

  Card.start_dissolve = function(self, dissolve_colours, silent, dissolve_time_fac, no_juice)
    -- Block food destroy only; sell sets G.CONTROLLER.locks.selling_card
    local selling = G.CONTROLLER and G.CONTROLLER.locks and G.CONTROLLER.locks.selling_card
    if not selling and self.ability.set == 'Joker' and Sculio_refrigerator_is_food(self) and self.config.center.key ~= 'j_diet_cola' then
      local refrigerators = Sculio_refrigerator_get_left(self)
      if next(refrigerators) then
        Sculio_refrigerator_juice(refrigerators, self)
        return self  -- Cancel dissolve
      end
    end
    return Sculio.refrigerator_dissolve_ref(self, dissolve_colours, silent, dissolve_time_fac, no_juice)
  end
end

if not Sculio.refrigerator_calculate_joker_ref then
  Sculio.refrigerator_calculate_joker_ref = Card.calculate_joker

  Card.calculate_joker = function(self, context)
    local refrigerators = Sculio_refrigerator_is_food(self) and Sculio_refrigerator_get_left(self) or {}
    local preserve = next(refrigerators) ~= nil and not context.selling_self

    -- Bypass destruction logic for Epic Sauce and Banana Man when refrigerated during context.after
    if preserve and context.after then
      if self.config.center.key == 'j_paperback_epic_sauce' or self.config.center.key == 'j_aij_banana_man' then
        Sculio_refrigerator_juice(refrigerators, self)
        return nil
      end
    end

    local ability = preserve and copy_table(self.ability) or nil
    local h_size = preserve and ability and type(ability.extra) == 'table' and ability.extra.h_size or nil
    local ret = Sculio.refrigerator_calculate_joker_ref(self, context)

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
  attributes = { 'food', "passive" },
  eternal_compat = true,
  blueprint_compat = false,
  perishable_compat = true,
  rental_compat = true,
  unlocked = true,
  discovered = false,
  rarity = 1, -- Common
  atlas = 'Sculio',
  pos = { x = 9, y = 2 },
  cost = 6,
  in_pool = function(self)
    if G.jokers then
      for _, j in ipairs(G.jokers.cards) do
        if Sculio_refrigerator_is_food(j) then
          return true
        end
      end
    end
    return false
  end,
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = { key = 'Sculio_refrigerable_jokers', set = 'Other' }
  end
}
