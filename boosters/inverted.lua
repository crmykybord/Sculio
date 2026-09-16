-- Inverted Arcana booster packs. Pool is exclusively Inverted Tarots, with the
-- same 0.3% chance of The Soul as vanilla Arcana packs. Booster sizes mirror
-- vanilla: 4 normal variants, 2 jumbo, 2 mega.

local function inverted_card(self, card, i)
  if not G.GAME.banned_keys['c_soul']
      and not (G.GAME.used_jokers['c_soul'] and not next(find_joker('Showman')))
      and pseudorandom('soul_Inverted' .. G.GAME.round_resets.ante .. (i or '')) > 0.997 then
    return { set = 'Spectral', key = 'c_soul', area = G.pack_cards, skip_materialize = true, key_append = 'inv_soul' }
  end
  return { set = 'Inverted', area = G.pack_cards, skip_materialize = true, key_append = 'inv' }
end

-- Share one localization entry per size: p_Sculio_inverted_normal_1 -> p_Sculio_inverted_normal
local function pack_loc_vars(self, info_queue, card)
  local orig = SMODS.Booster.loc_vars(self, info_queue, card)
  orig.key = self.key:gsub('_%d$', '')
  return orig
end

local function register(key, pos, size, weight, cost, order, config)
  SMODS.Booster {
    key = key,
    atlas = 'Sculio_Booster',
    pos = pos,
    kind = 'Inverted',
    group_key = 'k_booster_group_sculio_inverted',
    draw_hand = true,
    weight = weight,
    cost = cost,
    order = order,
    config = config,
    attributes = { size },
    loc_vars = pack_loc_vars,
    create_card = inverted_card,
    ease_background_colour = function(self)
      ease_colour(G.C.DYN_UI.MAIN, mix_colours(G.C.SECONDARY_SET.Inverted, G.C.BLACK, 0.9))
      ease_background_colour{new_colour = G.C.SECONDARY_SET.Inverted, special_colour = darken(G.C.BLACK, 0.2), contrast = 2}
    end,
  }
end

local normal = { extra = 3, choose = 1 }
local jumbo = { extra = 5, choose = 1 }
local mega = { extra = 5, choose = 2 }

register('inverted_normal_1', { x = 0, y = 0 }, 'normal', 1, 4, 41, normal)
register('inverted_normal_2', { x = 1, y = 0 }, 'normal', 1, 4, 42, normal)
register('inverted_normal_3', { x = 2, y = 0 }, 'normal', 1, 4, 43, normal)
register('inverted_normal_4', { x = 3, y = 0 }, 'normal', 1, 4, 44, normal)
register('inverted_jumbo_1', { x = 0, y = 1 }, 'jumbo', 1, 6, 45, jumbo)
register('inverted_jumbo_2', { x = 1, y = 1 }, 'jumbo', 1, 6, 46, jumbo)
register('inverted_mega_1', { x = 2, y = 1 }, 'mega', 0.25, 8, 47, mega)
register('inverted_mega_2', { x = 3, y = 1 }, 'mega', 0.25, 8, 48, mega)
