SMODS.Joker {
  key = 'rubberhose_joker',
  attributes = { 'xmult', 'full_deck' },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = { xmult_per_card = 0.1 } },
  unlocked = true,
  discovered = false,
  rarity = 3, -- Rare
  atlas = 'Sculio',
  pos = { x = 9, y = 9 },
  cost = 4,
  loc_vars = function(self, info_queue, card)
    local rubberhose_tally = 0
    for _, playing_card in pairs(G.playing_cards or {}) do
      if SMODS.has_any_suit(playing_card)
          or (playing_card.base and (playing_card.base.suit == 'Spades' or playing_card.base.suit == 'Clubs')) then
        rubberhose_tally = rubberhose_tally + 1
      end
    end
    local xmult = math.floor((1 + rubberhose_tally * card.ability.extra.xmult_per_card) * 100 + 0.5) / 100
    return { vars = { card.ability.extra.xmult_per_card, xmult } }
  end,
  calculate = function(self, card, context)
    if context.joker_main then
      local rubberhose_tally = 0
      for _, playing_card in pairs(G.playing_cards or {}) do
        if SMODS.has_any_suit(playing_card)
            or (playing_card.base and (playing_card.base.suit == 'Spades' or playing_card.base.suit == 'Clubs')) then
          rubberhose_tally = rubberhose_tally + 1
        end
      end
      return { xmult = math.floor((1 + rubberhose_tally * card.ability.extra.xmult_per_card) * 100 + 0.5) / 100 }
    end
  end
}
