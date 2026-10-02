local function wild_cards()
  local wilds = {}
  for _, c in ipairs(G.playing_cards or {}) do
    if SMODS.has_enhancement(c, 'm_wild') then wilds[#wilds + 1] = c end
  end
  return wilds
end

local function enhancement_pool()
  local options = {}
  for _, center in pairs(G.P_CENTERS) do
    if center.set == 'Enhanced' and not center.no_rank and center.key ~= 'm_wild'
        and Sculio.in_pool(center) then
      options[#options + 1] = center.key
    end
  end
  return options
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
    return { vars = { Sculio.count_enhanced('m_wild') } }
  end,
  calculate = function(self, card, context)
    if context.blueprint then return end

    if context.setting_blind then
      local wilds = wild_cards()
      local options = enhancement_pool()
      if #wilds == 0 or #options == 0 then return end

      local salt = 'sculio_mouse_art_' .. tostring(G.GAME.round or 0)
      local target = wilds[math.floor(pseudohash(salt .. '_pick') * #wilds) + 1]
      local enh_key = SMODS.poll_enhancement({ key = salt .. '_enh', guaranteed = true, options = options })
      if not target or not enh_key or not G.P_CENTERS[enh_key] then return end

      target:set_ability(G.P_CENTERS[enh_key], false)
      target:juice_up(0.3, 0.5)
      play_sound('card1', 1, 0.6)
      G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
          card_eval_status_text(card, 'extra', nil, nil, nil, {
            message = localize { type = 'name_text', key = enh_key, set = 'Enhanced' },
            colour = G.C.SECONDARY_SET.Enhanced,
          })
          return true
        end
      }))
    end
  end,
  in_pool = function(self)
    return Sculio.count_enhanced('m_wild') > 0
  end,
}