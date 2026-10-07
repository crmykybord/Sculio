-- Face cards are excluded: the retrigger is meant to key off a number rank.
-- Ace stays (is_face is ids 11/12/13 only).
local FACE_RANKS = { Jack = true, Queen = true, King = true }

local function roll_rank(card)
  local seen, valid_ranks = {}, {}
  for _, v in ipairs(G.playing_cards or {}) do
    local value = v.base and v.base.value
    if value and not FACE_RANKS[value] and not SMODS.has_no_rank(v) and not seen[value] then
      seen[value] = true
      valid_ranks[#valid_ranks + 1] = value
    end
  end
  if not valid_ranks[1] then return end

  local extra = card.ability.extra
  extra.rolls = (extra.rolls or 0) + 1
  local salt = 'telephone_' .. tostring(extra.rolls) .. '_' .. tostring(G.GAME.round or 0)
  extra.rank_value = valid_ranks[math.floor(pseudoseed(salt) * #valid_ranks) + 1]
end

SMODS.Joker {
  key = 'telephone',
  attributes = { 'retrigger', 'rank' },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = { rank_value = '2', rolls = 0 } },
  unlocked = true,
  discovered = false,
  rarity = 1, -- Common
  atlas = 'Sculio',
  pos = { x = 0, y = 6 },
  cost = 5,
  loc_vars = function(self, info_queue, card)
    return { vars = { localize(card.ability.extra.rank_value, 'ranks') } }
  end,
  add_to_deck = function(self, card, from_debuff)
    roll_rank(card)
  end,
  calculate = function(self, card, context)
    if context.setting_blind and not context.blueprint then
      roll_rank(card)
    end

    if context.cardarea == G.play and context.repetition and not context.repetition_only then
      if context.other_card.base.value == card.ability.extra.rank_value then
        return { message = localize('k_again_ex'), repetitions = 1 }
      end
    end
  end
}
