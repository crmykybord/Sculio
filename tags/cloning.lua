SMODS.Tag {
  key = 'cloning',
  atlas = 'Sculio_Tags',
  pos = { x = 2, y = 0 },
  apply = function(self, tag, context)
    if context.type ~= 'store_joker_create' then return end
    local owned = {}
    if G.jokers and G.jokers.cards then
      for _, c in ipairs(G.jokers.cards) do
        if c.config and c.config.center and c.config.center.set == 'Joker' then owned[#owned + 1] = c end
      end
    end
    -- Nothing to clone: leave the tag pending for a later shop.
    if #owned == 0 then return end
    local picked = pseudorandom_element(owned, pseudoseed('Sculio_cloning_tag'))
    local card = SMODS.copy_card(picked, { no_add = true })
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
