-- Anonymity: playing cards have a 1 in 3 chance to be dealt face down, and the
-- joker gains +1 Mult for each face-down card played.
-- The face-down roll is the dormant vanilla mechanic G.GAME.modifiers.flipped_cards
-- (draw_card / draw_card_from already roll pseudoseed('flipped_card') against it;
-- no blind in this version sets it). We own the flag: set on add_to_deck, cleared
-- on remove_from_deck when no other copy remains.
-- A flipped card reaching G.play would normally flip face-up on the move, so the
-- SMODS stay_flipped hook keeps face-down played cards face-down; that also lets
-- `before` see them (facing == 'back') to charge the gain. can_calculate only
-- checks debuff/sliced, so face-down cards still score normally.
-- blueprint_compat = false: the gain mutates its own counter per dispatch.
SMODS.Joker {
  key = 'anonymity',
  attributes = { 'mult', 'scaling', 'chance' },
  eternal_compat = true,
  blueprint_compat = false,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = { odds = 3, gain = 1, mult = 0 } },
  unlocked = true,
  discovered = false,
  rarity = 1, -- Common
  atlas = 'Sculio',
  pos = { x = 2, y = 9 },
  cost = 5,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.odds, card.ability.extra.gain, card.ability.extra.mult } }
  end,
  add_to_deck = function(self, card, from_debuff)
    G.GAME.modifiers.flipped_cards = card.ability.extra.odds
  end,
  remove_from_deck = function(self, card, from_debuff)
    for _, joker in ipairs(G.jokers.cards) do
      if joker ~= card and joker.config.center.key == 'j_Sculio_anonymity' then return end
    end
    G.GAME.modifiers.flipped_cards = nil
  end,
  calculate = function(self, card, context)
    -- played cards keep the back they were dealt with
    if context.stay_flipped and context.to_area == G.play
        and context.other_card and context.other_card.facing == 'back' then
      return { stay_flipped = true }
    end

    if context.before and context.full_hand then
      local hidden = 0
      for _, played in ipairs(context.full_hand) do
        if played.facing == 'back' then hidden = hidden + 1 end
      end
      if hidden > 0 then
        card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.gain * hidden
        return {
          message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.gain * hidden } },
          colour = G.C.MULT,
        }
      end
    end

    if context.joker_main and card.ability.extra.mult > 0 then
      return { mult = card.ability.extra.mult }
    end
  end
}
