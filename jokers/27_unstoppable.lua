SMODS.Joker {
  key = 'unstoppable',
  attributes = { 'xmult', 'on_sell', 'tag', "scaling" },
  eternal_compat = false,
  blueprint_compat = true,
  perishable_compat = false,
  rental_compat = true,
  config = { extra = { x_mult = 1, x_mult_gain = 0.1, sell_cost = 0 } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 8, y = 2 },
  cost = 6,
  loc_vars = function(self, info_queue, card)
    local extra = card.ability.extra or {}
    return { vars = { extra.x_mult or 1, extra.x_mult_gain or 0.1, extra.sell_cost or 0 } }
  end,
  add_to_deck = function(self, card, from_debuff)
    -- Set sell cost to $0.
    card.ability.extra_value = (card.ability.extra_value or 0) - card.sell_cost + card.ability.extra.sell_cost
    card:set_cost()
  end,
  calculate = function(self, card, context)
    if context.joker_main and card.ability.extra.x_mult > 1 then
      return {
        xmult = card.ability.extra.x_mult,
        message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult } }
      }
    end

    if context.selling_self then
      local tag = Tag('tag_Sculio_unstoppable')
      tag.ability.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_gain
      tag.ability.x_mult_gain = card.ability.extra.x_mult_gain

      G.E_MANAGER:add_event(Event({
        func = (function()
          -- Do not trigger Double Tag.
          local apply_to_run_functions = {}

          for i = 1, #G.GAME.tags do
            table.insert(apply_to_run_functions, G.GAME.tags[i].apply_to_run)
            G.GAME.tags[i].apply_to_run = function() end
          end

          add_tag(tag)

          for i = 1, #apply_to_run_functions do
            G.GAME.tags[i].apply_to_run = apply_to_run_functions[i]
          end

          play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
          play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
          return true
        end)
      }))
    end
  end
}
