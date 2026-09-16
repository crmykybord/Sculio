SMODS.Voucher {
  key = 'inverted_merchant',
  atlas = 'Sculio_Vouchers',
  pos = { x = 0, y = 0 },
  cost = 10,
  order = 33,
  config = { extra = 9.6 / 4, extra_disp = 2 },
  loc_vars = function(self, info_queue, card)
    return { vars = { self.config.extra_disp } }
  end,
  redeem = function(self, card)
    G.GAME.inverted_rate = 4 * self.config.extra
  end,
}

SMODS.Voucher {
  key = 'inverted_tycoon',
  atlas = 'Sculio_Vouchers',
  pos = { x = 0, y = 1 },
  cost = 10,
  order = 34,
  requires = { 'v_Sculio_inverted_merchant' },
  config = { extra = 32 / 4, extra_disp = 4 },
  loc_vars = function(self, info_queue, card)
    return { vars = { self.config.extra_disp } }
  end,
  redeem = function(self, card)
    G.GAME.inverted_rate = 4 * self.config.extra
  end,
}
