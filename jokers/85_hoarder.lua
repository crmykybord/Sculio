SMODS.Joker {
  key = 'hoarder',
  attributes = { 'shop', 'consumables', 'tarot', 'money' },
  eternal_compat = true,
  blueprint_compat = false,
  perishable_compat = false,
  rental_compat = true,
  config = { extra = { spent = false } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 7, y = 8 },
  cost = 6,
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.c_hermit
    return { vars = {} }
  end,
  calculate = function(self, card, context)
    if context.blueprint then return end

    if context.starting_shop then
      card.ability.extra.spent = false
    end

    if context.money_altered and context.amount and context.amount < 0 then
      card.ability.extra.spent = true
    end

    if context.ending_shop and not card.ability.extra.spent and G.P_CENTERS.c_hermit
        and G.consumeables.config.card_limit > #G.consumeables.cards then
      card.ability.extra.spent = true
      Sculio.create_center_card('c_hermit', G.consumeables, 1, 'sculio_hoarder')
      G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
          card_eval_status_text(card, 'extra', nil, nil, nil,
            { message = localize('k_Sculio_plus_hermit'), colour = G.C.SECONDARY_SET.Tarot })
          return true
        end
      }))
    end
  end,
}