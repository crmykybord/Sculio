SMODS.Joker {
  key = 'eerie_statue',
  attributes = { 'chance', 'tarot', 'generation' },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = { odds = 4 } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 5, y = 7 },
  cost = 5,
  loc_vars = function(self, info_queue, card)
    return { vars = { 1, card.ability.extra.odds } }
  end,
  calculate = function(self, card, context)
    if context.using_consumeable and context.consumeable
        and context.consumeable.ability.set == 'Tarot'
        and pseudorandom('sculio_eerie_statue') < 1 / card.ability.extra.odds then
      local counterpart = Sculio.inverted_counterpart(context.consumeable.config.center_key)
      if counterpart and G.consumeables.config.card_limit > #G.consumeables.cards then
        local eff_card = context.blueprint_card or card
        Sculio.create_center_card(counterpart, G.consumeables, 1, 'sculio_eerie_statue')
        return { extra = { message = localize('k_Sculio_plus_inverted'), focus = eff_card }, colour = G.C.SECONDARY_SET.Inverted, card = eff_card }
      end
    end
  end,
}
