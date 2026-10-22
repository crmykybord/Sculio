local FACE_DOWN = 'Sculio_anonymity_face_down'

local function anonymity_dealing_hand()
  return G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.DRAW_TO_HAND
end

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
  calculate = function(self, card, context)
    if context.stay_flipped and context.other_card and context.other_card.ability then
      if context.to_area == G.hand then
        local flipped = anonymity_dealing_hand()
          and pseudoseed('Sculio_anonymity_flip') < 1 / card.ability.extra.odds
        context.other_card.ability[FACE_DOWN] = flipped or nil
        if flipped then return { stay_flipped = true } end
      end
      if context.to_area == G.play and context.other_card.facing == 'back' then
        context.other_card.ability[FACE_DOWN] = true
      end
    end

    if context.before and context.full_hand then
      local hidden = 0
      for _, played in ipairs(context.full_hand) do
        if played.ability and played.ability[FACE_DOWN] then hidden = hidden + 1 end
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
