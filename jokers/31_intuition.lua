-- Template: what one successful held card copies from a scored enhancement
local function enhancement_template(center)
  local cfg = center.config
  if center.key == 'm_lucky' then return { lucky = true } end
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

SMODS.Joker {
  key = 'intuition',
  attributes = { 'chance', 'enhancements' },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = { odds = 4 } },
  unlocked = true,
  discovered = false,
  rarity = 3,
  atlas = 'Sculio',
  pos = { x = 2, y = 3 },
  cost = 9,
  loc_vars = function(self, info_queue, card)
    local n, d = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'intuition')
    return { vars = { n, d } }
  end,
  calculate = function(self, card, context)
    -- Cache scored enhancement templates before scoring starts
    if context.before then
      card.intuition_templates = {}
      for _, scored in ipairs(context.scoring_hand or {}) do
        if not scored.debuff then
          local center = G.P_CENTERS[scored.config.center.key]
          if center and center.key ~= 'c_base' and center.config then
            local t = enhancement_template(center)
            if t then card.intuition_templates[#card.intuition_templates + 1] = t end
          end
        end
      end
      return nil
    end

    -- Each held card rolls once per scored enhancement; effect shows on the held card
    if context.end_of_round then return nil end
    if not (context.individual and context.cardarea == G.hand and context.other_card) then return nil end
    if context.other_card.debuff then return nil end
    local templates = card.intuition_templates
    if not templates or #templates == 0 then return nil end

    local effect
    for _, t in ipairs(templates) do
      if SMODS.pseudorandom_probability(card, 'intuition', 1, card.ability.extra.odds, 'intuition') then
        effect = effect or {}
        if t.lucky then
          if SMODS.pseudorandom_probability(card, 'intuition_lucky_mult', 1, 5, 'intuition') then
            effect.mult = (effect.mult or 0) + 20
          end
          if SMODS.pseudorandom_probability(card, 'intuition_lucky_money', 1, 15, 'intuition') then
            effect.dollars = (effect.dollars or 0) + 20
          end
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
