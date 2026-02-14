SMODS.Joker {
  key = 'stonks',

  config = { extra = { mult = 2 } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 4, y = 0 },
  cost = 7,
  blueprint_compat = true,
  perishable_compat = false,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.mult } }
  end,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        mult_mod = card.ability.extra.mult,
        message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
      }
    end

    if context.end_of_round and not context.repetition and context.game_over == false and not context.blueprint and G.GAME.blind.boss then
      card.ability.extra.mult = card.ability.extra.mult * 2
      return { message = localize('k_upgrade_ex') }
    end
  end
}
