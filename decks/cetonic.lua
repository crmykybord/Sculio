local ARCANA_KEYS = {
  'p_arcana_normal_1', 'p_arcana_normal_2', 'p_arcana_normal_3', 'p_arcana_normal_4',
  'p_arcana_jumbo_1', 'p_arcana_jumbo_2', 'p_arcana_mega_1', 'p_arcana_mega_2',
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
    G.GAME.used_vouchers['v_Sculio_inverted_merchant'] = true
    G.GAME.inverted_rate = 4 * G.P_CENTERS.v_Sculio_inverted_merchant.config.extra
  end,
}
