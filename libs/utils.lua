Sculio = Sculio or {}

-- Destroy a joker card with standard animation and sound (based off Ice Cream)
-- used by 2_impossible_stairs, 9_gumball and 15_crooked
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

function Sculio:calculate(context)
  Sculio.maybe_apply_xchips_texts()

  -- Droste Effect: keep Inverted Arcana pack size/choices in sync (survives reloads)
  -- Orange Seal: one free reroll per seal in the deck, topped up when the shop opens
  if context.starting_shop then
    Sculio.apply_droste_bonus()
    Sculio.grant_orange_rerolls()
  end

  -- The Sane: remember the last Inverted Tarot used
  if context.using_consumeable and context.consumeable and context.consumeable.ability
      and context.consumeable.ability.set == 'Inverted' then
    G.GAME.Sculio_last_inverted = context.consumeable.config.center_key
    if sendDebugMessage then sendDebugMessage('Sculio: recorded last inverted = ' .. tostring(context.consumeable.config.center_key), 'SCULIO') end
  end

  if context.press_play and G.play and G.play.cards then
    local smeared = 0
    for _, c in ipairs(G.play.cards) do
      if SMODS.has_enhancement(c, 'm_Sculio_smeared') then smeared = smeared + 1 end
    end
    if smeared >= 2 then
      play_sound('tarot1')
      for _, c in ipairs(G.play.cards) do
        if SMODS.has_enhancement(c, 'm_Sculio_smeared') then
          c:set_debuff(true)
          if c.debuff then c.ability.Sculio_smeared_doom = true end
        end
      end
    end
  end

  if context.destroy_card and context.destroy_card.ability
      and context.destroy_card.ability.Sculio_smeared_doom then
    context.destroy_card.ability.Sculio_smeared_doom = nil
    return { remove = true }
  end

  -- The Atoned / Reborn: remember modifiers of the last destroyed card
  if context.remove_playing_cards and context.removed then
    for _, c in ipairs(context.removed) do
      if type(c) == 'table' and c.base then
        G.GAME.Sculio_last_destroyed = {
          enhancement = (c.config.center_key ~= 'c_base') and c.config.center_key or nil,
          seal = c.seal,
          edition = c.edition and copy_table(c.edition) or nil,
        }
      end
    end
  end

  -- Handheld: remember the last enhancement obtained by a deck card
  if context.setting_ability and context.other_card and context.new ~= context.old then
    local center = G.P_CENTERS[context.new]
    if center and center.set == 'Enhanced' then
      G.GAME.Sculio_last_enhancement = context.new
    end
  end
  if context.playing_card_added and context.cards then
    for _, c in ipairs(context.cards) do
      if type(c) == 'table' and c.ability and c.ability.set == 'Enhanced' and c.config and c.config.center then
        G.GAME.Sculio_last_enhancement = c.config.center.key
      end
    end
  end

  -- Mercy: remember the last Joker sold
  if context.selling_card and context.card and context.card.ability.set == 'Joker' then
    G.GAME.Sculio_last_joker_sold = context.card.config.center_key
  end

  -- Sheriff: count every boss blind defeated this run, even before owning it
  if context.end_of_round and context.main_eval and not context.game_over and context.beat_boss then
    G.GAME.Sculio_bosses_beaten = (G.GAME.Sculio_bosses_beaten or 0) + 1
  end

  -- The Mundane: track all money spent during the current Ante
  if context.ante_change and context.ante_change ~= 0 then
    G.GAME.Sculio_ante_spend = 0
  elseif context.money_altered and context.amount and context.amount < 0 then
    G.GAME.Sculio_ante_spend = (G.GAME.Sculio_ante_spend or 0) - context.amount
  end

  -- Trap Cards can protect adjacent cards from debuffs
  if context.debuff_card and context.other_card and context.other_card.ability
      and context.other_card.ability.Sculio_debuff_immune then
    return { prevent_debuff = true }
  end
  if context.end_of_round and context.main_eval and G.playing_cards then
    for _, c in ipairs(G.playing_cards) do
      c.ability.Sculio_debuff_immune = nil
    end
  end
end

function Sculio.is_debuff_immune(target)
  if not target then return false end
  for _, mod in ipairs(SMODS.mod_list or {}) do
    if mod.set_debuff and type(mod.set_debuff) == 'function' then
      local ok, res = pcall(mod.set_debuff, target)
      if ok and res == 'prevent_debuff' then return true end
    end
  end
  if BUNCOMOD and BUNCOMOD.content and type(BUNCOMOD.content.set_debuff) == 'function' then
    local ok, res = pcall(BUNCOMOD.content.set_debuff, target)
    if ok and res == 'prevent_debuff' then return true end
  end
  for _, v in pairs(target.ability and target.ability.debuff_sources or {}) do
    if v == 'prevent_debuff' then return true end
  end
  return false
end

-- Check whether any registered Edition grants XChips before swapping the
-- Figurine and Puck descriptions on the first calculation after loading.
Sculio._xchips_edition_cache = nil
function Sculio.xchips_editions_exist()
  local n = 0
  for _ in pairs(G.P_CENTERS or {}) do n = n + 1 end
  local cache = Sculio._xchips_edition_cache
  if cache and cache.n == n then return cache.found end
  local found = false
  for _, center in pairs(G.P_CENTERS or {}) do
    if center.set == 'Edition' and center.config then
      local cfg = center.config
      if (cfg.x_chips and cfg.x_chips > 1) or (cfg.Xchips and cfg.Xchips > 1)
        or (cfg.h_x_chips and cfg.h_x_chips > 1) then
        found = true
        break
      end
    end
  end
  Sculio._xchips_edition_cache = { n = n, found = found }
  return found
end

Sculio._stat_text_init_done = Sculio._stat_text_init_done or {}
function Sculio.maybe_apply_xchips_texts()
  local lang = (G.SETTINGS and G.SETTINGS.language) or 'en-us'
  if Sculio._stat_text_init_done[lang] or not Sculio.xchips_editions_exist() then return end
  local desc = G.localization and G.localization.descriptions and G.localization.descriptions.Joker
  if not desc then return end
  local alts = {
    j_Sculio_figurine = 'j_Sculio_figurine_xchips',
    j_Sculio_puck = 'j_Sculio_puck_xchips',
  }
  local all_applied = true
  for key, alt_key in pairs(alts) do
    local alt = desc[alt_key]
    if desc[key] and alt and alt.text and alt.text_parsed then
      desc[key].text = copy_table(alt.text)
      desc[key].text_parsed = copy_table(alt.text_parsed)
    else
      all_applied = false
    end
  end
  if all_applied then Sculio._stat_text_init_done[lang] = true end
end

function Sculio.reset_game_globals(run_start)
  if run_start then
    -- The Sane starts with itself in its own pool, so the first copy works
    G.GAME.Sculio_last_inverted = 'c_Sculio_sane'
    G.GAME.Sculio_last_joker_sold = 'j_joker'
    G.GAME.Sculio_bosses_beaten = 0
    -- Antumbra's gate starts at level 1; Orange Seal's reroll ledger at 0
    G.GAME.Sculio_antumbra_uses = 0
    G.GAME.Sculio_orange_granted = 0
  end
  Sculio.apply_droste_bonus()
end

-- True if a center is allowed to spawn (respects in_pool), safe against errors
function Sculio.in_pool(center)
  if not center or type(center.in_pool) ~= 'function' then return true end
  local ok, res = pcall(center.in_pool, center, {})
  return ok and res ~= false
end

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

-- Immutable Wheel: one exceptions table. `false` = never invoke; otherwise the
Sculio.wheel_overrides = {
  ['c_Sculio_immutable_wheel'] = false,
  ['c_aij_osiris'] = false,
  ['c_aij_osiris_controller'] = false,
  c_fool = 'consumable', c_judgement = 'consumable',
  c_Sculio_sane = 'consumable', c_Sculio_regicide = 'consumable', c_Sculio_mercy = 'consumable',
  c_Sculio_eclipse = 'card', c_Sculio_cave = 'card',
  c_Sculio_twilight = 'card', c_Sculio_collapse = 'card',
}

-- Functional class of a Tarot, used to bias the Immutable Wheel by context.
-- Auto-derived from config; wheel_overrides wins for special cases.
function Sculio.wheel_class(center)
  local forced = Sculio.wheel_overrides[center.key]
  if forced then return forced end
  local cfg = center.config or {}
  if cfg.tarots or cfg.planets then return 'consumable' end
  if cfg.mod_conv or cfg.suit_conv or cfg.rank_conv or cfg.max_highlighted then return 'card' end
  return 'econ'
end

-- Context-biased candidate pool for the Immutable Wheel.
function Sculio.wheel_candidates(only_set)
  local base = {}
  for key, center in pairs(G.P_CENTERS) do
    if (center.set == 'Tarot' or center.set == 'Inverted')
        and (not only_set or center.set == only_set)
        and not center.hidden
        and Sculio.wheel_overrides[key] ~= false then
      base[#base + 1] = key
    end
  end
  table.sort(base)

  local ctx = 'blind'
  if G.STATE == G.STATES.SHOP then ctx = 'shop'
  elseif G.STATE == G.STATES.SMODS_BOOSTER_OPENED then ctx = 'booster' end
  local weights = {
    blind   = { card = 4, consumable = 2, econ = 1 },
    shop    = { card = 1, consumable = 3, econ = 3 },
    booster = { card = 2, consumable = 2, econ = 1 },
  }
  local ctx_w = weights[ctx]

  local pool = {}
  for _, key in ipairs(base) do
    local w = ctx_w[Sculio.wheel_class(G.P_CENTERS[key])] or 1
    for _ = 1, w do pool[#pool + 1] = key end
  end
  table.sort(pool)
  return pool
end

-- True if a center can actually be activated in the current context
function Sculio.tarot_usable(center, card)
  local ok, res = pcall(function() return card:can_use_consumeable(true, true) end)
  if not ok then return false end
  return res and true or false
end

-- Highlight `count` random cards from hand so targeting Tarots can activate
local function highlight_random_hand(count, seed)
  if not (G.hand and count and count > 0) then return end
  local targets = {}
  for _, c in ipairs(G.hand.cards) do targets[#targets + 1] = c end
  pseudoshuffle(targets, pseudoseed(seed))
  for i = 1, math.min(count, #targets) do
    G.hand:add_to_highlighted(targets[i], true)
  end
end

function Sculio.invoke_random_tarot(slot, only_set, x_off, on_done)
  local pool = Sculio.wheel_candidates(only_set)
  if #pool == 0 then return nil end
  if G.hand then G.hand:unhighlight_all() end
  for i = 1, 15 do
    local salt = 'sculio_immutable' .. tostring(slot or '') .. i .. tostring(G.GAME.round or 0)
    local key = pool[math.floor(pseudohash(salt) * #pool) + 1]
    local center = key and G.P_CENTERS[key]
    if center then
      local new_card = Card(
        G.play.T.x + G.play.T.w / 2 - G.CARD_W / 2 + (x_off or 0),
        G.play.T.y + G.play.T.h / 2 - G.CARD_H / 2,
        G.CARD_W, G.CARD_H, G.P_CARDS.empty, center,
        { bypass_discovery_center = true, bypass_discovery_ui = true }
      )
      new_card.cost = 0
      local cfg = new_card.ability.consumeable or {}
      -- vanilla can_use_consumeable reads mod_num (normally set by Card:update)
      if cfg.max_highlighted then cfg.mod_num = math.min(5, cfg.max_highlighted) end

      -- auto-select random cards for targeting Tarots (Death, Strength, enhancements...)
      local available = G.hand and #G.hand.cards or 0
      local min_needed = cfg.min_highlighted or 1
      local enough = (not cfg.max_highlighted) or available >= min_needed
      if enough and cfg.max_highlighted then
        local maxh = Sculio.max_highlighted(new_card)
        highlight_random_hand(math.min(maxh, available), 'sculio_wheel_hl' .. tostring(slot or '') .. i)
      end

      if enough and Sculio.tarot_usable(center, new_card) then
        local name = localize { type = 'name_text', key = center.key, set = center.set }
        card_eval_status_text(new_card, 'extra', nil, nil, nil,
          { message = name, colour = G.C.SET[center.set] or G.C.SECONDARY_SET[center.set] })
        G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.2, func = function()
          new_card:start_materialize()
          local ok, err = pcall(function() new_card:use_consumeable(G.consumeables) end)
          if not ok then
            if sendDebugMessage then sendDebugMessage('Sculio wheel: ' .. tostring(err), 'SCULIO') end
          end
          G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 1.8, func = function()
            if G.hand then G.hand:unhighlight_all() end
            new_card:start_dissolve()
            if on_done then on_done() end
            return true
          end }))
          return true
        end }))
        return new_card
      end

      if G.hand then G.hand:unhighlight_all() end
      new_card:remove()
    end
  end
  return nil
end

-- Pick one random usable Tarot/Inverted Tarot center, respecting targeting limits
function Sculio.pick_wheel_tarot(slot, only_set)
  local pool = Sculio.wheel_candidates(only_set)
  if #pool == 0 then return nil end
  if G.hand then G.hand:unhighlight_all() end
  for i = 1, 15 do
    local salt = 'sculio_immutable' .. tostring(slot or '') .. i .. tostring(G.GAME.round or 0)
    local key = pool[math.floor(pseudohash(salt) * #pool) + 1]
    local center = key and G.P_CENTERS[key]
    if center then
      -- Probe card only to validate that the Tarot can actually activate here
      local probe = Card(
        G.play.T.x + G.play.T.w / 2 - G.CARD_W / 2,
        G.play.T.y + G.play.T.h / 2 - G.CARD_H / 2,
        G.CARD_W, G.CARD_H, G.P_CARDS.empty, center,
        { bypass_discovery_center = true, bypass_discovery_ui = true }
      )
      probe.cost = 0
      local cfg = probe.ability.consumeable or {}
      -- vanilla can_use_consumeable reads mod_num (normally set by Card:update)
      if cfg.max_highlighted then cfg.mod_num = math.min(5, cfg.max_highlighted) end
      local available = G.hand and #G.hand.cards or 0
      local enough = (not cfg.max_highlighted) or available >= (cfg.min_highlighted or 1)
      -- Targeting Tarots need a temporary selection for their can_use check
      if enough and cfg.max_highlighted then
        highlight_random_hand(math.min(Sculio.max_highlighted(probe), available), 'sculio_wheel_pick' .. tostring(slot or '') .. i)
      end
      local usable = enough and Sculio.tarot_usable(center, probe)
      probe:remove()
      if G.hand then G.hand:unhighlight_all() end
      if usable then return center end
    end
  end
  return nil
end

function Sculio.morph_wheel_into_tarot(card, slot, only_set)
  local center = Sculio.pick_wheel_tarot(slot, only_set)
  if not center then return nil end

  card:flip()
  play_sound('card1')
  card:juice_up(0.3, 0.3)

  G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.3, func = function()
    if card.REMOVED then return true end
    card:set_ability(center, false)
    local cfg = card.ability.consumeable or {}
    if cfg.max_highlighted then cfg.mod_num = math.min(5, cfg.max_highlighted) end
    return true
  end }))

  local name = localize { type = 'name_text', key = center.key, set = center.set }
  local colour = G.C.SET[center.set] or G.C.SECONDARY_SET[center.set]
  G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.35, func = function()
    if card.REMOVED then return true end
    card:flip()
    play_sound('tarot2')
    card:juice_up(0.3, 0.3)
    card_eval_status_text(card, 'extra', nil, nil, nil, { message = name, colour = colour })
    return true
  end }))

  G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.35, func = function()
    if card.REMOVED then return true end
    if G.hand then
      G.hand:unhighlight_all()
      local cfg = card.ability.consumeable or {}
      if cfg.max_highlighted and #G.hand.cards >= (cfg.min_highlighted or 1) then
        highlight_random_hand(math.min(Sculio.max_highlighted(card), #G.hand.cards), 'sculio_wheel_hl' .. tostring(slot or ''))
      end
    end
    return true
  end }))

  local use_event = Event({ trigger = 'after', delay = 0.3, func = function()
    if card.REMOVED then return true end
    local queue = G.E_MANAGER.queues.base
    local queued_before = #queue
    local ok, err = pcall(function() card:use_consumeable(G.consumeables) end)
    if not ok and sendDebugMessage then sendDebugMessage('Sculio wheel: ' .. tostring(err), 'SCULIO') end

    if #queue > queued_before then
      local here
      for i = 1, #queue do
        if queue[i] == use_event then here = i break end
      end
      if here then
        local fresh = {}
        for i = #queue, queued_before + 1, -1 do fresh[#fresh + 1] = queue[i]; queue[i] = nil end
        for i = #fresh, 1, -1 do table.insert(queue, here, fresh[i]) end
      end
    end
    return true
  end })
  G.E_MANAGER:add_event(use_event)

  return center
end

function Sculio.create_center_card(center_key, area, n, seed, no_delay)
  n = n or 1
  seed = seed or 'sculio_create'
  local center = G.P_CENTERS[center_key]
  if not center then return end
  local set = center.set or 'Tarot'
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
  if not no_delay then delay(0.45 * n) end
end

function Sculio.hand_selection_state()
  return G.STATE == G.STATES.SELECTING_HAND
    or G.STATE == G.STATES.TAROT_PACK
    or G.STATE == G.STATES.SPECTRAL_PACK
    or G.STATE == G.STATES.PLANET_PACK
    or G.STATE == G.STATES.SMODS_BOOSTER_OPENED
end

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
    and #G.hand.highlighted <= (Sculio.max_highlighted(card) or 5)
end

Sculio.distorted_max = { c_Sculio_scholar = 3, c_Sculio_exiled = 3, c_Sculio_apostate = 3, c_Sculio_pikeman = 3, c_Sculio_weakness = 5, c_Sculio_atoned = 5, }

function Sculio.max_highlighted(card)
  local base = card.ability.consumeable.max_highlighted or 0
  local override = Sculio.distorted() and Sculio.distorted_max[card.config.center_key]
  if base > 0 and override then return override end
  return base
end

Sculio.inverted_counterparts = {
  c_Sculio_sane = 'c_fool', c_Sculio_scholar = 'c_magician',
  c_Sculio_secularist = 'c_high_priestess', c_Sculio_exiled = 'c_empress',
  c_Sculio_regicide = 'c_emperor',  c_Sculio_apostate = 'c_hierophant',
  c_Sculio_adversaries = 'c_lovers',  c_Sculio_pikeman = 'c_chariot',
  c_Sculio_arbitrariness = 'c_justice', c_Sculio_mundane = 'c_hermit',
  c_Sculio_immutable_wheel = 'c_wheel_of_fortune',  c_Sculio_weakness = 'c_strength',
  c_Sculio_atoned = 'c_hanged_man', c_Sculio_rebirth = 'c_death',
  c_Sculio_impatient = 'c_temperance',  c_Sculio_archangel = 'c_devil',
  c_Sculio_siege = 'c_tower', c_Sculio_collapse = 'c_star',
  c_Sculio_eclipse = 'c_moon',  c_Sculio_twilight = 'c_sun',
  c_Sculio_mercy = 'c_judgement', c_Sculio_cave = 'c_world',
}

function Sculio.counterpart(center_key)
  return Sculio.inverted_counterparts[center_key]
end

function Sculio.inverted_counterpart(vanilla_key)
  for inverted, vanilla in pairs(Sculio.inverted_counterparts) do
    if vanilla == vanilla_key then return inverted end
  end
end

function Sculio.distorted_key(self)
  return Sculio.distorted() and (self.key .. '_distorted_flow') or self.key
end

function Sculio.track_inverted_use(card)
  G.GAME.Sculio_last_inverted = card.config.center_key
end

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

local function edition_center_key(edition)
  if type(edition) ~= 'table' then return edition end
  local key = edition.type or edition.key
  if key then return key end
  for k, v in pairs(edition) do
    if v == true or (type(v) == 'number' and v > 0) then return 'e_' .. k end
  end
end

function Sculio.modifier_label(mods, kind)
  if not mods then return nil end
  if kind == 'enhancement' and mods.enhancement then
    return localize { type = 'name_text', key = mods.enhancement, set = 'Enhanced' }
  elseif kind == 'seal' and mods.seal then
    return localize { type = 'name_text', key = tostring(mods.seal):lower() .. '_seal', set = 'Other' }
  elseif kind == 'edition' and mods.edition then
    local key = edition_center_key(mods.edition)
    if key then
      if key:sub(1, 2) ~= 'e_' then key = 'e_' .. key end
      return localize { type = 'name_text', key = key, set = 'Edition' }
    end
  end
end

function Sculio.describe_modifiers(mods)
  local parts = {}
  for _, kind in ipairs({ 'enhancement', 'seal', 'edition' }) do
    local label = Sculio.modifier_label(mods, kind)
    if label then parts[#parts + 1] = label end
  end
  if #parts == 0 then return localize('k_none') end
  return table.concat(parts, ', ')
end

function Sculio.distorted()
  return (G.GAME and G.GAME.used_vouchers and G.GAME.used_vouchers['v_Sculio_distorted_flow']) and true or false
end

function Sculio.apply_droste_bonus()
  local wanted = (G.GAME and G.GAME.used_vouchers and G.GAME.used_vouchers['v_Sculio_droste_effect']) and 1 or 0
  for _, center in pairs(G.P_CENTERS or {}) do
    if center.Sculio_base_extra then
      center.config.extra = center.Sculio_base_extra + wanted
      center.config.choose = center.Sculio_base_choose + wanted
    end
  end
  for _, card in ipairs((G.shop_booster and G.shop_booster.cards) or {}) do
    local center = card.config and card.config.center
    if center and center.Sculio_base_extra and card.ability then
      card.ability.extra = center.Sculio_base_extra + wanted
      card.ability.choose = center.Sculio_base_choose + wanted
    end
  end
end

function Sculio.edition_in_hand()
  local targets = {}
  for _, c in ipairs(G.hand and G.hand.cards or {}) do
    if c.edition then targets[#targets + 1] = c end
  end
  return targets
end

function Sculio.blank_in_hand()
  local targets = {}
  for _, c in ipairs(G.hand and G.hand.cards or {}) do
    if not c.REMOVED and not c.edition then targets[#targets + 1] = c end
  end
  return targets
end

function Sculio.count_suit_deck(suit)
  local count = 0
  for _, c in ipairs(G.playing_cards or {}) do
    if c.base.suit == suit or SMODS.has_any_suit(c) then count = count + 1 end
  end
  return count
end

-- Count cards in the deck carrying the given seal key (the value stored in
-- card.seal, e.g. 'Sculio_orange'). Skips removed cards.
function Sculio.count_seal(seal_key)
  local count = 0
  for _, c in ipairs(G.playing_cards or {}) do
    if c.seal == seal_key and not c.REMOVED then count = count + 1 end
  end
  return count
end

-- Jokers that card effects may destroy: real Jokers, not Eternal ones
-- (vanilla Hex skips Eternals when slicing).
function Sculio.destroyable_jokers()
  local pool = {}
  if G.jokers then
    for _, c in ipairs(G.jokers.cards) do
      if c.ability and c.ability.set == 'Joker' and not c.REMOVED
          and not SMODS.is_eternal(c) then pool[#pool + 1] = c end
    end
  end
  return pool
end

-- Orange Seal: every seal in the deck is worth one free shop reroll. The grant
-- pays a delta over what was already given this run (G.GAME.Sculio_orange_granted),
-- so other mods' SMODS.change_free_rerolls grants survive and a shop that
-- reopens never double-pays. SMODS.change_free_rerolls moves both pools:
-- round_resets (the per-ante budget vanilla copies into current_round at round
-- start) and the current round on the spot.
function Sculio.grant_orange_rerolls()
  local count = Sculio.count_seal('Sculio_orange')
  local granted = G.GAME.Sculio_orange_granted or 0
  if count ~= granted then
    SMODS.change_free_rerolls(count - granted)
    G.GAME.Sculio_orange_granted = count
  end
end

-- Deck picker: pause + overlay showing the REAL cards of G.deck. Previews are
-- copy_card copies; the deck itself is untouched until a pick lands, and the
-- pick draws that exact card (draw_card with an explicit card skips the draw
-- order). Pattern ported from SMODS.card_collection_UIBox + All in Jest's
-- jest_create_select_card_ui, kept standalone on purpose: seals work without AIJ.
function Sculio.open_deck_picker()
  if not (G.deck and G.hand and #G.deck.cards > 0) then return end
  local pool = {}
  for _, c in ipairs(G.deck.cards) do pool[#pool + 1] = c end
  table.sort(pool, function(a, b) return a:get_nominal('suit') > b:get_nominal('suit') end)
  G.SETTINGS.paused = true
  G.FUNCS.overlay_menu {
    definition = Sculio.deck_picker_UIBox(pool),
  }
end

function Sculio.deck_picker_UIBox(pool)
  G.your_collection = {}
  local rows = { 5, 5, 5 }
  local deck_tables = {}
  local cards_per_page = 0
  local row_totals = {}
  for j = 1, #rows do
    row_totals[j] = cards_per_page
    cards_per_page = cards_per_page + rows[j]
    G.your_collection[j] = CardArea(
      G.ROOM.T.x + 0.2*G.ROOM.T.w/2, G.ROOM.T.h,
      (rows[j] + 0.25)*G.CARD_W, 1.05*G.CARD_H,
      {card_limit = rows[j], type = 'title', highlight_limit = 0, collection = true}
    )
    table.insert(deck_tables,
      {n = G.UIT.R, config = {align = 'cm', padding = 0.07, no_fill = true}, nodes = {
        {n = G.UIT.O, config = {object = G.your_collection[j]}}
      }})
  end

  local options = {}
  for i = 1, math.ceil(#pool/cards_per_page) do
    table.insert(options, localize('k_page')..' '..tostring(i)..'/'..tostring(math.ceil(#pool/cards_per_page)))
  end

  G.FUNCS.Sculio_deck_picker_page = function(e)
    if not e or not e.cycle_config then return end
    for j = 1, #G.your_collection do
      for i = #G.your_collection[j].cards, 1, -1 do
        local c = G.your_collection[j]:remove_card(G.your_collection[j].cards[i])
        c:remove()
        c = nil
      end
    end
    for j = 1, #rows do
      for i = 1, rows[j] do
        local real = pool[i + row_totals[j] + (cards_per_page*(e.cycle_config.current_option - 1))]
        if not real then break end
        local preview = copy_card(real)
        preview.children.Sculio_select = UIBox{
          definition = {
            n = G.UIT.ROOT,
            config = {
              ref_table = preview, minw = 0.6, maxw = 1, padding = 0.1, align = 'bm',
              colour = G.C.GREEN, shadow = true, r = 0.08, minh = 0.3, one_press = true,
              button = 'Sculio_deck_pick', data = { real }, hover = true,
            },
            nodes = {
              {n = G.UIT.T, config = { text = localize('k_Sculio_select'), colour = G.C.WHITE, scale = 0.45 }},
            },
          },
          config = { align = 'bm', offset = { x = 0, y = -0.15 }, major = preview, bond = 'Weak', parent = preview },
        }
        G.your_collection[j]:emplace(preview)
      end
    end
    INIT_COLLECTION_CARD_ALERTS()
  end

  G.FUNCS.Sculio_deck_picker_page{ cycle_config = { current_option = 1 } }

  return create_UIBox_generic_options({
    back_func = 'Sculio_deck_picker_back',
    contents = {
      {n = G.UIT.R, config = {align = 'cm', r = 0.1, colour = G.C.BLACK, emboss = 0.05}, nodes = deck_tables},
      (#pool > cards_per_page) and {n = G.UIT.R, config = {align = 'cm'}, nodes = {
        create_option_cycle({
          options = options, w = 4.5, cycle_shoulders = true,
          opt_callback = 'Sculio_deck_picker_page', current_option = 1,
          colour = G.C.RED, no_pips = true, focus_args = {snap_to = true, nav = 'wide'},
        })
      }} or nil,
    }
  })
end

-- Click on a preview's Select button: draw the REAL card it was copied from,
-- if it's still in the deck. The game is paused while the overlay is open, so
-- the discard moves are still queued; drawing here and unpausing lets them run
-- first and the emplace honors the hand limit.
G.FUNCS.Sculio_deck_pick = function(e)
  local real = e.config.data[1]
  if real and not real.REMOVED and real.area == G.deck then
    draw_card(G.deck, G.hand, nil, 'up', true, real, 0)
  end
  G.FUNCS.exit_overlay_menu()
end

-- Cancel the Seeking pick: the sealed card was still discarded, nothing drawn.
G.FUNCS.Sculio_deck_picker_back = function()
  G.FUNCS.exit_overlay_menu()
end
