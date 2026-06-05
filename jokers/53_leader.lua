SMODS.Joker {
  key = 'leader',

  config = { },
  unlocked = true,
  discovered = false,
  rarity = 3, -- Rare
  atlas = 'Sculio',
  pos = { x = 5, y = 5 },
  cost = 10,
  blueprint_compat = true,
  loc_vars = function(self, info_queue, card)
    local times_played = G.GAME.hands['High Card'].played or 0
    return { vars = { times_played } }
  end,
  calculate = function(self, card, context)
    if context.before then
      if context.scoring_name == 'High Card' then
        local times_played = G.GAME.hands['High Card'].played or 0
        if times_played > 0 then
          return {
            mult_mod = times_played,
            message = localize { type = 'variable', key = 'a_mult', vars = { times_played } }
          }
        end
      end
    end
  end
}
