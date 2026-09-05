local TRIGGERS = { 'played', 'scored', 'discarded', 'held', 'destroyed' }

-- Tier 1 = common (blue), Tier 2 = rare (purple), Tier 3 = strongest combos (gold)
local TIER_POOLS = {
  {
    { id = 'trap_chips75', weight = 4 },
    { id = 'trap_mult20', weight = 4 },
    { id = 'trap_dollars5', weight = 3 },
    { id = 'trap_draw2', weight = 3 },
  },
  {
    { id = 'trap_xmult175', weight = 3 },
    { id = 'trap_xchips15', weight = 3 },
    { id = 'trap_create_tarot', weight = 2 },
    { id = 'trap_create_planet', weight = 2 },
    { id = 'trap_enhance', weight = 2 },
    { id = 'trap_seal', weight = 2 },
    { id = 'trap_buff_others', weight = 2 },
  },
  {
    { id = 'trap_reduce_blind', weight = 3 },
    { id = 'trap_spectral_draw', weight = 2 },
    { id = 'trap_protect_xmult', weight = 2 },
    { id = 'trap_seal_buff', weight = 2 },
  },
}

-- Combos may chain several primitive effects
local COMBOS = {
  trap_chips75        = { 'chips75' },
  trap_mult20         = { 'mult20' },
  trap_dollars5       = { 'dollars5' },
  trap_draw2          = { 'draw2' },
  trap_xmult175       = { 'xmult175' },
  trap_xchips15       = { 'xchips15' },
  trap_create_tarot   = { 'create_tarot' },
  trap_create_planet  = { 'create_planet' },
  trap_enhance        = { 'enhance' },
  trap_seal           = { 'seal' },
  trap_buff_others    = { 'buff_others' },
  trap_reduce_blind   = { 'reduce_blind' },
  trap_spectral_draw  = { 'create_spectral', 'draw2' },
  trap_protect_xmult  = { 'protect', 'xmult175' },
  trap_seal_buff      = { 'seal', 'buff_others' },
}

local function weighted_pick(pool, seed)
  local total = 0
  for _, e in ipairs(pool) do total = total + e.weight end
  local roll = pseudorandom(seed) * total
  for _, e in ipairs(pool) do
    roll = roll - e.weight
    if roll <= 0 then return e end
  end
  return pool[#pool]
end

local function create_random(set_name, seed)
  if #G.consumeables.cards >= G.consumeables.config.card_limit then return end
  G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.3, func = function()
    if G.consumeables.config.card_limit > #G.consumeables.cards then
      play_sound('timpani')
      local new_card = create_card(set_name, G.consumeables, nil, nil, nil, nil, nil, seed)
      new_card:add_to_deck()
      G.consumeables:emplace(new_card)
    end
    return true
  end }))
end

local function random_target(exclude)
  local pool = {}
  for _, c in ipairs(G.hand.cards) do
    if c ~= exclude then pool[#pool + 1] = c end
  end
  for _, c in ipairs(G.deck.cards) do
    pool[#pool + 1] = c
  end
  if #pool == 0 then return nil end
  return pseudorandom_element(pool, pseudoseed('sculio_trap_target'))
end

-- Execute the rolled combo. Returns the part that integrates with scoring (may be empty).
function Sculio.fire_trap(card)
  local combo = COMBOS[card.ability.extra.combo] or {}
  local scoring_ret = {}
  for _, eff in ipairs(combo) do
    if eff == 'chips75' then
      scoring_ret.chips = 75
    elseif eff == 'mult20' then
      scoring_ret.mult = 20
    elseif eff == 'xmult175' then
      scoring_ret.x_mult = 1.75
    elseif eff == 'xchips15' then
      scoring_ret.x_chips = 1.5
    elseif eff == 'dollars5' then
      ease_dollars(5)
      scoring_ret.dollars = 5
    elseif eff == 'draw2' then
      G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.2, func = function()
        for _ = 1, 2 do
          if #G.deck.cards > 0 and #G.hand.cards < G.hand.config.card_limit then
            draw_card(G.deck, G.hand, 100, 'up', true, nil, 0.15)
          end
        end
        return true
      end }))
    elseif eff == 'create_tarot' then
      create_random('Tarot', 'sculio_trap_ct')
    elseif eff == 'create_planet' then
      create_random('Planet', 'sculio_trap_cp')
    elseif eff == 'create_spectral' then
      create_random('Spectral', 'sculio_trap_cs')
    elseif eff == 'enhance' then
      local t = random_target(card)
      if t then
        local enh_key = SMODS.poll_enhancement({ key = 'sculio_trap_eh', guaranteed = true })
        if enh_key then
          G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.2, func = function()
            t:set_ability(G.P_CENTERS[enh_key], false)
            t:juice_up(0.3, 0.5)
            return true
          end }))
        end
      end
    elseif eff == 'seal' then
      local t = random_target(card)
      if t then
        G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.2, func = function()
          local seal = SMODS.poll_seal({ key = 'sculio_trap_sl', guaranteed = true })
          if seal then t:set_seal(seal, true) end
          return true
        end }))
      end
    elseif eff == 'buff_others' then
      local others = {}
      for _, c in ipairs(G.hand.cards) do
        if c ~= card then others[#others + 1] = c end
      end
      pseudoshuffle(others, pseudoseed('sculio_trap_bo'))
      for i = 1, math.min(2, #others) do
        others[i].ability.perma_mult = (others[i].ability.perma_mult or 0) + 4
      end
    elseif eff == 'protect' then
      local idx = 1
      for i, c in ipairs(G.hand.cards) do
        if c == card then idx = i break end
      end
      for _, j in ipairs({ idx - 1, idx + 1 }) do
        local neighbor = G.hand.cards[j]
        if neighbor then neighbor.ability.Sculio_debuff_immune = true end
      end
    elseif eff == 'reduce_blind' then
      if G.GAME.blind and G.GAME.blind.chips and G.GAME.blind.chips > 0 then
        G.GAME.blind.chips = math.max(0, math.floor(G.GAME.blind.chips * 0.95))
        scoring_ret.message = '-5%'
        scoring_ret.colour = G.C.FILTER
      end
    end
  end
  return next(scoring_ret) and scoring_ret or nil
end

SMODS.Enhancement {
  key = 'trap',
  atlas = 'centers',
  pos = { x = 4, y = 1 },
  prefix_config = { atlas = false },

  config = { extra = {} },
  loc_vars = function(self, info_queue, card)
    local extra = card and card.ability and card.ability.extra or {}
    if not extra.rolled then
      return {
        vars = {
          localize('Sculio_trap_unknown_trigger', 'dictionary'),
          localize('Sculio_trap_unknown_effect', 'dictionary'),
        },
      }
    end
    return {
      vars = {
        localize('Sculio_trap_' .. extra.trigger, 'dictionary'),
        localize('Sculio_' .. extra.combo, 'dictionary'),
      },
    }
  end,
  set_ability = function(self, card, initial)
    if card.ability.extra and card.ability.extra.rolled then return end
    local tier_roll = pseudorandom('sculio_trap_tier')
    local tier = tier_roll < 5 / 9 and 1 or (tier_roll < 8 / 9 and 2 or 3)
    local entry = weighted_pick(TIER_POOLS[tier], 'sculio_trap_combo')
    card.ability.extra = {
      rolled = true,
      tier = tier,
      trigger = TRIGGERS[math.floor(pseudorandom('sculio_trap_trig') * #TRIGGERS) + 1],
      combo = entry.id,
    }
  end,
  calculate = function(self, card, context)
    local extra = card.ability.extra
    if not extra.rolled then return end
    if context.before and (context.cardarea == G.play or context.cardarea == 'unscored')
        and extra.trigger == 'played' then
      return Sculio.fire_trap(card)
    end
    if context.main_scoring and context.cardarea == G.play and extra.trigger == 'scored' then
      return Sculio.fire_trap(card)
    end
    if context.main_scoring and context.cardarea == G.hand and extra.trigger == 'held' then
      return Sculio.fire_trap(card)
    end
    if context.discard and context.other_card == card and extra.trigger == 'discarded' then
      return Sculio.fire_trap(card)
    end
  end,
}

-- Destroyed trigger: dissolving or shattering the Trap fires it
local function trap_check_destroyed(self_ref, ...)
  if self_ref.config.center_key == 'm_Sculio_trap'
      and self_ref.ability.extra and self_ref.ability.extra.rolled
      and self_ref.ability.extra.trigger == 'destroyed'
      and not self_ref.Sculio_destroyed_fired then
    self_ref.Sculio_destroyed_fired = true
    Sculio.fire_trap(self_ref)
  end
end

local start_dissolve_ref = Card.start_dissolve
function Card:start_dissolve(dissolve_colours, silent, dissolve_time_fac, no_juice)
  trap_check_destroyed(self)
  return start_dissolve_ref(self, dissolve_colours, silent, dissolve_time_fac, no_juice)
end

local shatter_ref = Card.shatter
function Card:shatter(...)
  trap_check_destroyed(self)
  return shatter_ref(self, ...)
end
