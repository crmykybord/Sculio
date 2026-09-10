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

-- Absorb edition bonuses from a sold joker or scored card (used by Figurine and Puck)
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

-- Mod-wide context router (trackers + shared round logic) lives in libs/trackers.lua

-- List of registered Inverted Tarot keys
function Sculio.inverted_pool()
  local pool = {}
  for key, center in pairs(G.P_CENTERS) do
    if center.set == 'Inverted' then
      pool[#pool + 1] = key
    end
  end
  return pool
end

-- Create up to n copies of a center inside an area
function Sculio.create_center_card(center_key, area, n, seed)
  n = n or 1
  seed = seed or 'sculio_create'
  local set = (G.P_CENTERS[center_key] and G.P_CENTERS[center_key].set) or 'Tarot'
  for i = 1, n do
    G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.4, func = function()
      if area.config.card_limit > #area.cards then
        play_sound('timpani')
        local new_card = create_card(set, area, nil, nil, nil, nil, center_key, seed .. i)
        new_card:add_to_deck()
        area:emplace(new_card)
      else
        if sendDebugMessage then sendDebugMessage('Sculio: create_center_card skipped, no space for ' .. tostring(center_key), 'SCULIO') end
      end
      return true
    end }))
  end
  delay(0.45 * n)
end

-- True in states where selecting hand cards is allowed (vanilla consumable states)
function Sculio.hand_selection_state()
  return G.STATE == G.STATES.SELECTING_HAND
    or G.STATE == G.STATES.TAROT_PACK
    or G.STATE == G.STATES.SPECTRAL_PACK
    or G.STATE == G.STATES.PLANET_PACK
end

-- Flip animation for consumable targets
function Sculio.flip_highlighted(card, cards, apply_fn)
  if card then
    G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.4, func = function()
      play_sound('tarot1')
      card:juice_up(0.3, 0.5)
      return true
    end }))
  end

  for i = 1, #cards do
    local c = cards[i]
    local percent = 1.15 - (i - 0.999) / (#cards - 0.998) * 0.3
    G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.15, func = function()
      c:flip()
      play_sound('card1', percent)
      c:juice_up(0.3, 0.3)
      return true
    end }))
  end

  delay(0.2)

  G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.1, func = function()
    if apply_fn then apply_fn() end
    return true
  end }))

  for i = 1, #cards do
    local c = cards[i]
    local percent = 0.85 + (i - 0.999) / (#cards - 0.998) * 0.3
    G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.15, func = function()
      c:flip()
      play_sound('tarot2', percent)
      c:juice_up(0.3, 0.3)
      return true
    end }))
  end

  G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.2, func = function()
    G.hand:unhighlight_all()
    return true
  end }))
end

-- Selection gate for consumables that target highlighted cards
function Sculio.can_select(card)
  return Sculio.hand_selection_state()
    and #G.hand.highlighted >= (card.ability.consumeable.min_highlighted or 1)
    and #G.hand.highlighted <= (card.ability.consumeable.max_highlighted or 5)
end

-- Record the last Inverted Tarot used (Ortalab track_usage pattern)
function Sculio.track_inverted_use(card)
  G.GAME.Sculio_last_inverted = card.config.center_key
end

-- Apply a function to up to n highlighted cards with the flip animation
function Sculio.apply_highlighted(apply_fn, n, card)
  local cards = {}
  for i = 1, math.min(#G.hand.highlighted, n or #G.hand.highlighted) do
    cards[#cards + 1] = G.hand.highlighted[i]
  end
  Sculio.flip_highlighted(card, cards, function()
    if apply_fn then apply_fn(cards) end
  end)
end

-- Enhance up to n highlighted cards
function Sculio.enhance_highlighted(enh_key, n, card)
  Sculio.apply_highlighted(function(cards)
    for _, c in ipairs(cards) do
      c:set_ability(G.P_CENTERS[enh_key], false)
    end
  end, n, card)
end

-- Weighted pick of one modifier kind available on a destroyed card
function Sculio.pick_modifier(mods, seed, enh_weight)
  local pool = {}
  local function add(kind, value, weight) pool[#pool + 1] = { kind = kind, value = value, weight = weight } end
  if mods.enhancement then add('enhancement', mods.enhancement, enh_weight or 65) end
  if mods.seal then add('seal', mods.seal, 17.5) end
  if mods.edition then add('edition', mods.edition, 17.5) end
  if not next(pool) then return nil end
  local total = 0
  for _, e in ipairs(pool) do total = total + e.weight end
  local roll = pseudorandom(seed) * total
  for _, e in ipairs(pool) do
    roll = roll - e.weight
    if roll <= 0 then return e end
  end
  return pool[#pool]
end

-- Apply a modifier picked by pick_modifier onto a card
function Sculio.apply_modifier(target, picked)
  if not picked then return false end
  if picked.kind == 'enhancement' and G.P_CENTERS[picked.value] then
    target:set_ability(G.P_CENTERS[picked.value], false)
  elseif picked.kind == 'seal' then
    target:set_seal(picked.value, true)
  elseif picked.kind == 'edition' then
    target:set_edition(copy_table(picked.value), true)
  else
    return false
  end
  target:juice_up(0.3, 0.5)
  return true
end

-- Count the cards in the full deck that match a suit
function Sculio.count_suit_deck(suit)
  local count = 0
  for _, c in ipairs(G.playing_cards or {}) do
    if c.base.suit == suit then count = count + 1 end
  end
  return count
end

-- Figurine/Puck XChips edition-text swap lives in libs/edition_texts.lua
