local RATES = { 'tarot_rate', 'planet_rate', 'spectral_rate', 'playing_card_rate', 'inverted_rate' }

local function force_zero_rates()
  for _, rate in ipairs(RATES) do
    G.GAME[rate] = 0
  end
end

local function save_rates(card)
  card.ability.extra.saved_rates = {
    tarot_rate        = G.GAME.tarot_rate        or 0,
    planet_rate       = G.GAME.planet_rate       or 0,
    spectral_rate     = G.GAME.spectral_rate     or 0,
    playing_card_rate = G.GAME.playing_card_rate or 0,
    inverted_rate     = G.GAME.inverted_rate     or 0,
  }
end

local function restore_rates(card)
  local s = card.ability.extra.saved_rates or {}
  G.GAME.tarot_rate        = s.tarot_rate        or 0
  G.GAME.planet_rate       = s.planet_rate       or 0
  G.GAME.spectral_rate     = s.spectral_rate     or 0
  G.GAME.playing_card_rate = s.playing_card_rate or 0
  G.GAME.inverted_rate     = s.inverted_rate     or 0
end

-- Only one Signage may be active at a time; extras are inert copies.
local active_signage = nil

local function activate(card)
  active_signage = card
  card.ability.extra.inactive = nil
  save_rates(card)
  force_zero_rates()
end

local function deactivate(card)
  card.ability.extra.inactive = true
end

local function promote_next(removed)
  active_signage = nil
  if not (G.jokers and G.jokers.cards) then return end
  for _, j in ipairs(G.jokers.cards) do
    if j ~= removed and j.config and j.config.center
        and j.config.center.key == 'j_Sculio_signage' and not j.debuff then
      activate(j)
      return
    end
  end
end

SMODS.Joker {
  key = 'signage',
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
    if active_signage and active_signage ~= card then
      deactivate(card)
      return
    end
    activate(card)
  end,
  remove_from_deck = function(self, card, from_debuff)
    if card.ability.extra and card.ability.extra.inactive then
      card.ability.extra.inactive = nil
      return
    end
    restore_rates(card)
    promote_next(card)
  end,
}
