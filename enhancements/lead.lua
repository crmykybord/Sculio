SMODS.Enhancement {
  key = 'lead',
  atlas = 'Sculio_Enhancements',
  pos = { x = 0, y = 0 },

  config = {},
  loc_vars = function(self, info_queue, card)
    return { vars = {} }
  end,
  -- Always placed at the bottom of the deck: handled by the deck shuffle
  -- hook in libs/shuffle.lua (same mechanism as Verified User).
}
