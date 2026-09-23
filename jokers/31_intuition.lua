-- Template: what one enhancement center grants when scored (shared with held-card caching)
local ODDS = 4

local function count_held(enh_key)
  local n = 0
  for _, c in ipairs(G.hand and G.hand.cards or {}) do
    if not c.debuff and SMODS.has_enhancement(c, enh_key) then n = n + 1 end
  end
  return n
end

-- Enhancements whose copied effect can't be read from center.config alone.
-- Mirrors each enhancement's on-scoring behaviour only: destruction flags,
-- held-only, discard and scaling effects are intentionally left out.
local SPECIAL_TEMPLATES = {
  m_Sculio_punched = function(center)
    return { x_mult = (center.config.extra or {}).x_mult or 1.5 }
  end,
  m_paperback_wrapped = function(center)
    return { dollars = (center.config.extra or {}).money or 2 }
  end,
  m_paperback_stained = function(center)
    return { mult = (center.config.extra or {}).mult_mod or 1 }
  end,
  m_paperback_ceramic = function(center)
    local e = center.config.extra or {}
    local inc = (G.GAME.paperback and G.GAME.paperback.ceramic_inc) or 0
    return { ceramic_low = (e.a_money_low or 1) + inc, ceramic_high = (e.a_money_high or 5) + inc }
  end,
  m_paperback_bandaged = function()
    return { repetitions = 1 }
  end,
  m_Sculio_phalanx = function()
    return { phalanx = Sculio.distorted() and 0.4 or 0.2 }
  end,
  m_aij_wood = function(center)
    local e = center.config.extra or {}
    local n = count_held('m_aij_wood')
    local chips = (e.base_h_chips or 20) + ((e.h_chips_mod or 5) * math.max(0, n - 1))
    return { chips = chips }
  end,
}

local function enhancement_template(center)
  local special = SPECIAL_TEMPLATES[center.key]
  if special then return special(center) end
  if center.key == 'm_lucky' then return { lucky = true } end
  local cfg = center.config
  local t = {}
  if cfg.bonus and cfg.bonus ~= 0 then t.chips = (t.chips or 0) + cfg.bonus end
  if cfg.h_chips and cfg.h_chips ~= 0 then t.chips = (t.chips or 0) + cfg.h_chips end
  if cfg.mult and cfg.mult ~= 0 then t.mult = (t.mult or 0) + cfg.mult end
  if cfg.h_mult and cfg.h_mult ~= 0 then t.mult = (t.mult or 0) + cfg.h_mult end
  if cfg.p_dollars and cfg.p_dollars ~= 0 then t.dollars = (t.dollars or 0) + cfg.p_dollars end
  if cfg.h_dollars and cfg.h_dollars ~= 0 then t.dollars = (t.dollars or 0) + cfg.h_dollars end
  local x_mult = (cfg.x_mult or cfg.Xmult or 1) * (cfg.h_x_mult or 1)
  local x_chips = (cfg.x_chips or cfg.Xchips or 1) * (cfg.h_x_chips or 1)
  if x_mult ~= 1 then t.x_mult = x_mult end
  if x_chips ~= 1 then t.x_chips = x_chips end
  if next(t) then return t end
end

local function held_templates(card)
  card.ability.extra = card.ability.extra or {}
  local templates = card.ability.extra.intuition_templates
  if not templates then
    templates = {}
    for _, held in ipairs(G.hand and G.hand.cards or {}) do
      if not held.debuff then
        local center = G.P_CENTERS[held.config.center.key]
        if center and center.key ~= 'c_base' and center.config then
          local t = enhancement_template(center)
          if t then templates[#templates + 1] = t end
        end
      end
    end
    card.ability.extra.intuition_templates = templates
  end
  return templates
end

SMODS.Joker {
  key = 'intuition',
  attributes = { 'chance', 'enhancements' },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  config = {},
  unlocked = true,
  discovered = false,
  rarity = 3,
  atlas = 'Sculio',
  pos = { x = 2, y = 3 },
  cost = 8,
  loc_vars = function(self, info_queue, card)
    local n, d = SMODS.get_probability_vars(card, 1, ODDS, 'intuition')
    return { vars = { n, d } }
  end,
  calculate = function(self, card, context)
    if context.before then
      if card.ability.extra then card.ability.extra.intuition_templates = nil end
      G.GAME.Sculio_intuition_phalanx = nil
      held_templates(card)
      return nil
    end

    -- Bandaged: copy only the retrigger, never the self-destruction
    if context.repetition and context.cardarea == G.play then
      local reps = 0
      for _, t in ipairs(held_templates(card)) do
        if t.repetitions and SMODS.pseudorandom_probability(card, 'intuition', 1, ODDS, 'intuition') then
          reps = reps + t.repetitions
        end
      end
      if reps > 0 then return { repetitions = reps } end
      return nil
    end

    -- Phalanx: each successful copy feeds its own end-of-hand multiplier
    if context.joker_main and (G.GAME.Sculio_intuition_phalanx or 0) > 0 then
      local x_mult = 1 + G.GAME.Sculio_intuition_phalanx
      G.GAME.Sculio_intuition_phalanx = nil
      return { x_mult = x_mult }
    end

    if context.end_of_round then return nil end
    if not (context.individual and context.cardarea == G.play and context.other_card) then return nil end
    if context.other_card.debuff then return nil end
    local templates = held_templates(card)
    if #templates == 0 then return nil end

    local effect
    for _, t in ipairs(templates) do
      if SMODS.pseudorandom_probability(card, 'intuition', 1, ODDS, 'intuition') then
        effect = effect or {}
        if t.lucky then
          if SMODS.pseudorandom_probability(card, 'intuition_lucky_mult', 1, 5, 'intuition') then
            effect.mult = (effect.mult or 0) + 20
          end
          if SMODS.pseudorandom_probability(card, 'intuition_lucky_money', 1, 15, 'intuition') then
            effect.dollars = (effect.dollars or 0) + 20
          end
        elseif t.ceramic_low then
          effect.dollars = (effect.dollars or 0) + pseudorandom('sculio_intuition_ceramic', t.ceramic_low, math.max(t.ceramic_low, t.ceramic_high))
        elseif t.phalanx then
          G.GAME.Sculio_intuition_phalanx = (G.GAME.Sculio_intuition_phalanx or 0) + t.phalanx
        elseif t.repetitions then
          -- handled in the repetition context
        else
          if t.chips then effect.chips = (effect.chips or 0) + t.chips end
          if t.mult then effect.mult = (effect.mult or 0) + t.mult end
          if t.dollars then effect.dollars = (effect.dollars or 0) + t.dollars end
          if t.x_mult then effect.x_mult = (effect.x_mult or 1) * t.x_mult end
          if t.x_chips then effect.x_chips = (effect.x_chips or 1) * t.x_chips end
        end
      end
    end
    if effect and next(effect) then return effect end
  end
}
