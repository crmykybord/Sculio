Sculio = SMODS.current_mod
SMODS.Atlas { key = 'Sculio', path = 'Sculio.png', px = 71, py = 95 }
SMODS.Atlas { key = 'Sculio_Tags', path = 'Tags.png', px = 34, py = 34 }
SMODS.Atlas { key = 'Sculio_Consumables', path = 'Consumables.png', px = 71, py = 95 }
SMODS.Atlas { key = 'Sculio_Enhancements', path = 'Enhancements.png', px = 71, py = 95 }
SMODS.ConsumableType { key = 'Inverted', primary_colour = HEX 'B14AB8', secondary_colour = HEX 'A84C45', collection_rows = { 6, 5 }, }

SMODS.current_mod.optional_features = function()
  return { post_trigger = true }
end

-- Talisman compat
to_big = to_big or function(...) return ... end

assert(SMODS.load_file('libs/utils.lua'))()

-- Load cards: https://github.com/neatoqueen/NeatoJokers/blob/main/NeatoJokers.lua#L32
local function load_dir(subdir, skip_files)
  local files = NFS.getDirectoryItems(SMODS.current_mod.path .. subdir)

  table.sort(files, function(a, b)
    local a_num = tonumber(a:match('^(%d+)_')) or 0
    local b_num = tonumber(b:match('^(%d+)_')) or 0
    return a_num < b_num
  end)

  for _, filename in ipairs(files) do
    if not (skip_files and skip_files[filename]) then
      assert(SMODS.load_file(subdir .. '/' .. filename))()
    end
  end
end

-- Temporarily disabled content: remove entries to re-enable
local skip_files = {
  -- Disable until they have a proper sprite
  ['divine.lua'] = true,
  ['siege.lua'] = true,
  ['trap.lua'] = true,
  -- Disable until my brain works properly
  ['09_arbitrariness.lua'] = true,
  ['11_immutable_wheel.lua'] = true,
  ['13_the_atoned.lua'] = true,
  ['14_reborn.lua'] = true,
  ['15_the_impatient.lua'] = true,
  ['16_the_archangel.lua'] = true,
  ['17_the_siege.lua'] = true,
  ['18_the_collapse.lua'] = true,
  ['19_the_eclipse.lua'] = true,
  ['20_the_twilight.lua'] = true,
  ['21_the_cave.lua'] = true,
}

load_dir('jokers', skip_files)
load_dir('consumables', skip_files)
load_dir('enhancements', skip_files)

assert(SMODS.load_file('libs/shuffle.lua'))()

-- Multiplayer compatibility
if MP and MP.DECK and MP.DECK.ban_card then
	sendDebugMessage("Sculio MP compatibility active", "MULTIPLAYER")
	MP.DECK.ban_card("j_Sculio_reach")
end
