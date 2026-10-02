local cached_pool, cached_pool_size

local function enhancement_pool()
  local n = 0
  for _ in pairs(G.P_CENTERS) do n = n + 1 end
  if cached_pool and cached_pool_size == n then return cached_pool end
  local options = {}
  for _, center in pairs(G.P_CENTERS) do
    if center.set == 'Enhanced' and not center.no_rank and center.key ~= 'm_wild'
        and Sculio.in_pool(center) then
      options[#options + 1] = center.key
    end
  end
  table.sort(options)
  cached_pool, cached_pool_size = options, n
  return options
end

local function count_wilds()
  local count = 0
  for _, c in ipairs(G.playing_cards or {}) do
    if c.config.center_key == 'm_wild' then count = count + 1 end
  end
  return count
end

-- One roll for the whole deck: every Wild Card copies the same Enhancement.
-- Keyed off the joker's own ability, not the deck, so all copies stay in sync
-- without any per-card state to rebuild.
local function mimic_key(card)
  local extra = card.ability.extra
  if not extra.mimic then
    local options = enhancement_pool()
    if #options == 0 then return nil end
    local salt = 'sculio_mouse_art_mimic_' .. tostring(G.GAME.round or 0)
    extra.mimic = options[math.floor(pseudohash(salt) * #options) + 1]
  end
  return extra.mimic
end

local function mimic_name(card)
  local key = card.ability.extra.mimic
  if not key then return '?' end
  return localize { type = 'name_text', key = key, set = 'Enhanced' }
end

SMODS.Joker {
  key = 'mouse_art',
  attributes = { 'enhancements', 'modify_card' },
  eternal_compat = true,
  blueprint_compat = false,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = {} },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 1, y = 9 },
  cost = 6,
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.m_wild
    return { vars = { mimic_name(card) } }
  end,
  calculate = function(self, card, context)
    if context.blueprint then return end
    if context.setting_blind then
      card.ability.extra.mimic = nil
    elseif context.check_enhancement and context.other_card
        and context.other_card.config.center_key == 'm_wild' then
      local mimic = mimic_key(card)
      if mimic then return { [mimic] = true } end
    end
  end,
  in_pool = function(self)
    return count_wilds() > 0
  end,
}