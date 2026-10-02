-- The ladder walks the top ten poker ranks down: 10, 9, ... 2 and then Ace, because
-- poker has no 1. Every `extra.rarity_per_rank` rungs the created Joker up a rarity,
-- and the last rung (Ace) hands out a random Negative Joker instead of a rarity.
-- After that the ladder resets back to 10.
local LADDER = { '10', '9', '8', '7', '6', '5', '4', '3', '2', 'Ace' }
local RARITIES = { 'Common', 'Uncommon', 'Rare' }

-- Not vanilla's k_common / k_uncommon / k_rare: those agree with "carta" in es_419
-- ("Rara"), while here the word has to agree with "Joker" / "Comodín".
local REWARD_KEYS = {
  Common = 'k_Sculio_top_10_common',
  Uncommon = 'k_Sculio_top_10_uncommon',
  Rare = 'k_Sculio_top_10_rare',
}
local NEGATIVE_REWARD = 'k_Sculio_top_10_negative'

-- step (1..#LADDER), rank key, is_negative, rarity key, reward dictionary key
local function rung(card)
  local extra = card.ability.extra
  local step = ((extra.step or 0) % #LADDER) + 1
  local rarity = RARITIES[math.min(math.ceil(step / extra.rarity_per_rank), #RARITIES)]
  local negative = step == #LADDER
  return step, LADDER[step], negative, rarity,
    (negative and NEGATIVE_REWARD or REWARD_KEYS[rarity])
end

local function rank_name(rank)
  local ranks = G.localization and G.localization.misc and G.localization.misc.ranks
  return (ranks and ranks[rank]) or rank
end

SMODS.Joker {
  key = 'top_10_joker',
  attributes = { 'rank', 'joker', 'generation', 'rarity' },
  eternal_compat = true,
  blueprint_compat = false,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = { step = 0, rarity_per_rank = 3 } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 0, y = 9 },
  cost = 7,
  loc_vars = function(self, info_queue, card)
    local step, rank, _, _, reward_key = rung(card)
    return { vars = { rank_name(rank), localize(reward_key), step, #LADDER } }
  end,
  calculate = function(self, card, context)
    if context.blueprint then return end

    -- Waits for `after` so the Joker is created (and its message drawn) once the hand has
    -- finished scoring. `hands_played` is bumped later still, so it reads 0 here.
    if not context.after or not context.full_hand or #context.full_hand ~= 1 then return end
    if not G.GAME.current_round or G.GAME.current_round.hands_played ~= 0 then return end

    local extra = card.ability.extra
    local step, rank, negative, rarity = rung(card)
    local played = context.full_hand[1]
    -- A rankless Wild/Stone still prints its real rank, so screen those out.
    if SMODS.has_no_rank(played) or played.base.value ~= rank then return end
    if not G.jokers or #G.jokers.cards >= G.jokers.config.card_limit then return end

    -- Advance before queueing so the description never shows a rung that already paid out.
    extra.step = step
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.4,
      func = function()
        if #G.jokers.cards >= G.jokers.config.card_limit then return true end
        local created = SMODS.create_card({
          set = 'Joker',
          area = G.jokers,
          rarity = rarity,
          key_append = 'sculio_top_10_joker',
          no_edition = negative or nil,
          edition = negative and { negative = true } or nil,
        })
        if not created then return true end
        play_sound('timpani')
        created:add_to_deck()
        G.jokers:emplace(created)
        created:start_materialize()
        card_eval_status_text(card, 'extra', nil, nil, nil, {
          message = localize { type = 'name_text', key = created.key, set = 'Joker' },
          colour = G.C.SET.Joker,
        })
        return true
      end
    }))
  end,
}