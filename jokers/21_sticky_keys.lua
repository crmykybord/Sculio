SMODS.Joker {
  key = 'sticky_keys',
  attributes = { 'mult', 'rank' },
  config = { extra = { mult = 0, last_ante = nil, last_shake_ante = nil } },
  unlocked = true,
  discovered = false,
  rarity = 1, -- Common
  atlas = 'Sculio',
  pos = { x = 2, y = 2 },
  cost = 2,
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.mult } }
  end,
  calculate = function(self, card, context)
    if context.setting_blind and not context.blueprint and G.GAME then
      local current_ante = (G.GAME.round_resets and G.GAME.round_resets.ante) or 0
      if card.ability.extra.last_shake_ante ~= current_ante then
        card.ability.extra.last_shake_ante = current_ante
        card:juice_up(0.3, 0.3)
      end
    end

    if context.blind_defeated and not context.blueprint and G.GAME and G.GAME.blind and G.GAME.blind.boss then
      card.ability.extra.mult = 0
      return { message = localize('k_reset'), colour = G.C.MULT }
    end

    if context.before and not context.blueprint and context.full_hand and #context.full_hand > 0 and G.GAME then
      local current_ante = (G.GAME.round_resets and G.GAME.round_resets.ante) or 0
      if card.ability.extra.last_ante ~= current_ante then
        card.ability.extra.last_ante = current_ante

        local base_chips = context.full_hand[1].base and context.full_hand[1].base.id
        if not base_chips or base_chips < 2 then base_chips = 10 end

        if base_chips > 10 then
          if base_chips == 14 then
            base_chips = 11
          else
            base_chips = 10
          end
        end
        card.ability.extra.mult = base_chips * 2
        return { message = localize('k_Sculio_sticky_keys_changed') }
      end
    end

    if context.joker_main and card.ability.extra.mult > 0 then
      return { mult = card.ability.extra.mult }
    end
  end
}
