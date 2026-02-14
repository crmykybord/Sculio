SMODS.Joker {
  key = 'crime_scene',

  config = { extra = { mult = 0 } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 1, y = 1 },
  cost = 7,
  blueprint_compat = true,
  perishable_compat = false,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.mult } }
  end,
  calculate = function(self, card, context)
    if context.first_hand_drawn and not context.blueprint then
      local eval = function() return G.GAME.current_round.hands_played == 0 end
      juice_card_until(card, eval, true)
    end

    if context.before and G.GAME.current_round.hands_played == 0 and not context.blueprint then
      if #context.full_hand == 1 then
        local base_chips = context.full_hand[1]:get_id()

        if base_chips > 10 then
          if base_chips == 14 then
            base_chips = 11
          else
            base_chips = 10
          end
        end

        card.ability.extra.mult = card.ability.extra.mult + (base_chips / 2)

        return { message = localize('k_upgrade_ex') }
      end
    end

    if context.joker_main and card.ability.extra.mult > 0 then
      return {
        mult_mod = card.ability.extra.mult,
        message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
      }
    end
  end
}
