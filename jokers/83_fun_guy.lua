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
      local changed_cards = {}
      local current_ranks = {}
      for _, dead in ipairs(context.removed) do
        -- Stone and friends have no rank
        if dead.playing_card and not SMODS.has_no_rank(dead) then
          local rank = dead.base.value
          local pool = {}
          if G.hand and G.hand.cards then
            for _, target in ipairs(G.hand.cards) do
              if target.playing_card and not SMODS.has_no_rank(target) then
                local target_rank = current_ranks[target] or target.base.value
                if target_rank ~= rank then
                  pool[#pool + 1] = target
                end
              end
            end
          end
          for _ = 1, card.ability.extra.cards do
            if #pool == 0 then break end
            local target = table.remove(pool, math.floor(pseudoseed('Sculio_fun_guy') * #pool) + 1)
            current_ranks[target] = rank
            changed_cards[#changed_cards + 1] = { target, rank }
            changed = changed + 1
          end
        end
      end
      if changed > 0 then
        for _, change in ipairs(changed_cards) do
          local target, rank = change[1], change[2]
          G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.4, func = function()
            if not target.REMOVED then
              target:flip()
              play_sound('card1', 1, 0.6)
            end
            return true
          end }))
          G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.15, func = function()
            if not target.REMOVED then
              assert(SMODS.change_base(target, nil, rank, true))
              target:set_sprites(nil, target.config.card)
            end
            return true
          end }))
          G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.15, func = function()
            if not target.REMOVED then
              target:flip()
              play_sound('tarot2', 1, 0.6)
              target:juice_up(0.3, 0.5)
            end
            return true
          end }))
        end
        return { message = localize('k_upgrade_ex'), colour = G.C.CHIPS }
      end
    end
  end
}
