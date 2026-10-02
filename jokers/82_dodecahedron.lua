-- Tracks what was the last effect so does not proc two times, greatest if else of all time
local EFFECTS = { 'xmult', 'xchips', 'money', 'chips', 'mult', 'level' }

local function roll_effect(card)
  local extra = card.ability.extra
  extra.rolls = (extra.rolls or 0) + 1
  local salt = 'dodecahedron_' .. tostring(extra.rolls) .. '_' .. tostring(G.GAME.round or 0)
  extra.effect = EFFECTS[math.floor(pseudohash(salt) * #EFFECTS) + 1]
end

SMODS.Joker {
  key = 'dodecahedron',
  attributes = { 'xmult', 'xchips', 'chips', 'mult', 'money', 'planet', 'random' },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = { x_mult = 2, x_chips = 2, money = 8, chips = 250, mult = 35, levels = 1, effect = 'xmult', rolls = 0, } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 4, y = 8 },
  cost = 7,
  calculate = function(self, card, context)
    if context.before and not context.blueprint then
      roll_effect(card)
      local extra = card.ability.extra
      local eff_card = context.blueprint_card or card
      if extra.effect == 'money' then
        ease_dollars(extra.money) -- already credits G.GAME.dollars
        G.E_MANAGER:add_event(Event({
          trigger = 'immediate',
          func = function()
            card_eval_status_text(eff_card, 'extra', nil, nil, nil,
              { message = localize('$') .. extra.money, colour = G.C.MONEY })
            return true
          end
        }))
      elseif extra.effect == 'level' and context.scoring_name and G.GAME.hands[context.scoring_name] then
        level_up_hand(eff_card, context.scoring_name, false, extra.levels)
      end
    end

    if context.joker_main then
      local extra = card.ability.extra
      if extra.effect == 'xmult' then return { xmult = extra.x_mult } end
      if extra.effect == 'xchips' then return { x_chips = extra.x_chips } end
      if extra.effect == 'chips' then return { chips = extra.chips } end
      if extra.effect == 'mult' then return { mult = extra.mult } end
    end
  end
}