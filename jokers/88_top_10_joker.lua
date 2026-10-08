local LADDER = { '10', '9', '8', '7', '6', '5', '4', '3', '2', 'Ace' }
local RARITIES = { 'Common', 'Uncommon', 'Rare' }

local REWARD_KEYS = {
  Common = 'k_Sculio_top_10_common',
  Uncommon = 'k_Sculio_top_10_uncommon',
  Rare = 'k_Sculio_top_10_rare',
}
local NEGATIVE_REWARD = 'k_Sculio_top_10_negative'

local function rung(card)
  local extra = card.ability.extra
  local step = ((extra.step or 0) % #LADDER) + 1
  local rarity_index = math.min(math.ceil(step / extra.rarity_per_rank), #RARITIES)
  local rarity = RARITIES[rarity_index]
  local negative = step == #LADDER
  return step, LADDER[step], negative, rarity,
    (negative and NEGATIVE_REWARD or REWARD_KEYS[rarity]), rarity_index
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
    local step, rank, _, _, reward_key, rarity_index = rung(card)
    return { vars = {
      rank_name(rank),
      localize(reward_key),
      step,
      #LADDER,
      colours = { G.C.RARITY[rarity_index] },
    } }
  end,
  calculate = function(self, card, context)
    if context.blueprint then return end

    if context.hand_drawn and context.first_hand_drawn then
      local eval = function() return G.GAME.current_round.hands_played == 0 end
      juice_card_until(card, eval, true)
    end

    if not context.after or not context.full_hand then return end
    if not G.GAME.current_round or G.GAME.current_round.hands_played ~= 0 then return end

    local extra = card.ability.extra
    local step, rank, negative, rarity = rung(card)
    local found = false
    for _, played in ipairs(context.full_hand) do
      if not SMODS.has_no_rank(played) and played.base.value == rank then
        found = true
        break
      end
    end
    if not found then return end
    if not G.jokers or #G.jokers.cards >= G.jokers.config.card_limit then return end

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