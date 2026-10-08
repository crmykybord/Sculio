-- Tracks what was the last effect so does not proc two times, greatest if else of all time
local EFFECTS = { 'xmult', 'xchips', 'money', 'chips', 'mult', 'level' }
local copied_effects = setmetatable({}, { __mode = 'k' })

local function roll_effect(card)
  local extra = card.ability.extra
  extra.rolls = (extra.rolls or 0) + 1
  local salt = 'dodecahedron_' .. tostring(extra.rolls) .. '_' .. tostring(G.GAME.round or 0)
  extra.effect = EFFECTS[math.floor(pseudohash(salt) * #EFFECTS) + 1]
end

local function roll_copied_effect(card, copier, extra, hands_played)
  local by_copier = copied_effects[card]
  if not by_copier then
    by_copier = setmetatable({}, { __mode = 'k' })
    copied_effects[card] = by_copier
  end

  local roll = by_copier[copier]
  if not roll or roll.hands_played ~= hands_played then
    local choices = {}
    for _, effect in ipairs(EFFECTS) do
      if effect ~= extra.effect then choices[#choices + 1] = effect end
    end
    local salt = 'sculio_dodecahedron_copy_' .. tostring(extra.rolls) .. '_' .. tostring(hands_played)
    local index = math.floor(pseudoseed(salt) * #choices) + 1
    roll = { hands_played = hands_played, effect = choices[index] }
    by_copier[copier] = roll
  end
  return roll.effect
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
    if context.before then
      local extra = card.ability.extra
      local hands_played = G.GAME.current_round.hands_played
      if extra.last_hand ~= hands_played then
        roll_effect(card)
        extra.last_hand = hands_played
      end
      local eff_card = context.blueprint_card or card
      local effect = extra.effect
      local copier = context.blueprint_copier or context.blueprint_card
      if context.blueprint and copier then
        effect = roll_copied_effect(card, copier, extra, hands_played)
      end
      if effect == 'money' then
        ease_dollars(extra.money) -- already credits G.GAME.dollars
        card_eval_status_text(eff_card, 'dollars', extra.money)
      elseif effect == 'level' and context.scoring_name and G.GAME.hands[context.scoring_name] then
        level_up_hand(eff_card, context.scoring_name, false, extra.levels)
      end
    end

    if context.joker_main then
      local extra = card.ability.extra
      local effect = extra.effect
      local copier = context.blueprint_copier or context.blueprint_card
      if context.blueprint and copier then
        effect = roll_copied_effect(card, copier, extra, G.GAME.current_round.hands_played)
      end
      if effect == 'xmult' then return { xmult = extra.x_mult } end
      if effect == 'xchips' then return { x_chips = extra.x_chips } end
      if effect == 'chips' then return { chips = extra.chips } end
      if effect == 'mult' then return { mult = extra.mult } end
    end
  end
}
