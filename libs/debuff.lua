-- Universal anti-debuff check (used by Pharaoh before emitting debuff).
-- Mirrors every immunity signal SMODS-adjacent code honors:
--  - mod.set_debuff(card) == 'prevent_debuff' for any loaded mod
--    (Paperback Sleeved; see SMODS lovely/mod.toml)
--  - BUNCOMOD.content.set_debuff (Bunco keeps its check off the mod
--    object, so the SMODS loop never sees Fluorescent)
--  - card.ability.debuff_sources entries == 'prevent_debuff'
-- Foreign hooks run pcall-guarded: they may assume game state
-- (e.g. a live blind) that isn't there during a recalc.
function Sculio.is_debuff_immune(target)
  if not target then return false end
  for _, mod in ipairs(SMODS.mod_list or {}) do
    if mod.set_debuff and type(mod.set_debuff) == 'function' then
      local ok, res = pcall(mod.set_debuff, target)
      if ok and res == 'prevent_debuff' then return true end
    end
  end
  if BUNCOMOD and BUNCOMOD.content and type(BUNCOMOD.content.set_debuff) == 'function' then
    local ok, res = pcall(BUNCOMOD.content.set_debuff, target)
    if ok and res == 'prevent_debuff' then return true end
  end
  for _, v in pairs(target.ability and target.ability.debuff_sources or {}) do
    if v == 'prevent_debuff' then return true end
  end
  return false
end
