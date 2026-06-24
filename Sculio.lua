Sculio = SMODS.current_mod
SMODS.Atlas { key = 'Sculio', path = 'Sculio.png', px = 71, py = 95 }
SMODS.Atlas { key = 'Sculio_Tags', path = 'Tags.png', px = 34, py = 3 }

SMODS.current_mod.optional_features = function()
  return { post_trigger = true }
end

-- Talisman compat
to_big = to_big or function(...) return ... end

assert(SMODS.load_file('libs/utils.lua'))()

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

assert(SMODS.load_file('libs/shuffle.lua'))()
