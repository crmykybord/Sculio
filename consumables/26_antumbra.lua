-- Antumbra: Ectoplasm's meaner twin. One editionless Joker goes Negative, and
-- every hand level is stripped back to 1 (Black Hole running in reverse).
-- Each use raises the gate for the next one: level 1, then 2, then 3... The
-- counter lives in G.GAME because the card itself dissolves on use.
local function antumbra_req()
  return (G.GAME.Sculio_antumbra_uses or 0) + 1
end

local function antumbra_targets()
  local pool = {}
  if G.jokers then
    for _, c in ipairs(G.jokers.cards) do
      if c.ability and c.ability.set == 'Joker' and not c.edition and not c.REMOVED then
        pool[#pool + 1] = c
      end
    end
  end
  return pool
end

-- The gate only counts hands the run can actually see (the base 9; the hidden
-- Five of a Kind / Flush House / Flush Five start at level 1 and would
-- otherwise block this card forever).
local function antumbra_gate()
  local req = antumbra_req()
  for _, v in pairs(G.GAME.hands) do
    if v.visible ~= false and v.level < req then return false end
  end
  return true
end

SMODS.Spectral {
  key = 'antumbra',
  atlas = 'Sculio_Consumables',
  pos = { x = 6, y = 2 },
  cost = 4,
  loc_vars = function(self, info_queue, card)
    return { vars = { antumbra_req() } }
  end,
  can_use = function(self, card)
    return #antumbra_targets() > 0 and antumbra_gate()
  end,
  use = function(self, card, area, copier)
    G.GAME.Sculio_antumbra_uses = (G.GAME.Sculio_antumbra_uses or 0) + 1

    local pool = antumbra_targets()
    local joker = pool[math.floor(pseudoseed('sculio_antumbra') * #pool) + 1]
    if joker then
      G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.4, func = function()
        play_sound('tarot1')
        card:juice_up(0.3, 0.5)
        joker:set_edition({ negative = true }, true)
        check_for_unlock({ type = 'have_edition' })
        return true
      end }))
      delay(0.5)
    end

    -- Black Hole's all-hands sequence (card.lua), running the other way:
    -- the pulse flag is set and cleared INSIDE queued events, never sync.
    update_hand_text({ sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3 },
      { handname = localize('k_all_hands'), chips = '...', mult = '...', level = '' })
    G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.2, func = function()
      play_sound('tarot1')
      card:juice_up(0.8, 0.5)
      G.TAROT_INTERRUPT_PULSE = true
      return true end }))
    update_hand_text({ delay = 0 }, { mult = '-', StatusText = true })
    G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.9, func = function()
      play_sound('tarot1')
      card:juice_up(0.8, 0.5)
      return true end }))
    update_hand_text({ delay = 0 }, { chips = '-', StatusText = true })
    G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.9, func = function()
      play_sound('tarot1')
      card:juice_up(0.8, 0.5)
      G.TAROT_INTERRUPT_PULSE = nil
      return true end }))
    update_hand_text({ sound = 'button', volume = 0.7, pitch = 0.9, delay = 0 }, { level = '1' })
    delay(1.3)
    for k, v in pairs(G.GAME.hands) do
      if v.level > 1 then level_up_hand(card, k, true, 1 - v.level) end
    end
    update_hand_text({ sound = 'button', volume = 0.7, pitch = 1.1, delay = 0 },
      { mult = 0, chips = 0, handname = '', level = '' })
  end,
}
