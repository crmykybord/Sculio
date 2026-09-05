local function roll_rank(card)
  -- ponytail: uniform pick among distinct ranks present in full deck;
  -- weighted-by-count would bias toward stacked ranks
  local seen, valid_ranks = {}, {}
  for _, v in ipairs(G.playing_cards or {}) do
    if v.base and v.base.value and not SMODS.has_no_rank(v) and not seen[v.base.value] then
      seen[v.base.value] = true
      valid_ranks[#valid_ranks + 1] = v.base.value
    end
  end
  if valid_ranks[1] then
    card.ability.extra.rank_value = pseudorandom_element(valid_ranks, pseudoseed('telephone'))
  end
end

SMODS.Joker {
  key = 'telephone',
  attributes = { 'retrigger', 'rank' },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = { rank_value = '2' } },
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
        return {
          message = localize('k_again_ex'),
          repetitions = 1
        }
      end
    end
  end
}
