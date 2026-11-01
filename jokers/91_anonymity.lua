local FACE_DOWN = 'Sculio_anonymity_face_down'

SMODS.Joker {
  key = 'anonymity',
  attributes = { 'mult', 'scaling', 'face' },
  eternal_compat = true,
  blueprint_compat = false,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = { gain = 1, mult = 0 } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 2, y = 9 },
  cost = 6,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.gain, card.ability.extra.mult } }
  end,
  calculate = function(self, card, context)
    if context.stay_flipped and context.other_card and context.other_card.ability then
      if context.to_area == G.hand then
        if context.other_card:is_face() then
          context.other_card.ability[FACE_DOWN] = true
          return { stay_flipped = true }
        end
      end
      if context.to_area == G.play and context.other_card.facing == 'back' then
        context.other_card.ability[FACE_DOWN] = true
      end
    end

    if context.before and (context.scoring_hand or context.full_hand) then
      local hand = context.scoring_hand or context.full_hand
      local face_count = 0
      for _, played in ipairs(hand) do
        if played:is_face() then face_count = face_count + 1 end
      end
      if face_count > 0 then
        card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.gain * face_count
        return {
          message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.gain * face_count } },
          colour = G.C.MULT,
        }
      end
    end

    if context.joker_main and card.ability.extra.mult > 0 then
      return { mult = card.ability.extra.mult }
    end
  end
}