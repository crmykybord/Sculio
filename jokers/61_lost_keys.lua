SMODS.Joker {
  key = 'lost_keys',
  attributes = { 'boss_blind', 'booster' },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = { boosters_given = 0 } },
  unlocked = true,
  discovered = false,
  rarity = 3,
  atlas = 'Sculio',
  pos = { x = 3, y = 6 },
  cost = 7,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.boosters_given } }
  end,
  calculate = function(self, card, context)
    if context.blind_defeated and not context.blueprint then
      G.E_MANAGER:add_event(Event({
        func = function()
          card.ability.extra.boosters_given = card.ability.extra.boosters_given + 2
          for i = 1, 2 do
            local booster = SMODS.create_card({
              set = 'Booster',
              skip_choose = true,
              select = false
            })
            booster.cost = 0
            booster.free = true
            G.shop:emplace(booster)
          end
          return true
        end
      }))
    end
  end
}
