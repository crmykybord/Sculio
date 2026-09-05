SMODS.Joker {
  key = 'gun_target',
  attributes = { 'economy' },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = { dollars = 10 } },
  unlocked = true,
  discovered = false,
  rarity = 1, -- Common
  atlas = 'Sculio',
  pos = { x = 4, y = 6 },
  cost = 4,
  loc_vars = function(self, info_queue, card)
    return { vars = {} }
  end,
  calculate = function(self, card, context)
    if context.end_of_round and context.main_eval and not context.game_over and not context.blueprint then
      if G.GAME.blind and G.GAME.blind:get_type() == 'Small' then
        return { dollars = card.ability.extra.dollars, card = card }
      end
    end
  end
}
