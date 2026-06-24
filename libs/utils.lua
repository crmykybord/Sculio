Sculio = Sculio or {}

-- Destroy a joker card with standard animation and sound (based off Ice Cream)
function Sculio.destroy_joker(card)
  G.E_MANAGER:add_event(Event({
    func = function()
      play_sound('tarot1')
      card.T.r = -0.2
      card:juice_up(0.3, 0.4)
      card.states.drag.is = true
      card.children.center.pinch.x = true

      G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
        func = function()
          G.jokers:remove_card(card)
          card:remove()
          card = nil
          return true
        end
      }))

      return true
    end
  }))
end

-- Absorb edition bonuses from a sold card (used by Figurine and Puck)
-- Returns a message string if any bonus was applied, nil otherwise
function Sculio.absorb_edition(target_card, sold_card, bonus_mult)
  local ed = sold_card.edition
  if not ed then return nil end
  local ed_key = ed.type or ed.key
  local ed_center = G.P_CENTERS[ed_key] or G.P_CENTERS['e_' .. ed_key]
  if not ed_center then return nil end
  local cfg = ed_center.config
  local bonus = bonus_mult or 1
  if cfg.chips and cfg.chips > 0 then
    local gain = cfg.chips * bonus
    target_card.ability.extra.chips = target_card.ability.extra.chips + gain
    return localize({ type = 'variable', key = 'a_chips', vars = { gain } })
  elseif cfg.mult and cfg.mult > 0 then
    local gain = cfg.mult * bonus
    target_card.ability.extra.mult = target_card.ability.extra.mult + gain
    return localize({ type = 'variable', key = 'a_mult', vars = { gain } })
  elseif cfg.x_mult and cfg.x_mult > 1 then
    local gain = (cfg.x_mult - 1) * bonus
    target_card.ability.extra.x_mult = target_card.ability.extra.x_mult + gain
    return '+ ' .. localize({ type = 'variable', key = 'a_xmult', vars = { gain } })
  elseif (cfg.x_chips and cfg.x_chips > 1) or (cfg.Xchips and cfg.Xchips > 1) then
    local xchips_val = cfg.x_chips or cfg.Xchips
    local gain = (xchips_val - 1) * bonus
    target_card.ability.extra.x_chips = target_card.ability.extra.x_chips + gain
    return '+ ' .. localize({ type = 'variable', key = 'a_xchips', vars = { gain } })
  end
  return nil
end

-- Check if the given scoring_name is the most played visible hand
function Sculio.is_most_played(scoring_name)
  local most_played = true
  local most_played_count = (G.GAME.hands[scoring_name].played or 0)
  for k, v in pairs(G.GAME.hands) do
    if k ~= scoring_name and v.played >= most_played_count and v.visible then
      most_played = false
      break
    end
  end
  return most_played
end

-- Find the first card in scoring_hand with the given enhancement key
function Sculio.find_first_enhanced(scoring_hand, enh_key)
  for i = 1, #scoring_hand do
    if SMODS.has_enhancement(scoring_hand[i], enh_key) then
      return scoring_hand[i]
    end
  end
  return nil
end

-- Count cards in the deck with the given enhancement key
function Sculio.count_enhanced(enh_key)
  local count = 0
  if G.playing_cards then
    for _, c in ipairs(G.playing_cards) do
      if SMODS.has_enhancement(c, enh_key) then
        count = count + 1
      end
    end
  end
  return count
end

-- Undebuff all jokers in a list (safely checks for gone cards)
function Sculio.undebuff_list(list)
  if not list then return end
  for _, j in ipairs(list) do
    if j and not j.gone then
      j:set_debuff(false)
    end
  end
end
