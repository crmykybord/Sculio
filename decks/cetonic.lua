-- Cetonic Deck: Arcana Packs never appear in the shop.
-- get_pack (common_events.lua) respects G.GAME.banned_keys, and Back:apply
-- runs after init_game_object resets banned_keys, so the ban sticks.
local ARCANA_KEYS = {
  'p_arcana_normal_1', 'p_arcana_normal_2', 'p_arcana_normal_3', 'p_arcana_normal_4',
  'p_arcana_jumbo_1', 'p_arcana_jumbo_2',
  'p_arcana_mega_1', 'p_arcana_mega_2',
}

SMODS.Back {
  key = 'cetonic',
  atlas = 'Sculio_Enhancements',
  pos = { x = 6, y = 4 },
  order = 16,
  apply = function(self, back)
    for _, key in ipairs(ARCANA_KEYS) do
      G.GAME.banned_keys[key] = true
    end
  end,
}
