SMODS.Joker {
  key = 'cartomante',
  attributes = { 'blind_select', 'consumable' },
  eternal_compat = true,
  blueprint_compat = true,
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
    if context.setting_blind then
      local pool = Sculio.inverted_pool()
      if #pool > 0 then
        local eff_card = context.blueprint_card or card
        local key = pseudorandom_element(pool, pseudoseed('cartomante'))
        Sculio.create_center_card(key, G.consumeables, 1, 'sculio_cartomante')
        return { extra = { message = localize('k_duplicated_ex'), focus = eff_card }, card = eff_card }
      end
    end
  end
}
