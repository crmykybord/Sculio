-- Install the shuffle hook once, storing the original under the mod table.
if not Sculio.shuffle_ref then
  Sculio.shuffle_ref = CardArea.shuffle
end
local old_shuffle = Sculio.shuffle_ref

-- Original implementation for Verified User: Somethingcom515 {SealsOnAll}
function CardArea:shuffle(_seed)
  local g = old_shuffle(self, _seed)

  local rorschach = nil
  local verified_user = nil

  for i = 1, #G.jokers.cards do
    local joker = G.jokers.cards[i]

    if joker and joker.ability.name == 'j_Sculio_rorschach' and #joker.ability.extra.card_ids_to_draw_next >= 1 then
      rorschach = joker
    end

    if joker and joker.ability.name == 'j_Sculio_verified' then
      verified_user = joker
    end
  end

  if self == G.deck and (rorschach or verified_user) then
    -- Later prioritizations override earlier ones.
    -- rorschach should take priority over Verified User.
    -- Therefore, we handle the Verified User logic first.
    if verified_user then
      local priorities = {}
      local others = {}

      for _, v in pairs(self.cards) do
        if v.seal == 'Blue' then
          table.insert(priorities, v)
        else
          table.insert(others, v)
        end
      end

      for _, card in ipairs(priorities) do
        table.insert(others, card)
      end

      self.cards = others
    end

    if rorschach then
      local priorities = {}
      local others = {}
      local ids = rorschach.ability.extra.card_ids_to_draw_next or {}

      for _, v in pairs(self.cards) do
        local found = false
        for _, id in ipairs(ids) do
          if id == v.ID then found = true break end
        end
        if found then
          table.insert(priorities, v)
        else
          table.insert(others, v)
        end
      end

      for _, card in ipairs(priorities) do
        table.insert(others, card)
      end

      self.cards = others
      rorschach.ability.extra.card_ids_to_draw_next = {}
    end

    self:set_ranks()
  end

  -- ponytail: Lead Cards sink to the bottom only on reshuffles; mid-round
  -- draw order can still surface them. Per-draw interception if that matters.
  if self == G.deck then
    local has_lead = false
    for _, v in ipairs(self.cards) do
      if SMODS.has_enhancement(v, 'm_Sculio_lead') then has_lead = true break end
    end
    if has_lead then
      -- Deck draws from the END of self.cards, so leads must sit at the FRONT
      local arranged = {}
      for _, v in ipairs(self.cards) do
        if SMODS.has_enhancement(v, 'm_Sculio_lead') then
          table.insert(arranged, v)
        end
      end
      for _, v in ipairs(self.cards) do
        if not SMODS.has_enhancement(v, 'm_Sculio_lead') then
          table.insert(arranged, v)
        end
      end
      self.cards = arranged
      self:set_ranks()
    end
  end

  return g
end
