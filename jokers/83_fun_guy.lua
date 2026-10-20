-- Fun Guy: when a playing card is destroyed, two random cards in your hand
-- become its rank ("categoría" = Rank, see TRANSLATION_RULES). It runs on the
-- vanilla remove_playing_cards dispatch, which fires once per batch with
-- context.removed, so each destroyed card gets its own pair of picks.
-- blueprint_compat = false: the picks mutate cards, a copy would reroll and
-- change extra cards (same rule as Scrawlings/Welcome Mat).
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
  cost = 6,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.cards } }
  end,
  calculate = function(self, card, context)
    if context.remove_playing_cards and context.removed then
      local changed = 0
      for _, dead in ipairs(context.removed) do
        -- Stone and friends have no rank to give away.
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
