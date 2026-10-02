SMODS.Joker {
  key = 'mouse_art',
  attributes = { 'discard', 'enhancements', 'hand_type' },
  eternal_compat = true,
  blueprint_compat = false,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = { done = false } },
  unlocked = true,
  discovered = false,
  rarity = 1, -- Common
  atlas = 'Sculio',
  pos = { x = 1, y = 9 },
  cost = 4,
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.m_wild
    return { vars = {} }
  end,
  calculate = function(self, card, context)
    if context.blueprint then return end

    if context.setting_blind then
      card.ability.extra.done = false
      return
    end
    if context.discard and not card.ability.extra.done and context.other_card
        and not context.other_card.debuff and G.P_CENTERS.m_wild then
      card.ability.extra.done = true
      local c = context.other_card
      c:set_ability(G.P_CENTERS.m_wild, false)
      c:juice_up(0.3, 0.5)
      play_sound('card1', 1, 0.6)
      G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
          card_eval_status_text(card, 'extra', nil, nil, nil,
            { message = localize('k_Sculio_plus_wild'), colour = G.C.FILTER })
          return true
        end
      }))
    end
  end,
}