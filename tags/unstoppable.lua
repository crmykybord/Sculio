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
      -- Merge: a second copy of the tag stacks onto the waiting Unstoppable
      -- instead of opening a duplicate (accumulated mult, single card)
      for _, c in ipairs(context.area.cards) do
        if c.config.center_key == 'j_Sculio_unstoppable' then
          c.ability.extra.x_mult = c.ability.extra.x_mult + ((tag.ability and tag.ability.x_mult_gain) or 0.1)
          tag:yep('+', G.C.RED, function()
            c:start_materialize()
            return true
          end)
          tag.triggered = true
          return nil
        end
      end
      local card = SMODS.create_card({ set = 'Joker', area = context.area, key = 'j_Sculio_unstoppable', key_append = 'uta' })
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
