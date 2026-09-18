SMODS.Joker {
  key = 'handheld',
  attributes = { 'modify_card', 'enhancements' },
  unlocked = true,
  discovered = false,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  rental_compat = true,
  rarity = 3, -- Rare
  atlas = 'Sculio',
  pos = { x = 0, y = 1 },
  cost = 6,
  loc_vars = function(self, info_queue, card)
    local last = G.GAME.Sculio_last_enhancement
    local name = localize('k_none')
    if last and G.P_CENTERS[last] then
      name = localize { type = 'name_text', key = G.P_CENTERS[last].key, set = G.P_CENTERS[last].set }
    end
    return { vars = { name } }
  end,
  calculate = function(self, card, context)
    if context.before and not context.blueprint and G.GAME.Sculio_last_enhancement then
      local first = context.scoring_hand and context.scoring_hand[1]
      if first and not first.debuff and first.config.center_key == 'c_base' then
        Sculio.flip_highlighted(card, { first }, function()
          if not first.REMOVED then
            first:set_ability(G.P_CENTERS[G.GAME.Sculio_last_enhancement], false)
          end
        end)
      end
    end
  end
}
