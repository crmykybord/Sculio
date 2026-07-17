local function count_missing_ranks()
  if not G.playing_cards then return 13 end
  local existing = {}
  for _, c in ipairs(G.playing_cards) do
    if not SMODS.has_no_rank(c) then
      existing[c:get_id()] = true
    end
  end
  local missing = 0
  for i = 2, 14 do if not existing[i] then missing = missing + 1 end end
  return missing
end

SMODS.Joker {
  key = 'joker_of_nothing',
  attributes = { 'xmult', 'king' },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = false,
  rental_compat = true,
  config = { extra = { x_mult_per_rank = 0.25 } },
  unlocked = true,
  discovered = false,
  rarity = 3,
  atlas = 'Sculio',
  pos = { x = 1, y = 6 },
  cost = 8,
  loc_vars = function(self, info_queue, card)
    local missing = count_missing_ranks()
    return { vars = { card.ability.extra.x_mult_per_rank, missing, 1 + card.ability.extra.x_mult_per_rank * missing } }
  end,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and context.other_card:get_id() == 13 then
      local missing = count_missing_ranks()
      if card.ability.extra.last_missing == nil then
        card.ability.extra.last_missing = missing
      end
      return { xmult = 1 + card.ability.extra.x_mult_per_rank * missing, card = card }
    end
    if not context.blueprint and ((context.remove_playing_cards and #context.removed > 0) ) then
      local missing = count_missing_ranks()
      if card.ability.extra.last_missing == nil then
        card.ability.extra.last_missing = missing
      elseif missing > card.ability.extra.last_missing then
        card.ability.extra.last_missing = missing
        return {
          message = localize('k_upgrade_ex'),
          message_card = card,
        }
      end
    end
  end
}
