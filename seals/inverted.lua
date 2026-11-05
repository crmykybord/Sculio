SMODS.Seal {
  key = 'inverted',
  atlas = 'Sculio_Enhancements',
  pos = { x = 2, y = 0 },
  badge_colour = HEX 'A84C45',
  config = {},
  calculate = function(self, card, context)
    -- Mirror of the vanilla Purple Seal, but for Inverted Tarots (a single one)
    if context.discard and context.other_card == card then
      local room = 0
      if G.consumeables and G.consumeables.config then
        room = G.consumeables.config.card_limit - (#G.consumeables.cards + (G.GAME.consumeable_buffer or 0))
      end
      local copies = math.min(1, room)
      if copies > 0 then
        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + copies
        G.E_MANAGER:add_event(Event({
          trigger = 'before',
          delay = 0.0,
          func = (function()
            for i = 1, copies do
              local new_card = SMODS.create_card({ set = 'inverted_tarot_sculio', area = G.consumeables, key_append = 'sculio_inv_seal' .. i })
              new_card:add_to_deck()
              G.consumeables:emplace(new_card)
            end
            G.GAME.consumeable_buffer = 0
            return true
          end)
        }))
        local msg = copies == 1 and localize('k_Sculio_plus_inverted') or ('+' .. copies .. ' ' .. localize('b_inverted_tarot_sculio_cards'))
        card_eval_status_text(card, 'extra', nil, nil, nil, { message = msg, colour = G.C.SET.inverted_tarot_sculio })
      end
    end
  end,
}
