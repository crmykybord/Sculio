SMODS.Joker {
  key = 'verified',
  attributes = { 'passive', 'seals' },

  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 3, y = 0 },
  cost = 8,
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_SEALS.Blue
  end
  -- See shuffle.lua for relevant implementation code.
}
