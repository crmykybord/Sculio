-- Figurine/Puck description swap (3-stat base -> 4-stat with XChips).
-- Tooltips show the XChips stat only when such an edition can exist.

-- Cached check: does any registered Edition grant XChips? Figurine and Puck
-- tooltips show the XChips stat only when it can actually be gained.
Sculio._xchips_edition_cache = nil
function Sculio.xchips_editions_exist()
  local n = 0
  for _ in pairs(G.P_CENTERS or {}) do n = n + 1 end
  local cache = Sculio._xchips_edition_cache
  if cache and cache.n == n then return cache.found end
  local found = false
  for _, center in pairs(G.P_CENTERS or {}) do
    if center.set == 'Edition' and center.config then
      local cfg = center.config
      if (cfg.x_chips and cfg.x_chips > 1) or (cfg.Xchips and cfg.Xchips > 1)
        or (cfg.h_x_chips and cfg.h_x_chips > 1) then
        found = true
        break
      end
    end
  end
  Sculio._xchips_edition_cache = { n = n, found = found }
  return found
end

-- One-time swap of Figurine/Puck description text (3-stat base -> 4-stat with
-- XChips) when an XChips-granting edition from any mod is detected. Runs once
-- per language on the first calculate call (all mods loaded by then), so the
-- center scan happens a single time instead of on every tooltip render.
Sculio._stat_text_init_done = Sculio._stat_text_init_done or {}
function Sculio.maybe_apply_xchips_texts()
  local lang = (G.SETTINGS and G.SETTINGS.language) or 'en-us'
  if Sculio._stat_text_init_done[lang] then return end
  Sculio._stat_text_init_done[lang] = true
  if not Sculio.xchips_editions_exist() then return end
  local desc = G.localization and G.localization.descriptions and G.localization.descriptions.Joker
  if not desc then return end
  local alts = {
    j_Sculio_figurine = Sculio.FIGURINE_ALT_TEXT and (Sculio.FIGURINE_ALT_TEXT[lang] or Sculio.FIGURINE_ALT_TEXT['en-us']),
    j_Sculio_puck = Sculio.PUCK_ALT_TEXT and (Sculio.PUCK_ALT_TEXT[lang] or Sculio.PUCK_ALT_TEXT['en-us']),
  }
  for key, alt in pairs(alts) do
    if desc[key] and alt then desc[key].text = alt end
  end
end
