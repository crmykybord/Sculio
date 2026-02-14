SMODS.Joker {
  key = 'sticky_keys',

  config = { extra = { mult = 0, hands_until_change = 3, hands_elapsed = 0 } },
  unlocked = true,
  discovered = false,
  rarity = 1, -- Common
  atlas = 'Sculio',
  pos = { x = 2, y = 2 },
  cost = 3,
  blueprint_compat = true,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.mult, card.ability.extra.hands_until_change, card.ability.extra.hands_until_change - card.ability.extra.hands_elapsed } }
  end,
  calculate = function(self, card, context)
    if context.joker_main and card.ability.extra.mult > 0 then
      return {
        mult_mod = card.ability.extra.mult,
        message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
      }
    end

    if context.after and not context.blueprint then
      card.ability.extra.hands_elapsed = card.ability.extra.hands_elapsed + 1

      if card.ability.extra.hands_elapsed >= card.ability.extra.hands_until_change then
        local base_chips = context.full_hand[1].base.id

        if base_chips > 10 then
          if base_chips == 14 then
            base_chips = 11
          else
            base_chips = 10
          end
        end

        card.ability.extra.mult = base_chips
        card.ability.extra.hands_elapsed = 0

        return {
          message = 'Mult Changed!'
        }
      end
    end
  end
}
