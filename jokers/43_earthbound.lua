-- Trigger force-pick whenever cards are drawn to hand (blind start + re-draws)
local sculio_eb_drawn_ref = Blind.drawn_to_hand
function Blind:drawn_to_hand()
  local ret = sculio_eb_drawn_ref(self)
  if G.jokers and not G.GAME.sculio_autobattle_multicopy_safeguard then
    G.GAME.sculio_autobattle_multicopy_safeguard = true
    for _, j in ipairs(G.jokers.cards) do
      if j.config.center.key == 'j_Sculio_earthbound' and not j.debuff then
        j.config.center:_select_and_force(j)
        break
      end
    end
  end
  return ret
end

-- Preserve force picks after playing (vanilla clears forced_selection during play)
local sculio_eb_play_ref = G.FUNCS.play_cards_from_highlighted
G.FUNCS.play_cards_from_highlighted = function(e)
  local forced = {}
  if G.playing_cards then
    for _, v in ipairs(G.playing_cards) do
      if v.ability.earthbound_forced then table.insert(forced, v) end
    end
  end
  local ret = sculio_eb_play_ref(e)
  for _, v in ipairs(forced) do v.ability.forced_selection = true end
  G.GAME.sculio_autobattle_multicopy_safeguard = false
  return ret
end

-- Preserve force picks after discarding
local sculio_eb_discard_ref = G.FUNCS.discard_cards_from_highlighted
G.FUNCS.discard_cards_from_highlighted = function(e, hook)
  local forced = {}
  if G.playing_cards then
    for _, v in ipairs(G.playing_cards) do
      if v.ability.earthbound_forced then table.insert(forced, v) end
    end
  end
  local ret = sculio_eb_discard_ref(e, hook)
  for _, v in ipairs(forced) do v.ability.forced_selection = true end
  G.GAME.sculio_autobattle_multicopy_safeguard = false
  return ret
end

SMODS.Joker {
  key = 'earthbound',
  attributes = { 'xmult', 'hand_type' },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  config = { extra = { x_mult = 3 } },
  unlocked = true,
  discovered = false,
  rarity = 2,
  atlas = 'Sculio',
  pos = { x = 4, y = 4 },
  cost = 6,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.x_mult } }
  end,

  -- Returns all available hands sorted by level desc, order asc.
  -- evaluate_poker_hand natively includes SMODS-registered custom hands.
  get_available_hands = function(self, cards)
    local evaluated = evaluate_poker_hand(cards) or {}
    local available = {}
    for hand_name, hand_data in pairs(G.GAME.hands) do
      if evaluated[hand_name] and next(evaluated[hand_name]) then
        table.insert(available, {
          name = hand_name,
          level = hand_data.level,
          order = hand_data.order or 999,
          cards = evaluated[hand_name][1]
        })
      end
    end
    table.sort(available, function(a, b)
      if a.level ~= b.level then return a.level > b.level end
      return a.order < b.order
    end)
    return available
  end,

  -- Validates that cards actually form the claimed hand
  _validate_hand = function(self, hand_name, cards)
    if not cards or #cards == 0 then return false end

    -- Get unique suits from cards (handles custom suits)
    local suits = {}
    local ranks = {}
    for _, c in ipairs(cards) do
      if c.ability then
        suits[c.ability.suit or c.base and c.base.suit] = true
        ranks[c:get_id()] = true
      end
    end
    local suit_count = 0
    for _ in pairs(suits) do suit_count = suit_count + 1 end

    -- Check for debuffed cards in any hand
    for _, c in ipairs(cards) do
      if c.debuff then return false end
    end

    -- Hand-specific validations
    if hand_name == 'Spectrum' or hand_name == 'spectrum' then
      return suit_count >= 5 and #cards >= 5
    elseif hand_name == 'Flush' or hand_name == 'flush' then
      return suit_count == 1 and #cards >= 5
    elseif hand_name == 'Straight' or hand_name == 'straight' then
      if #cards < 5 then return false end
      local ids = {}
      for _, c in ipairs(cards) do table.insert(ids, c:get_id()) end
      table.sort(ids)
      for i = 2, #ids do
        if ids[i] - ids[i-1] ~= 1 then return false end
      end
      return true
    elseif hand_name == 'Straight Flush' or hand_name == 'straight_flush' then
      return self:_validate_hand('Flush', cards) and self:_validate_hand('Straight', cards)
    end

    -- Fallback: check if these exact cards evaluate to this hand
    local re_evaluated = evaluate_poker_hand(cards)
    return re_evaluated[hand_name] and next(re_evaluated[hand_name])
  end,

  -- Clears previous force picks, evaluates best hand, force-locks those cards.
  _select_and_force = function(self, card)
    if G.playing_cards then
      for _, v in ipairs(G.playing_cards) do
        if v.ability.earthbound_forced == card.unique_val then
          v.ability.earthbound_forced = nil
          v.ability.forced_selection = nil
        end
      end
    end
    G.hand:unhighlight_all()
    card.ability.selected_hand = nil

    local available = self:get_available_hands(G.hand.cards)
    local best = nil
    for _, candidate in ipairs(available) do
      if self:_validate_hand(candidate.name, candidate.cards) then
        best = candidate
        break
      end
    end
    if best and best.cards then
      card.ability.selected_hand = best.name
      for _, c in ipairs(best.cards) do
        c.ability.earthbound_forced = card.unique_val
        c.ability.forced_selection = true
        G.hand:add_to_highlighted(c)
      end
      update_hand_text({}, {
        handname = localize(best.name, 'poker_hands'),
        chips = G.GAME.hands[best.name].chips,
        mult = G.GAME.hands[best.name].mult,
        level = G.GAME.hands[best.name].level
      })
    end
  end,

  add_to_deck = function(self, card, from_debuff)
    if from_debuff then
      -- Restore forced picks on undebuff
      if G.playing_cards then
        for _, v in ipairs(G.playing_cards) do
          if v.ability.earthbound_forced == card.unique_val then
            v.ability.forced_selection = true
          end
        end
      end
    elseif G.hand and G.hand.cards and #G.hand.cards > 0 then
      self:_select_and_force(card)
    end
  end,

  remove_from_deck = function(self, card, from_debuff)
    if G.playing_cards then
      for _, v in ipairs(G.playing_cards) do
        if v.ability.earthbound_forced == card.unique_val then
          if not from_debuff then v.ability.earthbound_forced = nil end
          v.ability.forced_selection = nil
        end
      end
    end
  end,

  calculate = function(self, card, context)
    if context.joker_main then
      return { xmult = card.ability.extra.x_mult }
    end
  end
}
