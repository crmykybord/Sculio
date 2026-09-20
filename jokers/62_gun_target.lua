SMODS.Joker {
  key = 'gun_target',
  attributes = { 'economy' },
  eternal_compat = true,
  blueprint_compat = false,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = { dollars = 12 } },
  unlocked = true,
  discovered = false,
  rarity = 1, -- Common
  atlas = 'Sculio',
  pos = { x = 4, y = 6 },
  cost = 4,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.dollars } }
  end,
  calc_dollar_bonus = function(self, card)
    if G.GAME.blind and G.GAME.blind:get_type() == 'Small' then
      return card.ability.extra.dollars
    end
  end,
}
