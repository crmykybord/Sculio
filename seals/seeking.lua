SMODS.Seal {
  key = 'seeking',
  atlas = 'Sculio_Enhancements',
  pos = { x = 2, y = 1 },
  badge_colour = HEX '78E1AA',
  config = {},
  calculate = function(self, card, context)
    if context.discard and context.other_card == card then
      if G.deck and #G.deck.cards > 0 and G.hand then
        G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.3, func = function()
          if G.OVERLAY_MENU or card.REMOVED then return true end
          local room = G.hand.config.card_limit - #G.hand.cards + (card.area == G.hand and 1 or 0)
          if room >= 1 and #G.deck.cards > 0 then
            Sculio.open_deck_picker()
          end
          return true
        end }))
      end
    end
  end,
}
