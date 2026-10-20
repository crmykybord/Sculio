-- Red Dacca: +40 Mult, with a 1 in 11 chance to consume itself at the end of
-- the round. This is the vanilla Gros Michel flow (a banana for a banana): the
-- roll goes through SMODS.pseudorandom_probability so probability modifiers
-- count, and it pays the k_extinct_ex / k_safe_ex messages.
-- eternal_compat = false because it can consume itself.
SMODS.Joker {
  key = 'red_dacca',
  attributes = { 'mult', 'chance' },
  eternal_compat = false,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = { mult = 40, odds = 11 } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 4, y = 9 },
  cost = 6,
  loc_vars = function(self, info_queue, card)
    local n, d = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'red_dacca')
    return { vars = { card.ability.extra.mult, n, d } }
  end,
  calculate = function(self, card, context)
    if context.joker_main then
      return { mult = card.ability.extra.mult }
    end

    if context.end_of_round and context.main_eval and not context.blueprint then
      if SMODS.pseudorandom_probability(card, 'red_dacca', 1, card.ability.extra.odds, 'red_dacca') then
        Sculio.destroy_joker(card)
        return { message = localize('k_extinct_ex'), colour = G.C.MULT }
      else
        return { message = localize('k_safe_ex') }
      end
    end
  end
}
