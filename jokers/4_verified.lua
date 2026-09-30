SMODS.Joker {
  key = 'verified',
  attributes = { 'passive', 'seals' },
  unlocked = true,
  discovered = false,
  eternal_compat = true,
  blueprint_compat = false,
  perishable_compat = true,
  rental_compat = true,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 3, y = 0 },
  cost = 8,
  in_pool = function(self)
    -- Dead weight without a Blue Seal to reorder, so keep it out of the pool.
    for _, c in ipairs(G.playing_cards or {}) do
      if c.seal == 'Blue' then
        return true
      end
    end
    return false
  end,
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_SEALS.Blue
  end
  -- See shuffle.lua for relevant implementation code.
}
