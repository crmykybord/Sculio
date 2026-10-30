SMODS.Joker {
  key = 'cash',
  attributes = { 'economy' },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = { money_recover = 3, used_this_round = false } },
  unlocked = true,
  discovered = false,
  rarity = 1, -- Common
  atlas = 'Sculio',
  pos = { x = 7, y = 4 },
  pixel_size = { w = 65, h = 89 },
  cost = 4,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.money_recover } }
  end,
  calculate = function(self, card, context)
    local eff_card = context.blueprint_card or card
    if (context.buying_card or context.buying_voucher or context.open_booster) and context.card ~= card then
      if not (eff_card.ability.extra.used_this_round) then
        if not context.blueprint then
          eff_card.ability.extra.used_this_round = true
        end

        local cost = context.card and context.card.cost or 0
        local amount = math.min(cost, eff_card.ability.extra.money_recover)

        if amount > 0 then
          G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
              ease_dollars(amount)
              card_eval_status_text(eff_card, 'extra', nil, nil, nil, {
                message = '+$' .. amount,
                colour = G.C.GOLD,
                delay = 0.45
              })
              return true
            end
          }))
        end
      end
    end

    if context.end_of_round and context.main_eval and not context.game_over then
      eff_card.ability.extra.used_this_round = false
    end
  end
}
