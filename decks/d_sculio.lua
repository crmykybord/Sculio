Sculio.modify_joker_weights = function(context, multiplier)
  if not (context and context.modify_weights and context.pool) then return end
  for _, entry in ipairs(context.pool) do
    if entry.key and entry.key:sub(1, 9) == 'j_Sculio_' then
      entry.weight = entry.weight * multiplier
    end
  end
end

SMODS.Back {
  key = 'sculio',
  atlas = 'Sculio_Enhancements',
  pos = { x = 3, y = 4 },
  config = { extra = { joker_weight = 3 } },
  loc_vars = function(self)
    return { vars = { self.config.extra.joker_weight } }
  end,
  calculate = function(self, back, context)
    Sculio.modify_joker_weights(context, back.effect.config.extra.joker_weight)
  end,
}
