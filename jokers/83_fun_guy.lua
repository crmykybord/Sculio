SMODS.Joker {
  key = 'fun_guy',
  attributes = { 'rank' },
  eternal_compat = true,
  blueprint_compat = false,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = { cards = 2 } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 5, y = 8 },
  pixel_size = { w = 69, h = 89 },
  cost = 6,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.cards } }
  end,
  calculate = function(self, card, context)
    if context.remove_playing_cards and context.removed then
      local changed = 0
      for _, dead in ipairs(context.removed) do
        -- Stone and friends have no rank
        if dead.playing_card and not SMODS.has_no_rank(dead) then
          local rank = dead.base.value
          local pool = {}
          for _, target in ipairs(G.hand.cards) do
            if target.playing_card and not SMODS.has_no_rank(target)
                and target.base.value ~= rank then
              pool[#pool + 1] = target
            end
          end
          for _ = 1, card.ability.extra.cards do
            if #pool == 0 then break end
            local target = table.remove(pool, math.floor(pseudoseed('Sculio_fun_guy') * #pool) + 1)
            assert(SMODS.change_base(target, nil, rank))
            changed = changed + 1
          end
        end
      end
      if changed > 0 then
        return { message = localize('k_upgrade_ex'), colour = G.C.CHIPS }
      end
    end
  end
}
