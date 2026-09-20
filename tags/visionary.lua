SMODS.Tag {
  key = 'visionary',
  atlas = 'Sculio_Tags',
  pos = { x = 2, y = 0 },
  apply = function(self, tag, context)
    if context.type ~= 'new_blind_choice' then return end
    local lock = tag.ID
    G.CONTROLLER.locks[lock] = true
    tag:yep('+', G.C.SECONDARY_SET.Inverted, function()
      local key = 'p_Sculio_inverted_mega_' .. math.random(1, 2)
      local card = Card(G.play.T.x + G.play.T.w/2 - G.CARD_W*1.27/2,
        G.play.T.y + G.play.T.h/2 - G.CARD_H*1.27/2, G.CARD_W*1.27, G.CARD_H*1.27,
        G.P_CARDS.empty, G.P_CENTERS[key], {bypass_discovery_center = true, bypass_discovery_ui = true})
      card.cost = 0
      card.from_tag = true
      G.FUNCS.use_card({config = {ref_table = card}})
      card:start_materialize()
      G.CONTROLLER.locks[lock] = nil
      return true
    end)
    tag.triggered = true
    return true
  end,
}
