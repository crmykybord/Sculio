-- Rubberhose Joker: live Mult counting the deck, the Untextured/Steel pattern.
-- Counts Spades or Clubs cards in G.playing_cards at score time; a card that
-- matches both (Versatiles count as any suit) is counted once. The shared
-- helper feeds loc_vars and calculate so the description never lies (DOX rule),
-- and the value is rounded to avoid float noise in the +Mult display.
local function rubberhose_mult(card)
  local count = 0
  for _, playing_card in ipairs(G.playing_cards or {}) do
    if SMODS.has_any_suit(playing_card)
        or playing_card.base.suit == 'Spades' or playing_card.base.suit == 'Clubs' then
      count = count + 1
    end
  end
  return math.floor(count * card.ability.extra.mult_per_card * 100 + 0.5) / 100
end

SMODS.Joker {
  key = 'rubberhose_joker',
  attributes = { 'mult', 'full_deck' },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = { mult_per_card = 0.1 } },
  unlocked = true,
  discovered = false,
  rarity = 1, -- Common
  atlas = 'Sculio',
  pos = { x = 9, y = 9 },
  cost = 4,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.mult_per_card, rubberhose_mult(card) } }
  end,
  calculate = function(self, card, context)
    if context.joker_main then
      return { mult = rubberhose_mult(card) }
    end
  end
}
