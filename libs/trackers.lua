-- Mod-wide context router (runs on every SMODS context via Sculio:calculate):
-- G.GAME.* trackers consumed by Inverted Tarots and jokers, plus shared
-- round behaviors (Pierced self-destruct, Trap debuff immunity + cleanup).
-- Generic stateless helpers live in libs/utils.lua instead.

function Sculio:calculate(context)
  -- Text setup (Figurine/Puck XChips swap); single flag check after
  Sculio.maybe_apply_xchips_texts()
  -- The Sane: remember the last Inverted Tarot used
  if context.using_consumeable and context.consumeable and context.consumeable.ability
      and context.consumeable.ability.set == 'Inverted' then
    G.GAME.Sculio_last_inverted = context.consumeable.config.center_key
    if sendDebugMessage then sendDebugMessage('Sculio: recorded last inverted = ' .. tostring(context.consumeable.config.center_key), 'SCULIO') end
  end

  -- Pierced Cards: 2+ played together destroy each other as the hand starts.
  -- Must be queued at press_play so the dissolve happens before scoring.
  if context.press_play and G.hand and G.hand.highlighted then
    local played = G.hand.highlighted
    local pierced_cards = {}
    for _, c in ipairs(played) do
      if SMODS.has_enhancement(c, 'm_Sculio_pierced') then
        pierced_cards[#pierced_cards + 1] = c
      end
    end
    if #pierced_cards >= 2 then
      play_sound('tarot1')
      for _, boom in ipairs(pierced_cards) do
        SMODS.destroy_cards(boom)
      end
    end
  end

  -- The Atoned / Reborn: remember modifiers of the last destroyed card
  if context.remove_playing_cards and context.removed then
    for _, c in ipairs(context.removed) do
      if c.base then
        G.GAME.Sculio_last_destroyed = {
          enhancement = (c.config.center_key ~= 'c_base') and c.config.center_key or nil,
          seal = c.seal,
          edition = c.edition and copy_table(c.edition) or nil,
        }
      end
    end
  end

  -- Handheld: remember the last enhancement obtained by a deck card
  if context.setting_ability and context.other_card and context.new ~= context.old then
    local center = G.P_CENTERS[context.new]
    if center and center.set == 'Enhanced' then
      G.GAME.Sculio_last_enhancement = context.new
    end
  end
  if context.playing_card_added and context.cards then
    for _, c in ipairs(context.cards) do
      if c.ability and c.ability.set == 'Enhanced' then
        G.GAME.Sculio_last_enhancement = c.config.center.key
      end
    end
  end

  -- Mercy: remember the last Joker sold
  if context.selling_card and context.card and context.card.ability.set == 'Joker' then
    G.GAME.Sculio_last_joker_sold = context.card.config.center_key
  end

  -- The Mundane: track money spent during the current shop
  if context.starting_shop then
    G.GAME.Sculio_shop_spend = 0
  elseif context.money_altered and context.amount and context.amount < 0 and context.from_shop then
    G.GAME.Sculio_shop_spend = (G.GAME.Sculio_shop_spend or 0) - context.amount
  end

  -- Trap Cards can protect adjacent cards from debuffs
  if context.debuff_card and context.other_card and context.other_card.ability
      and context.other_card.ability.Sculio_debuff_immune then
    return { prevent_debuff = true }
  end
  if context.end_of_round and context.main_eval and G.playing_cards then
    for _, c in ipairs(G.playing_cards) do
      c.ability.Sculio_debuff_immune = nil
    end
  end
end
