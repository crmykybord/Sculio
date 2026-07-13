SMODS.Joker {
  key = 'sheriff',
  attributes = { 'xmult', 'scaling', 'boss_blind' },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  config = {
    extra = {
      Xmult_mod = 0.25,
      x_mult = 1
    }
  },
  unlocked = true,
  discovered = false,
  rarity = 2,
  atlas = 'Sculio',
  pos = { x = 6, y = 5 },
  cost = 6,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.Xmult_mod, card.ability.extra.x_mult } }
  end,
  calculate = function(self, card, context)
    if context.end_of_round and context.main_eval and not context.blueprint then
      if G.GAME.blind.boss then
        SMODS.scale_card(card, {
          ref_table = card.ability.extra,
          ref_value = 'x_mult',
          scalar_value = 'Xmult_mod',
          message_colour = G.C.MULT
        })
      end
    end

    if context.joker_main and card.ability.extra.x_mult > 1 then
      return { x_mult = card.ability.extra.x_mult, card = card }
    end
  end
}
