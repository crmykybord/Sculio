SMODS.Consumable {
  key = 'scholar',
  set = 'Inverted',
  atlas = 'Sculio_Consumables',
  pos = { x = 1, y = 0 },
  unlocked = true,
  discovered = false,
  cost = 3,
  config = { max_highlighted = 2 },
  loc_vars = function(self, info_queue, card)
    if not Sculio.distorted() then
      info_queue[#info_queue + 1] = G.P_CENTERS.m_Sculio_experimental
    end
    return { vars = { Sculio.max_highlighted(card) }, key = Sculio.distorted_key(self) }
  end,
  can_use = function(self, card)
    return Sculio.can_select(card)
  end,
  use = function(self, card, area, copier)
    Sculio.track_inverted_use(card)
    local distorted = Sculio.distorted()
    Sculio.apply_highlighted(function(cards)
      for _, c in ipairs(cards) do
        c:set_ability(G.P_CENTERS.m_Sculio_experimental, false)
        if distorted and c.ability.extra then
          -- Distorted Flow: converts at 5/5 and pays $15 on completion
          c.ability.extra.max = 5
          c.ability.extra.count = 0
          c.ability.extra.reward = 15
        end
      end
    end, Sculio.max_highlighted(card), card)
  end,
}
