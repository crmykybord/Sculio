SMODS.Joker {
  key = 'sensory_overload',
  loc_txt = {
    name = 'Sensory Overload',
    text = {
      'Earn {C:money}$#1#{} for every',
      '{C:attention}#2#{} {C:inactive}[#3#]{} times other',
      'Jokers are {C:attention}triggered{}'
    }
  },

  config = { extra = { money_gain = 1, triggers_per_gain = 5, triggers_since_gain = 0 } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 3, y = 3 },
  cost = 6,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.money_gain, card.ability.extra.triggers_per_gain, card.ability.extra.triggers_since_gain } }
  end,
  calculate = function(self, card, context)
    if context.post_trigger and context.other_card.ability and context.other_card.ability.name ~= 'j_Sculio_sensory_overload' and not context.blueprint then
      card.ability.extra.triggers_since_gain = card.ability.extra.triggers_since_gain + 1

      if card.ability.extra.triggers_since_gain >= card.ability.extra.triggers_per_gain then
        card.ability.extra.triggers_since_gain = card.ability.extra.triggers_since_gain - card.ability.extra.triggers_per_gain

        return {
          dollars = card.ability.extra.money_gain,
          card = card,
          message_card = card
        }
      end
    end
  end
}
