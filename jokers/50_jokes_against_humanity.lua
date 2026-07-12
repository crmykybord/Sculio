SMODS.Joker {
  key = 'jokes_against_humanity',
  attributes = { 'xmult', "chance", "joker" },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = { x_mult = 4, debuffed_jokers = {} } },
  unlocked = true,
  discovered = false,
  rarity = 3,
  atlas = 'Sculio',
  pos = { x = 2, y = 5 },
  cost = 10,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.x_mult } }
  end,
  add_to_deck = function(self, card, from_debuff)
    card.ability.extra.debuffed_jokers = card.ability.extra.debuffed_jokers or {}
  end,
  remove_from_deck = function(self, card, from_debuff)
    Sculio.undebuff_list(card.ability.extra.debuffed_jokers)
    card.ability.extra.debuffed_jokers = {}
  end,
  calculate = function(self, card, context)
    if context.before and not context.blueprint then
      Sculio.undebuff_list(card.ability.extra.debuffed_jokers)
      card.ability.extra.debuffed_jokers = {}

      local available_jokers = {}
      for _, j in ipairs(G.jokers.cards) do
        local is_jokes_against_humanity = j.config and j.config.center and j.config.center.key == 'j_Sculio_jokes_against_humanity'
        if j ~= card and not is_jokes_against_humanity then
          table.insert(available_jokers, j)
        end
      end

      if #available_jokers > 0 then
        local shuffled = {}
        for _, j in ipairs(available_jokers) do
          table.insert(shuffled, j)
        end
        for i = #shuffled, 2, -1 do
          local j_idx = pseudorandom('jokes_against_humanity_shuffle', 1, i)
          shuffled[i], shuffled[j_idx] = shuffled[j_idx], shuffled[i]
        end

        local to_debuff = math.min(2, #shuffled)
        for i = 1, to_debuff do
          if SMODS.pseudorandom_probability(card, 'jokes_against_humanity', 1, 4) then
            shuffled[i]:set_debuff(true)
            table.insert(card.ability.extra.debuffed_jokers, shuffled[i])
          end
        end
      end
    end

    if context.final_scoring_step and not context.blueprint then
      Sculio.undebuff_list(card.ability.extra.debuffed_jokers)
      card.ability.extra.debuffed_jokers = {}
    end

    if context.joker_main then
      return { xmult = card.ability.extra.x_mult, message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult } } }
    end
  end
}
