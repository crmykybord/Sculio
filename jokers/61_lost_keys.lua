SMODS.Joker {
  key = 'lost_keys',
  attributes = { 'booster', 'passive' },
  eternal_compat = true,
  blueprint_compat = false,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = { boosters = 2 } },
  unlocked = true,
  discovered = false,
  rarity = 3,
  atlas = 'Sculio',
  pos = { x = 3, y = 6 },
  cost = 7,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.boosters } }
  end,
  calculate = function(self, card, context)
    if context.starting_shop and not context.blueprint then
      G.E_MANAGER:add_event(Event({
        func = function()
          for _ = 1, card.ability.extra.boosters do
            local booster = SMODS.add_booster_to_shop()
            if booster then
              -- Vanilla's "free booster" mechanism (used by The Cloth, coupons,
              -- Paperback's Celtic Cross). Much cleaner than brute-forcing the cost.
              booster.ability.couponed = true
              if type(booster.set_cost) == 'function' then
                booster:set_cost()
              end
            end
          end
          return true
        end
      }))
    end
  end
}
