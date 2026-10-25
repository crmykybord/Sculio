local function roll_rank(card)
  local seen, ranks = {}, {}
  for _, v in ipairs(G.playing_cards or {}) do
    if not v:is_face() and not SMODS.has_no_rank(v) then
      local value = v.base and v.base.value
      if value and not seen[value] then
        seen[value] = true
        ranks[#ranks + 1] = value
      end
    end
  end
  if #ranks > 0 then
    card.ability.extra.rolls = (card.ability.extra.rolls or 0) + 1
    card.ability.extra.rank_value = pseudorandom_element(ranks, 'telephone_' .. card.ability.extra.rolls)
  end
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
  rarity = 1,
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
    if context.repetition and context.cardarea == G.play and context.other_card
        and context.other_card.base and context.other_card.base.value == card.ability.extra.rank_value then
      return { message = localize('k_again_ex') }
    end
  end
}