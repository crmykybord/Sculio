local function pick_random_hand()
  local hands = {}
  for k in pairs(G.GAME.hands) do
    table.insert(hands, k)
  end
  return hands[pseudorandom('joker_metro_hand', 1, #hands)]
end

SMODS.Joker {
  key = 'joker_metro',
  attributes = { 'mult', 'hand_type', 'scaling' },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = false,
  rental_compat = true,
  config = { extra = { mult = 0, gain = 2, gain_increase = 2, current_hand = 'High Card' } },
  unlocked = true,
  discovered = false,
  rarity = 2,
  atlas = 'Sculio',
  pos = { x = 0, y = 5 },
  cost = 7,
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.mult,
        card.ability.extra.gain,
        localize(card.ability.extra.current_hand, 'poker_hands'),
        card.ability.extra.gain_increase,
      },
    }
  end,
  calculate = function(self, card, context)
    if context.end_of_round and context.main_eval and not context.blueprint then
      card.ability.extra.current_hand = pick_random_hand()
    end

    if context.blind_defeated and not context.blueprint and G.GAME.blind.boss then
      card.ability.extra.gain = card.ability.extra.gain + card.ability.extra.gain_increase
      return { message = localize('k_upgrade_ex'), colour = G.C.MULT }
    end

    if context.before and not context.blueprint and context.scoring_name == card.ability.extra.current_hand then
      card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.gain
      return { message = localize('k_upgrade_ex'), colour = G.C.MULT }
    end

    if context.joker_main and card.ability.extra.mult > 0 then
      return { mult = card.ability.extra.mult }
    end
  end
}
