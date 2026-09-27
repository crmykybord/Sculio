-- Golden version of the Unstoppable Force tag.
-- Cross-mod with All in Jest
local GOLD_GAIN = 1.5
local GOLD_TOTAL = 1 + GOLD_GAIN

SMODS.Tag {
  key = 'unstoppable_gold',
  atlas = 'Sculio_Tags',
  pos = { x = 2, y = 0 },
  config = { aij = { upgrade = 'Sculio_unstoppable' } },
  attributes = { 'joker', 'xmult' },
  min_ante = 1,
  in_pool = function(self, args)
    return args and type(args.source) == 'string' and args.source:sub(-5) == '_gold'
  end,
  -- Only exists as an All in Jest golden tag.
  no_collection = function(self, args)
    return not (SMODS.find_mod('allinjest') and SMODS.find_mod('allinjest')[1])
  end,
  set_ability = function(self, tag)
    tag = tag or self
    tag.ability.x_mult = tag.ability.x_mult or GOLD_TOTAL
    tag.ability.x_mult_gain = tag.ability.x_mult_gain or GOLD_GAIN
  end,
  loc_vars = function(self, info_queue, tag)
    return { vars = { (tag.ability and tag.ability.x_mult) or GOLD_TOTAL } }
  end,
  apply = function(self, tag, context)
    if context.type ~= 'store_joker_create' then return end
    local gain = (tag.ability and tag.ability.x_mult_gain) or GOLD_GAIN

    for _, c in ipairs(context.area.cards) do
      if c.config.center_key == 'j_Sculio_unstoppable' then
        c.ability.extra.x_mult = (c.ability.extra.x_mult or 1) + gain
        c.ability.couponed = true
        c.cost = 0
        tag:yep('+', G.C.RED, function()
          c:start_materialize()
          return true
        end)
        tag.triggered = true
        return nil
      end
    end

    local card = SMODS.create_card({ set = 'Joker', area = context.area, key = 'j_Sculio_unstoppable', key_append = 'utag' })
    card.ability.extra.x_mult = (card.ability.extra.x_mult or 1) + gain
    card.ability.couponed = true
    card.cost = 0
    create_shop_card_ui(card, 'Joker', context.area)
    card.states.visible = false
    tag:yep('+', G.C.RED, function()
      card:start_materialize()
      return true
    end)
    tag.triggered = true
    return card
  end,
}
