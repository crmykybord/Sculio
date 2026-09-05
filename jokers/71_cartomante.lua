SMODS.Joker {
  key = 'cartomante',
  attributes = { 'blind_select', 'consumable' },
  eternal_compat = true,
  blueprint_compat = false,
  perishable_compat = true,
  rental_compat = true,
  config = {},
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 2, y = 7 },
  cost = 5,
  calculate = function(self, card, context)
    if context.setting_blind and not context.blueprint then
      local pool = Sculio.inverted_pool()
      if #pool > 0 then
        local key = pseudorandom_element(pool, pseudoseed('cartomante'))
        Sculio.create_center_card(key, G.consumeables, 1, 'sculio_cartomante')
        return {
          extra = { message = localize('k_duplicated_ex'), focus = card },
          card = card
        }
      end
    end
  end
}
