-- Signage suppresses non-joker shop spawns via G.GAME rates (type selection)
-- plus SMODS object_weights (specific card selection within a type).
-- A non-zero G.GAME rate means a voucher/deck/mod has taken control;
-- Signage only zeroes weights for types whose rate is still 0.
local RATES = { 'tarot_rate', 'planet_rate', 'spectral_rate', 'playing_card_rate' }

local function force_zero_rates()
  for _, rate in ipairs(RATES) do
    G.GAME[rate] = 0
  end
end

SMODS.Joker {
  key = 'signage',
  attributes = { 'passive', 'joker' },
  unlocked = true,
  discovered = false,
  rarity = 1,
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

    for voucher_key in pairs(G.GAME.used_vouchers or {}) do
      if G.P_CENTERS[voucher_key] then
        Card.apply_to_run(nil, G.P_CENTERS[voucher_key])
      end
    end
  end,
  calculate = function(self, card, context)
    if context.modify_weights then
      for _, entry in ipairs(context.pool) do
        local center = G.P_CENTERS[entry.key]
        if center then
          local set = center.set or center.kind
          if set and set ~= 'Joker' then
            local rate_key = set:lower() .. '_rate'
            if (G.GAME[rate_key] ~= nil) and G.GAME[rate_key] == 0 then
              entry.weight = 0
            end
          end
        end
      end
    end
  end
}
