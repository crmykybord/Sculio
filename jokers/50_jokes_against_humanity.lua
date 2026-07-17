local function pick_two_distinct(list)
  local n = #list
  if n == 0 then return nil, nil end
  if n == 1 then return list[1], nil end
  local a = pseudorandom('jokes_against_humanity_pick_a', 1, n)
  local b = pseudorandom('jokes_against_humanity_pick_b', 1, n - 1)
  if b >= a then b = b + 1 end
  return list[a], list[b]
end

SMODS.Joker {
  key = 'jokes_against_humanity',
  attributes = { 'xmult', 'chance', 'joker' },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = { x_mult = 4, odds = 4, debuffed_jokers = {} } },
  unlocked = true,
  discovered = false,
  rarity = 3,
  atlas = 'Sculio',
  pos = { x = 2, y = 5 },
  cost = 10,
  loc_vars = function(self, info_queue, card)
    local n, d = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'jokes_against_humanity')
    return { vars = { card.ability.extra.x_mult, n, d } }
  end,
  remove_from_deck = function(self, card, from_debuff)
    Sculio.undebuff_list(card.ability.extra.debuffed_jokers)
    card.ability.extra.debuffed_jokers = {}
    card.ability.extra.picked_a = nil
    card.ability.extra.picked_b = nil
  end,
  calculate = function(self, card, context)
    if context.before then
      Sculio.undebuff_list(card.ability.extra.debuffed_jokers)
      card.ability.extra.debuffed_jokers = {}

      -- kill old shake loops before picking new targets
      card.ability.extra.picked_a = nil
      card.ability.extra.picked_b = nil

      local available = {}
      for _, j in ipairs(G.jokers.cards) do
        if j ~= card and not j.gone and j.config and j.config.center
            and j.config.center.key ~= 'j_Sculio_jokes_against_humanity' then
          table.insert(available, j)
        end
      end
      local a, b = pick_two_distinct(available)

      for _, target in ipairs({ a, b }) do
        if target and SMODS.pseudorandom_probability(card, 'jokes_against_humanity', 1, card.ability.extra.odds, 'jokes_against_humanity') then
          target:set_debuff(true)
          table.insert(card.ability.extra.debuffed_jokers, target)
        end
      end

      card.ability.extra.picked_a = a
      card.ability.extra.picked_b = b
      local function is_my_pick(c)
        return c and not c.gone and (c == card.ability.extra.picked_a or c == card.ability.extra.picked_b)
      end
      if a then a:juice_up() end
      if b then b:juice_up() end
      if a then juice_card_until(a, is_my_pick, nil, 0.75) end
      if b then juice_card_until(b, is_my_pick, nil, 0.75) end
    end

    if context.final_scoring_step then
      G.E_MANAGER:add_event(Event({
        func = function()
          Sculio.undebuff_list(card.ability.extra.debuffed_jokers)
          card.ability.extra.debuffed_jokers = {}
          return true
        end
      }))
    end

    if context.joker_main then
      return { xmult = card.ability.extra.x_mult }
    end
  end
}
