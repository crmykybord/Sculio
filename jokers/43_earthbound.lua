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

  -- Ask the game itself which hand the current selection scores as, so the cards we
  -- lock in are always exactly the cards that hand is scored with.
  -- evaluate_poker_hand() must not be used for this: it files partial combos under
  -- the wrong name (a five of a kind lands in 'Four of a Kind', which then forces
  -- five cards for a hand that only uses four), a flush can span more than five
  -- cards, and ranking by hand level can prefer a weak leveled-up hand over the
  -- hand that actually scores.
  get_best_hand = function(self, cards)
    if not cards or #cards < 1 then return nil end
    if not (G.FUNCS and G.FUNCS.get_poker_hand_info) then return nil end
    local name, loc_name, _, scoring_hand = G.FUNCS.get_poker_hand_info(cards)
    if not name or name == 'NULL' then return nil end
    if type(scoring_hand) ~= 'table' or #scoring_hand < 1 then return nil end
    -- At most five cards ever score, so never force more than that.
    local forced = {}
    for i = 1, math.min(#scoring_hand, 5) do
      forced[i] = scoring_hand[i]
    end
    return { name = name, loc_name = loc_name, cards = forced }
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
