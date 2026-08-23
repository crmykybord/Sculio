SMODS.Enhancement {
  key = 'lead',
  atlas = 'centers',
  pos = { x = 5, y = 0 },
  prefix_config = { atlas = false },

  config = {},
  loc_vars = function(self, info_queue, card)
    return { vars = {} }
  end,
  -- Always placed at the bottom of the deck: handled by the deck shuffle
  -- hook in libs/shuffle.lua (same mechanism as Verified User).
}
