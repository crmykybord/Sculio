SMODS.Joker {
  key = 'gold_ore',

  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 5, y = 0 },
  cost = 6,
  enhancement_gate = 'm_stone',
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_stone
    info_queue[#info_queue+1] = G.P_SEALS.Gold
  end,
  calculate = function(self, card, context)
    if context.before and not context.blueprint then
      -- Based off of Vampire.
      for k, v in ipairs(context.scoring_hand) do
        if v.debuff == false and v.config.center == G.P_CENTERS.m_stone and not v.debuff and not v.vampired then
          v:set_seal('Gold', nil, true)

          G.E_MANAGER:add_event(Event({
            func = function()
              v:juice_up()
              return true
            end
          }))
        end
      end
    end
  end
}
