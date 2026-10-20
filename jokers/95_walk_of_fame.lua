-- Walk of Fame: when a Boss Blind is defeated, a random Joker (one that does
-- not have an edition yet) gets a random edition: Laminada, Holografica or
-- Polychrome (vanilla's three "cosmetic" editions, no Negative per design).
-- blueprint_compat = false: it mutates other cards (same rule as Fun Guy).
local EDITIONS = { 'foil', 'holographic', 'polychrome' }

SMODS.Joker {
  key = 'walk_of_fame',
  attributes = { 'editions' },
  eternal_compat = true,
  blueprint_compat = false,
  perishable_compat = true,
  rental_compat = true,
  config = {},
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 6, y = 9 },
  cost = 6,
  calculate = function(self, card, context)
    if context.end_of_round and context.main_eval and context.beat_boss and not context.game_over then
      local pool = {}
      for _, joker in ipairs(G.jokers.cards) do
        if not joker.edition or not next(joker.edition) then pool[#pool + 1] = joker end
      end
      -- everybody is already dressed up: nothing to hand out
      if #pool == 0 then return end
      local target = pool[math.floor(pseudoseed('Sculio_walk_of_fame') * #pool) + 1]
      local edition = EDITIONS[math.floor(pseudoseed('Sculio_walk_of_fame_edition') * #EDITIONS) + 1]
      G.E_MANAGER:add_event(Event({
        func = function()
          target:set_edition({ [edition] = true }, true)
          return true
        end
      }))
      return { message = localize('k_upgrade_ex'), colour = G.C.DARK_EDITION }
    end
  end
}
