SMODS.Joker {
  key = 'unstoppable',

  config = { extra = { x_mult = 1, x_mult_gain = 0.1, sell_cost = 0 } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 8, y = 2 },
  cost = 6,
  eternal_compat = false,
  blueprint_compat = true,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.x_mult, card.ability.extra.x_mult_gain, card.ability.extra.sell_cost } }
  end,
  add_to_deck = function(self, card, from_debuff)
    -- Set sell cost to $0.
    card.ability.extra_value = (card.ability.extra_value or 0) - card.sell_cost + card.ability.extra.sell_cost
    card:set_cost()
  end,
  calculate = function(self, card, context)
    if context.joker_main and card.ability.extra.x_mult > 1 then
      return {
        Xmult_mod = card.ability.extra.x_mult,
        message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult } }
      }
    end

    if context.selling_self then
      local tag = Tag('tag_Sculio_unstoppable')
      tag.ability.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_gain

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

SMODS.Tag {
  key = 'unstoppable',
  atlas = 'Sculio_Tags',
  pos = { x = 1, y = 0 },
  in_pool = function(self, args)
    return false
  end,
  loc_vars = function(self, info_queue, tag)
    return { vars = { (tag.ability and tag.ability.x_mult) or 1 } }
  end,
  apply = function(self, tag, context)
    if context.type == 'store_joker_create' then
      local card = create_card('Joker', context.area, nil, 0, nil, nil, 'j_Sculio_unstoppable', 'uta')
      card.ability.extra.x_mult = tag.ability.x_mult
      create_shop_card_ui(card, 'Joker', context.area)
      card.states.visible = false
      tag:yep('+', G.C.RED,function() 
        card:start_materialize()
        return true
      end)

      tag.triggered = true
      return card
    end
  end
}