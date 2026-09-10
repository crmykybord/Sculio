if not Sculio.shuffle_ref then
  Sculio.shuffle_ref = CardArea.shuffle
end
local old_shuffle = Sculio.shuffle_ref

-- Draw-order rules run after every deck shuffle. The deck draws from the END
-- of self.cards, so "drawn first" = moved to the end of the array and
-- "sinks to the bottom" = moved to the front.

local function find_deck_jokers()
  local rorschach, verified_user = nil, nil
  if G and G.jokers and G.jokers.cards then
    for i = 1, #G.jokers.cards do
      local joker = G.jokers.cards[i]
      local key = joker and joker.config and joker.config.center and joker.config.center.key
      if key == 'j_Sculio_rorschach' and joker.ability and joker.ability.extra
        and joker.ability.extra.card_ids_to_draw_next
        and #joker.ability.extra.card_ids_to_draw_next >= 1 then
        rorschach = joker
      end
      if key == 'j_Sculio_verified' then
        verified_user = joker
      end
    end
  end
  return rorschach, verified_user
end

-- Move cards matching pred to the end of the array (drawn first).
-- Shared by Verified (Blue Seals first) and Rorschach (priority ids first).
local function prioritize(cards, pred)
  local first, rest = {}, {}
  for _, c in ipairs(cards) do
    if pred(c) then first[#first + 1] = c else rest[#rest + 1] = c end
  end
  for _, c in ipairs(first) do rest[#rest + 1] = c end
  return rest
end

-- Lead cards sink to the bottom: moved to the front (drawn last).
-- Returns nil when the deck holds no Lead cards.
local function sink_lead(cards)
  local lead, rest = {}, {}
  for _, c in ipairs(cards) do
    if SMODS.has_enhancement(c, 'm_Sculio_lead') then lead[#lead + 1] = c
    else rest[#rest + 1] = c end
  end
  if #lead == 0 then return nil end
  for _, c in ipairs(rest) do lead[#lead + 1] = c end
  return lead
end

function CardArea:shuffle(_seed)
  local g = old_shuffle(self, _seed)

  if G and self == G.deck then
    local rorschach, verified_user = find_deck_jokers()
    if rorschach or verified_user then
      local rearranged = false
      if verified_user then
        self.cards = prioritize(self.cards, function(c) return c.seal == 'Blue' end)
        rearranged = true
      end
      if rorschach then
        local ids = rorschach.ability.extra.card_ids_to_draw_next or {}
        self.cards = prioritize(self.cards, function(c)
          for _, id in ipairs(ids) do
            if id == c.ID then return true end
          end
          return false
        end)
        rorschach.ability.extra.card_ids_to_draw_next = {}
        rearranged = true
      end
      if rearranged then
        self:set_ranks()
      end
    end

    local sunk = sink_lead(self.cards)
    if sunk then
      self.cards = sunk
      self:set_ranks()
    end
  end

  return g
end
