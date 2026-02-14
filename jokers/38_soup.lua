SMODS.Joker {
  key = 'soup',
  loc_txt = {
    name = 'Soup Can',
    text = {
      'This Joker gains {X:mult,C:white}X#2#{} Mult',
      'for {C:attention}every hand played{}.',
      '{C:attention}Maximum{} is {X:mult,C:white}X#3#{} Mult',
      '{C:inactive}(Currently {X:mult,C:white}X#1#{}{C:inactive} Mult)',
    }
  },

  config = { extra = { x_mult = 1.0, x_mult_gain = 0.03, x_mult_max = 2 } },
  unlocked = true,
  discovered = false,
  rarity = 1, -- Common
  atlas = 'Sculio',
  pos = { x = 9, y = 3 },
  cost = 4,
  blueprint_compat = true,
  perishable_compat = false,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.x_mult, card.ability.extra.x_mult_gain, card.ability.extra.x_mult_max } }
  end,
  calculate = function(self, card, context)
    if context.before and not context.blueprint then
      card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_gain

      if card.ability.extra.x_mult > card.ability.extra.x_mult_max then
        card.ability.extra.x_mult = card.ability.extra.x_mult_max
      end
    end

    if context.joker_main and card.ability.extra.x_mult > 1 then
      return {
        Xmult_mod = card.ability.extra.x_mult,
        message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult } }
      }
    end
  end
}
