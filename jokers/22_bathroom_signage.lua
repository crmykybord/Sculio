local RATES = { 'tarot_rate', 'planet_rate', 'spectral_rate', 'playing_card_rate' }

local function force_zero_rates()
  for _, rate in ipairs(RATES) do
    G.GAME[rate] = 0
  end
end

SMODS.Joker {
  key = 'bathroom_signage',
  attributes = { 'passive', 'joker' },
  unlocked = true,
  discovered = false,
  rarity = 2,
  atlas = 'Sculio',
  pos = { x = 3, y = 2 },
  cost = 5,
  eternal_compat = true,
  blueprint_compat = false,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = {} },
  add_to_deck = function(self, card, from_debuff)
    card.ability.extra.saved_rates = {
      tarot_rate        = G.GAME.tarot_rate        or 0,
      planet_rate       = G.GAME.planet_rate       or 0,
      spectral_rate     = G.GAME.spectral_rate     or 0,
      playing_card_rate = G.GAME.playing_card_rate or 0,
    }
    force_zero_rates()
  end,
remove_from_deck = function(self, card, from_debuff)
    local s = card.ability.extra.saved_rates or {}
    G.GAME.tarot_rate        = s.tarot_rate        or 0
    G.GAME.planet_rate       = s.planet_rate       or 0
    G.GAME.spectral_rate     = s.spectral_rate     or 0
    G.GAME.playing_card_rate = s.playing_card_rate or 0
  end,
}
