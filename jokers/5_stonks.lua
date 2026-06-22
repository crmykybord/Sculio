SMODS.Joker {
  key = 'stonks',
  attributes = { 'mult', 'boss_blind', 'scaling' },

  config = { extra = { mult = 2 } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 4, y = 0 },
  cost = 7,
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = false,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.mult } }
  end,
  calculate = function(self, card, context)
    if context.joker_main then
      return { mult = card.ability.extra.mult, message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } } }
    end

    if context.end_of_round and context.main_eval and not context.game_over and not context.blueprint and G.GAME.blind.boss then
      card.ability.extra.mult = card.ability.extra.mult * 2
      return { message = localize('k_upgrade_ex') }
    end
  end
}
