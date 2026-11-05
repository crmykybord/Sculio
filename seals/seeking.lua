SMODS.Seal {
  key = 'seeking',
  atlas = 'Sculio_Enhancements',
  pos = { x = 2, y = 1 },
  badge_colour = HEX '78E1AA',
  config = {},
  calculate = function(self, card, context)
    if context.discard and context.other_card == card then
      local count = 0
      if G.hand and G.hand.highlighted then
        for _, c in ipairs(G.hand.highlighted) do
          if c.seal == 'Sculio_seeking' then count = count + 1 end
        end
      end
      if count < 1 then return end

      Sculio.seeking_gen = (Sculio.seeking_gen or 0) + 1
      local my_gen = Sculio.seeking_gen
      G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.0, func = function()
        if Sculio.seeking_gen ~= my_gen then return true end
        if G.OVERLAY_MENU then return true end
        if not G.hand or not G.deck or #G.deck.cards <= 0 then return true end
        Sculio.open_deck_picker(math.min(count, #G.deck.cards))
        return true
      end }))
    end
  end,
}
