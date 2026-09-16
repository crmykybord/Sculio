SMODS.Seal {
  key = 'inverted',
  atlas = 'Sculio_Enhancements',
  pos = { x = 2, y = 0 },
  badge_colour = HEX 'B14AB8',
  config = {},
  calculate = function(self, card, context)
    -- Mirror of the vanilla Purple Seal, but creates an Inverted Tarot
    if context.discard and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
      G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
      G.E_MANAGER:add_event(Event({
        trigger = 'before',
        delay = 0.0,
        func = (function()
          local new_card = create_card('Inverted', G.consumeables, nil, nil, nil, nil, nil, 'sculio_inv_seal')
          new_card:add_to_deck()
          G.consumeables:emplace(new_card)
          G.GAME.consumeable_buffer = 0
          return true
        end)
      }))
      card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize('k_Sculio_plus_inverted'), colour = G.C.SET.Inverted })
    end
  end,
}
