Sculio.add_lunar_pack_to_shop = function(context)
  if not (context and context.starting_shop and G and G.GAME and G.shop_booster
      and G.GAME.round_resets and SMODS.add_booster_to_shop) then
    return
  end

  local ante = G.GAME.round_resets.ante
  if G.GAME.sculio_lunar_pack_ante == ante then return end

  local pack = SMODS.add_booster_to_shop('p_celestial_mega_1')
  if pack then
    pack.cost = 0
    G.GAME.sculio_lunar_pack_ante = ante
  end
end

SMODS.Back {
  key = 'lunar',
  atlas = 'Sculio_Enhancements',
  pos = { x = 4, y = 4 },
  calculate = function(self, back, context)
    Sculio.add_lunar_pack_to_shop(context)
  end,
}
