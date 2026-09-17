SMODS.Voucher {
  key = 'droste_effect',
  atlas = 'Sculio_Vouchers',
  pos = { x = 1, y = 0 },
  cost = 10,
  order = 35,
  redeem = function(self, card)
    Sculio.apply_droste_bonus()
  end,
}

SMODS.Voucher {
  key = 'distorted_flow',
  atlas = 'Sculio_Vouchers',
  pos = { x = 1, y = 1 },
  cost = 10,
  order = 36,
  requires = { 'v_Sculio_droste_effect' },
}
