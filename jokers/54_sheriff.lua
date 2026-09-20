SMODS.Joker {
  key = 'sheriff',
  attributes = { 'xmult', 'scaling', 'boss_blind' },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = { Xmult_mod = 0.25 } },
  unlocked = true,
  discovered = false,
  rarity = 2,
  atlas = 'Sculio',
  pos = { x = 6, y = 5 },
  cost = 7,
  loc_vars = function(self, info_queue, card)
    local bosses = G.GAME.Sculio_bosses_beaten or 0
    return { vars = { card.ability.extra.Xmult_mod, 1 + card.ability.extra.Xmult_mod * bosses } }
  end,
  calculate = function(self, card, context)
    if context.end_of_round and context.main_eval and context.beat_boss
        and not context.game_over and not context.blueprint then
      return { message = localize('k_upgrade_ex'), colour = G.C.MULT }
    end

    if context.joker_main then
      local x_mult = 1 + card.ability.extra.Xmult_mod * (G.GAME.Sculio_bosses_beaten or 0)
      if x_mult > 1 then
        return { x_mult = x_mult, card = card }
      end
    end
  end
}
