local COLLABS = {
  { key = 'dhmis', name = 'DHMIS', suit = 'Hearts' },
  { key = 'daft_punk', name = 'Daft Punk', suit = 'Spades' },
  { key = 'peak', name = 'Peak', suit = 'Clubs' },
  { key = 'new_vegas', name = 'FallOut New Vegas', suit = 'Spades' },
  { key = 'new_vegas_2', name = 'FallOut New Vegas', suit = 'Hearts' },
  { key = 'faith', name = 'FAITH', suit = 'Diamonds' },
  { key = 'endacopia', name = 'Endacopia', suit = 'Hearts' },
}

local FACE_RANKS = { 'Jack', 'Queen', 'King' }

for _, collab in ipairs(COLLABS) do
  local lc = SMODS.Atlas { key = 'Sculio_ds_' .. collab.key .. '_lc', path = 'Deck Skins/Standard/' .. collab.key .. '_lc.png', px = 71, py = 95 }
  local hc = SMODS.Atlas { key = 'Sculio_ds_' .. collab.key .. '_hc', path = 'Deck Skins/High Contrast/' .. collab.key .. '_hc.png', px = 71, py = 95 }
  SMODS.DeckSkin {
    key = collab.key,
    suit = collab.suit,
    loc_txt = collab.name,
    palettes = {
      { key = 'lc', ranks = FACE_RANKS, display_ranks = FACE_RANKS, atlas = lc.key, pos_style = 'collab' },
      { key = 'hc', ranks = FACE_RANKS, display_ranks = FACE_RANKS, atlas = hc.key, pos_style = 'collab' },
    },
  }
end