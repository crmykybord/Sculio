-- The 10 standard Balatro poker hands. Anything else (vanilla secret hands like
-- Five of a Kind / Flush Five / Flush House, or modded secret hands registered
-- via SMODS.PokerHand) is treated as a secret hand and triggers Manilla Folder.
local STANDARD_HANDS = {
  ['High Card'] = true,
  ['Pair'] = true,
  ['Two Pair'] = true,
  ['Three of a Kind'] = true,
  ['Straight'] = true,
  ['Flush'] = true,
  ['Full House'] = true,
  ['Four of a Kind'] = true,
  ['Straight Flush'] = true,
  ['Royal Flush'] = true,
}

local function is_secret_hand(hand_name)
  if not hand_name or STANDARD_HANDS[hand_name] then return false end
  -- The hand must be registered in G.GAME.hands (covers both vanilla and SMODS-registered hands).
  return G.GAME and G.GAME.hands and G.GAME.hands[hand_name] ~= nil
end

SMODS.Joker {
  key = 'manilla_folder',
  attributes = { 'consumables', 'secret_hand' },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = {} },
  unlocked = true,
  discovered = false,
  rarity = 3,
  atlas = 'Sculio',
  pos = { x = 8, y = 5 },
  cost = 7,
  loc_vars = function(self, info_queue, card)
    return { vars = {} }
  end,
  calculate = function(self, card, context)
    -- Trigger BEFORE the hand is played (when the player commits to a Secret Hand).
    -- This matches the description: "When playing a Secret Hand, fill empty consumable slots".
    if context.before and context.scoring_name and not context.blueprint and is_secret_hand(context.scoring_name) then
      G.E_MANAGER:add_event(Event({
        blockable = true,
        func = function()
          if not G.consumeables or not G.consumeables.cards or not G.consumeables.config then return true end
          local num_slots = G.consumeables.config.card_limit or 2
          local empty_slots = num_slots - #G.consumeables.cards
          if empty_slots <= 0 then return true end
          for _ = 1, empty_slots do
            if pseudorandom('manilla_folder_type') < 0.9 then
              local consume_type = pseudorandom('manilla_folder_consumable')
              local new_consumable
              if consume_type < 0.4 then
                new_consumable = SMODS.create_card({ set = 'Tarot', rarity = 1, no_soul = true })
              elseif consume_type < 0.7 then
                new_consumable = SMODS.create_card({ set = 'Planet', rarity = 1, no_soul = true })
              else
                new_consumable = SMODS.create_card({ set = 'Spectral', rarity = 1, no_soul = true })
              end
              if new_consumable and G.consumeables then
                G.consumeables:emplace(new_consumable)
              end
            else
              local new_consumable = SMODS.create_card({ set = 'Spectral', rarity = 1, no_soul = true })
              if new_consumable and G.consumeables then
                G.consumeables:emplace(new_consumable)
              end
            end
          end
          return true
        end
      }))
    end
  end
}
