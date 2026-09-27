SMODS.Joker {
  key = 'getaway_card',
  attributes = { 'on_sell' },
  eternal_compat = false,
  blueprint_compat = false,
  perishable_compat = false,
  rental_compat = true,
  config = {},
  unlocked = true,
  discovered = false,
  rarity = 3, -- Rare
  atlas = 'Sculio',
  pos = { x = 8, y = 7 },
  cost = 10,
  calculate = function(self, card, context)
    if context.selling_self and not context.blueprint then
      if G.STATE == G.STATES.SELECTING_HAND and G.GAME.blind and G.GAME.blind.chips then
        G.GAME.chips = G.GAME.blind.chips
        G.E_MANAGER:add_event(Event({
          trigger = 'immediate',
          func = function()
            if G.STATE ~= G.STATES.NEW_ROUND and G.GAME.chips - G.GAME.blind.chips >= 0 then
              G.STATE = G.STATES.NEW_ROUND
              G.STATE_COMPLETE = false
            end
            return true
          end
        }))
        return { message = localize('k_Sculio_getaway_win'), colour = G.C.MONEY, card = card }
      end
    end
  end,
}
