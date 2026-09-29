SMODS.Joker {
  key = 'earthbound',
  attributes = { 'xmult', 'hand_type' },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = { x_mult = 3 } },
  unlocked = true,
  discovered = false,
  rarity = 2,
  atlas = 'Sculio',
  pos = { x = 4, y = 4 },
  cost = 7,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.x_mult } }
  end,

  is_active_owner = function(self, card)
    for _, j in ipairs(G.jokers and G.jokers.cards or {}) do
      if j.config.center.key == 'j_Sculio_earthbound' and not j.debuff then
        return j == card
      end
    end
    return false
  end,

  -- Cheap, side effect free estimate of what a card adds to a hand.
  -- get_chip_bonus/get_edition are safe to call, but the get_chip_*_mult helpers are
  -- not: Lucky Card draws from the RNG there, which would both shift the sequence
  -- and light up cards that never scored. So read the ability fields directly.
  card_value = function(self, card)
    if card.debuff then return 0, 0, 1 end
    local chips = card:get_chip_bonus()
    local mult = card.ability.mult or 0
    local x_mult = card.ability.x_mult or 1
    local edition = card:get_edition()
    if edition then
      chips = chips + (edition.chip_mod or 0)
      mult = mult + (edition.mult_mod or 0)
      x_mult = x_mult * (edition.x_mult_mod or 1)
    end
    return chips, mult, x_mult
  end,

  -- What a hand is actually worth, mirroring the accumulation in vanilla's
  -- evaluate_play: every scoring card's chips add to the hand's chips, and every
  -- scoring card's mult/x_mult applies on top of the hand's mult. Enhancements,
  -- editions and permanent bonuses therefore all count.
  hand_score = function(self, hand_name, cards)
    local hand_data = G.GAME.hands[hand_name]
    if not hand_data then return 0 end
    local chips, mult, x_mult = hand_data.chips, hand_data.mult, 1
    for _, c in ipairs(cards) do
      local card_chips, card_mult, card_x_mult = self:card_value(c)
      chips = chips + card_chips
      mult = mult + card_mult
      x_mult = x_mult * card_x_mult
    end
    return chips * mult * x_mult
  end,

  -- Try every legal selection and keep whichever scores highest.
  -- evaluate_poker_hand() cannot be trusted to pick it: it files partial combos
  -- under the wrong name (a five of a kind lands in 'Four of a Kind', which then
  -- forces five cards for a hand that only uses four), a flush can span more than
  -- five cards, and get_straight returns the first (lowest) straight it walks into,
  -- so it picks a low straight over a far better one. Ranking by hand level instead
  -- ignores both the strength of the cards and any chips/mult they carry, so an
  -- enhanced card could be dropped in favour of a blank one.
  get_best_hand = function(self, cards)
    if not cards or #cards < 1 then return nil end
    if not (G.FUNCS and G.FUNCS.get_poker_hand_info) then return nil end
    if not (G.GAME and G.GAME.hands) then return nil end

    local best, best_score, best_order, best_len
    local indices = {}

    local function consider(selection)
      local name, loc_name, _, scoring_hand = G.FUNCS.get_poker_hand_info(selection)
      if not name or name == 'High Card' or name == 'NULL' then return end
      if type(scoring_hand) ~= 'table' or #scoring_hand < 1 then return end
      local hand_data = G.GAME.hands[name]
      if not hand_data then return end

      if #scoring_hand > 5 then
        -- A flush can span more than five cards. Only five are ever played, so keep
        -- the five worth the most rather than whatever order they came in.
        local ranked = {}
        for i = 1, #scoring_hand do ranked[i] = scoring_hand[i] end
        table.sort(ranked, function(a, b)
          local a_chips = self:card_value(a)
          local b_chips = self:card_value(b)
          if a_chips ~= b_chips then return a_chips > b_chips end
          return a.T.x < b.T.x
        end)
        scoring_hand = {}
        for i = 1, 5 do scoring_hand[i] = ranked[i] end
      end

      local order = hand_data.order or 999
      local score = self:hand_score(name, scoring_hand)

      -- Ties go to the stronger hand, then to the one wasting fewer cards.
      local better
      if not best then
        better = true
      elseif score ~= best_score then
        better = score > best_score
      elseif order ~= best_order then
        better = order < best_order
      else
        better = #scoring_hand < best_len
      end

      if better then
        best = { name = name, loc_name = loc_name, score = score, cards = scoring_hand }
        best_score, best_order, best_len = score, order, #scoring_hand
      end
    end

    -- Combinations of 1..5 cards, so plain pairs, three of a kind and the like are
    -- all considered alongside the five card hands.
    local function walk(size, at)
      if #indices == size then
        local selection = {}
        for i = 1, size do selection[i] = cards[indices[i]] end
        consider(selection)
        return
      end
      for i = at, #cards do
        indices[#indices + 1] = i
        walk(size, i + 1)
        indices[#indices] = nil
      end
    end

    for size = 1, math.min(5, #cards) do
      walk(size, 1)
    end

    return best
  end,

  select_and_force = function(self, card)
    if not self:is_active_owner(card) then return end
    if not G.hand or not G.hand.cards then return end
    if G.playing_cards then
      for _, v in ipairs(G.playing_cards) do
        if v.ability.earthbound_forced then
          v.ability.earthbound_forced = nil
          v.ability.forced_selection = nil
        end
      end
    end
    G.hand:unhighlight_all()
    card.ability.selected_hand = nil

    -- High Card means nothing better is on the table, so leave the selection to the
    -- player instead of locking them into a single card.
    local best = self:get_best_hand(G.hand.cards)
    if not best or best.name == 'High Card' then return end

    card.ability.selected_hand = best.name
    for _, c in ipairs(best.cards) do
      c.ability.earthbound_forced = card.unique_val
      c.ability.forced_selection = true
      G.hand:add_to_highlighted(c)
    end
    local hand_data = G.GAME.hands[best.name]
    if hand_data then
      update_hand_text({}, {
        handname = best.loc_name or localize(best.name, 'poker_hands'),
        chips = hand_data.chips,
        mult = hand_data.mult,
        level = hand_data.level,
      })
    end
  end,

  -- Re-apply force picks after vanilla would have cleared them.
  reapply_force = function(self, card)
    if not self:is_active_owner(card) then return end
    if G.playing_cards then
      for _, v in ipairs(G.playing_cards) do
        if v.ability.earthbound_forced == card.unique_val then
          v.ability.forced_selection = true
        end
      end
    end
  end,

  add_to_deck = function(self, card, from_debuff)
    if from_debuff then
      self:reapply_force(card)
    elseif G.hand and G.hand.cards and #G.hand.cards > 0 and self:is_active_owner(card) then
      self:select_and_force(card)
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
    if context.hand_drawn then
      self:select_and_force(card)
    elseif context.press_play or context.pre_discard then
      self:reapply_force(card)
    elseif context.joker_main then
      return { xmult = card.ability.extra.x_mult }
    end
  end,
}
