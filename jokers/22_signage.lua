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
    -- Snapshot current rates before restoring. Any rate that is non-zero
    -- at this point was set by a voucher (or deck/mod) while Signage was
    -- active. We preserve those values instead of re-applying every voucher
    -- via Card.apply_to_run (which would duplicate slot/discount/etc effects).
    local current = {
      tarot_rate        = G.GAME.tarot_rate,
      planet_rate       = G.GAME.planet_rate,
      spectral_rate     = G.GAME.spectral_rate,
      playing_card_rate = G.GAME.playing_card_rate,
    }
    local s = card.ability.extra.saved_rates or {}
    for _, rate in ipairs(RATES) do
      if current[rate] and current[rate] ~= 0 then
        G.GAME[rate] = current[rate]
      else
        G.GAME[rate] = s[rate] or 0
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
