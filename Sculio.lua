Sculio = SMODS.current_mod

SMODS.Atlas {
  -- Key for code to find it with
  key = 'Sculio',
  -- The name of the file, for the code to pull the atlas from
  path = 'Sculio.png', -- Original file sourced from https://github.com/Steamodded/examples/tree/master/Mods/ExampleJokersMod/assets
  -- Width of each sprite in 1x size
  px = 71,
  -- Height of each sprite in 1x size
  py = 95
}

SMODS.Atlas {
  key = 'Sculio_Tags',
  path = 'Tags.png',
  px = 34,
  py = 34
}

SMODS.Atlas {
  key = 'modicon',
  path = 'Tags.png',
  px = 34,
  py = 34
}

SMODS.current_mod.optional_features = function()
  return {
    post_trigger = true
  }
end

-- Talisman compat
to_big = to_big or function(...) return ... end

-- Load Jokers: https://github.com/neatoqueen/NeatoJokers/blob/main/NeatoJokers.lua#L32
local subdir = 'jokers'
local cards = NFS.getDirectoryItems(SMODS.current_mod.path .. subdir)

table.sort(cards, function(a, b)
  local a_num = tonumber(a:match('^(%d+)_')) or 0
  local b_num = tonumber(b:match('^(%d+)_')) or 0
  return a_num < b_num
end)

for _, filename in ipairs(cards) do
  assert(SMODS.load_file(subdir .. '/' .. filename))()
end

assert(SMODS.load_file('shuffle.lua'))()
