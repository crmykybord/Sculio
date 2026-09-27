-- Golden version of the Unstoppable Force tag.
-- Cross-mod with All in Jest: only ever drawn from its "Jest_Golden_Tag" pool.
-- Like the regular tag it does NOT use a fixed value: it bases on the highest
-- Unstoppable Force that is currently "live" (in your Jokers, waiting in the
-- shop, or still carried by a pending regular tag) and adds GOLD_GAIN on top.
-- Values are applied with math.max, so tag order never matters and two tags
-- can never cancel or stack onto each other beyond that max.
local GOLD_GAIN = 1.5

local function current_xmult(area)
  local best = 1
  local function consider(c)
    if c and c.config and c.config.center_key == 'j_Sculio_unstoppable'
        and c.ability and c.ability.extra then
      best = math.max(best, c.ability.extra.x_mult or 1)
    end
  end
  for _, c in ipairs(G.jokers and G.jokers.cards or {}) do consider(c) end
  for _, c in ipairs(area and area.cards or {}) do consider(c) end
  -- A pending regular tag already knows the value the returned Joker will have.
  for _, t in ipairs(G.GAME.tags or {}) do
    if t.key == 'tag_Sculio_unstoppable' and t.ability then
      best = math.max(best, t.ability.x_mult or 1)
    end
  end
  return best
end

SMODS.Tag {
  key = 'unstoppable_gold',
  atlas = 'Sculio_Tags',
  pos = { x = 2, y = 0 },
  config = { aij = { upgrade = 'Sculio_unstoppable' } },
  attributes = { 'joker', 'xmult' },
  min_ante = 1,
  -- All in Jest polls golden tags with a "_gold" append; reject every other pool.
  in_pool = function(self, args)
    return args and type(args.source) == 'string' and args.source:sub(-5) == '_gold'
  end,
  -- Only exists as an All in Jest golden tag.
  no_collection = function(self, args)
    return not (SMODS.find_mod('allinjest') and SMODS.find_mod('allinjest')[1])
  end,
  set_ability = function(self, tag)
    tag = tag or self
    tag.ability.x_mult_gain = tag.ability.x_mult_gain or GOLD_GAIN
  end,
  loc_vars = function(self, info_queue, tag)
    return { vars = { (tag.ability and tag.ability.x_mult_gain) or GOLD_GAIN } }
  end,
  apply = function(self, tag, context)
    if context.type ~= 'store_joker_create' then return end
    local gain = (tag.ability and tag.ability.x_mult_gain) or GOLD_GAIN
    local target = current_xmult(context.area) + gain

    for _, c in ipairs(context.area.cards) do
      if c.config.center_key == 'j_Sculio_unstoppable' then
        c.ability.extra.x_mult = math.max(c.ability.extra.x_mult or 1, target)
        tag:yep('+', G.C.RED, function()
          c:start_materialize()
          c.ability.couponed = true
          c:set_cost()
          return true
        end)
        tag.triggered = true
        return nil
      end
    end

    local card = SMODS.create_card({ set = 'Joker', area = context.area, key = 'j_Sculio_unstoppable', key_append = 'utag' })
    card.ability.extra.x_mult = math.max(card.ability.extra.x_mult or 1, target)
    create_shop_card_ui(card, 'Joker', context.area)
    card.states.visible = false
    tag:yep('+', G.C.RED, function()
      card:start_materialize()
      card.ability.couponed = true
      card:set_cost()
      return true
    end)
    tag.triggered = true
    return card
  end,
}
