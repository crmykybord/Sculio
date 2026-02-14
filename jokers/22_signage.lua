SMODS.Joker {
  key = 'signage',
  loc_txt = {
    name = 'Signage',
    text = {
      'Only {C:attention}Jokers{} will',
      'appear in the shop'
    },
  },

  unlocked = true,
  discovered = false,
  rarity = 1, -- Common
  atlas = 'Sculio',
  pos = { x = 3, y = 2 },
  cost = 5,
  add_to_deck = function(self, card, from_debuff)
    G.GAME.tarot_rate = 0
    G.GAME.planet_rate = 0
    G.GAME.playing_card_rate = 0
    G.GAME.spectral_rate = 0
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.GAME.tarot_rate = 4
    G.GAME.planet_rate = 4

    -- Restore Spectral Cards for Ghost Deck.
    G.GAME.spectral_rate = G.GAME.selected_back.effect.config.spectral_rate

    local shopping_card_frequency_voucher_names = {
      'tarot_merchant',
      'tarot_tycoon',
      'planet_merchant',
      'planet_tycoon',
      'magic_trick',
      'illusion',
    }

    for i = 1, #shopping_card_frequency_voucher_names do
      local voucher_name = shopping_card_frequency_voucher_names[i]
      local voucher_key = 'v_' .. voucher_name

      if G.GAME.used_vouchers[voucher_key] then
        Card.apply_to_run(nil, G.P_CENTERS[voucher_key])
      end
    end
  end,
  calculate = function(self, card, context)
    if context.buying_card and not context.blueprint then
      -- Override Voucher effects.
      G.E_MANAGER:add_event(Event({
        delay = 2.0,
        func = function()
          G.GAME.tarot_rate = 0
          G.GAME.planet_rate = 0
          G.GAME.playing_card_rate = 0

          return true
        end
      }))
    end
  end
}
