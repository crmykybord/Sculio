SMODS.Joker {
  key = 'sensory_overload',
  attributes = { 'economy' },

  config = { extra = { money_gain = 1, triggers_per_gain = 5, triggers_since_gain = 0 } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 3, y = 3 },
  cost = 6,
  blueprint_compat = true,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.money_gain, card.ability.extra.triggers_per_gain, card.ability.extra.triggers_since_gain } }
  end,
  calculate = function(self, card, context)
    if context.post_trigger then
      local trigger_card = context.other_card

      -- Don't count triggers caused by Sensory Overload itself (avoid infinite loop)
      if not trigger_card or trigger_card == card then return end
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
