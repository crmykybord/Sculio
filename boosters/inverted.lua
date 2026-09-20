local function inverted_card(self, card, i)
  if not G.GAME.banned_keys['c_soul']
      and not (G.GAME.used_jokers['c_soul'] and not next(find_joker('Showman')))
      and pseudorandom('soul_Inverted' .. G.GAME.round_resets.ante .. (i or '')) > 0.997 then
    return { set = 'Spectral', key = 'c_soul', area = G.pack_cards, skip_materialize = true, key_append = 'inv_soul' }
  end
  return { set = 'Inverted', area = G.pack_cards, skip_materialize = true, key_append = 'inv' }
end

local function pack_loc_vars(self, info_queue, card)
  local cfg = self.config
  local size = math.max(1, (cfg.extra or 0) + ((G.GAME and G.GAME.modifiers and G.GAME.modifiers.booster_size_mod) or 0))
  local choices = math.min((cfg.choose or 1) + ((G.GAME and G.GAME.modifiers and G.GAME.modifiers.booster_choice_mod) or 0), size)
  return { vars = { choices, size }, key = self.key:gsub('_%d$', '') }
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
    Sculio_base_extra = config.extra,
    Sculio_base_choose = config.choose,
    attributes = { size },
    loc_vars = pack_loc_vars,
    create_card = inverted_card,
    ease_background_colour = function(self)
      ease_colour(G.C.DYN_UI.MAIN, mix_colours(G.C.SECONDARY_SET.Inverted, G.C.BLACK, 0.9))
      ease_background_colour{new_colour = G.C.SECONDARY_SET.Inverted, special_colour = darken(G.C.BLACK, 0.2), contrast = 2}
    end,
  }
end

register('inverted_normal_1', { x = 0, y = 0 }, 'normal', 1, 4, 41, { extra = 3, choose = 1 })
register('inverted_normal_2', { x = 1, y = 0 }, 'normal', 1, 4, 42, { extra = 3, choose = 1 })
register('inverted_normal_3', { x = 2, y = 0 }, 'normal', 1, 4, 43, { extra = 3, choose = 1 })
register('inverted_normal_4', { x = 3, y = 0 }, 'normal', 1, 4, 44, { extra = 3, choose = 1 })
register('inverted_jumbo_1', { x = 0, y = 1 }, 'jumbo', 1, 6, 45, { extra = 5, choose = 1 })
register('inverted_jumbo_2', { x = 1, y = 1 }, 'jumbo', 1, 6, 46, { extra = 5, choose = 1 })
register('inverted_mega_1', { x = 2, y = 1 }, 'mega', 0.25, 8, 47, { extra = 5, choose = 2 })
register('inverted_mega_2', { x = 3, y = 1 }, 'mega', 0.25, 8, 48, { extra = 5, choose = 2 })
