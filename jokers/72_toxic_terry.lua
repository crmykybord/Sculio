SMODS.Joker {
  key = 'toxic_terry',
  attributes = { 'economy', 'modify_card', 'enhancements' },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = { dollars = 6 } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 4, y = 7 },
  cost = 6,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.dollars } }
  end,
  calculate = function(self, card, context)
    if context.before and context.cardarea == G.jokers and not context.blueprint then
      local removed = 0
      for _, v in ipairs(context.full_hand or {}) do
        if v.config.center ~= G.P_CENTERS.c_base and not v.debuff then
          v:set_ability(G.P_CENTERS.c_base, nil, true)
          removed = removed + 1
          G.E_MANAGER:add_event(Event({
            func = function()
              v:juice_up()
              return true
            end
          }))
        end
      end
      if removed > 0 then
        local dollars = card.ability.extra.dollars * removed
        return {
          message = localize('$') .. dollars,
          dollars = dollars,
          colour = G.C.MONEY,
          card = card,
        }
      end
    end
  end,
}
