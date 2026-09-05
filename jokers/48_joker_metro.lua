-- Pick a random available center key from a center pool ('Enhanced', 'Seal', 'Edition')
local function pick_center(_type, seed)
  local pool = get_current_pool(_type)
  local key
  repeat
    key = pseudorandom_element(pool, pseudoseed(seed))
  until key ~= 'UNAVAILABLE'
  return key
end

SMODS.Joker {
  key = 'joker_metro',
  attributes = { 'boss_blind', 'modify_card' },
  eternal_compat = true,
  blueprint_compat = false,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = { cards = 5 } },
  unlocked = true,
  discovered = false,
  rarity = 2,
  atlas = 'Sculio',
  pos = { x = 0, y = 5 },
  cost = 8,
  loc_vars = function(self, info_queue, card)
    card.ability.extra.cards = card.ability.extra.cards or 5 -- old saves without the rework
    return { vars = { card.ability.extra.cards } }
  end,
  calculate = function(self, card, context)
    if context.blind_defeated and not context.blueprint and G.GAME.blind.boss then
      card.ability.extra.cards = card.ability.extra.cards or 5
      local candidates = {}
      for _, c in ipairs(G.playing_cards or {}) do
        candidates[#candidates + 1] = c
      end

      G.E_MANAGER:add_event(Event({
        func = function()
          play_sound('polychrome1')
          for i = 1, math.min(card.ability.extra.cards, #candidates) do
            local idx = pseudorandom('joker_metro_card' .. i, 1, #candidates)
            local target = candidates[idx]
            table.remove(candidates, idx)
            if target then
              target:juice_up(0.3, 0.5)
              local roll = pseudorandom('joker_metro_kind' .. i, 1, 3)
              if roll == 1 then
                target:set_ability(G.P_CENTERS[pick_center('Enhanced', 'joker_metro_enh' .. i)], false)
              elseif roll == 2 then
                target:set_seal(pick_center('Seal', 'joker_metro_seal' .. i), true)
              else
                local edition_key = pick_center('Edition', 'joker_metro_ed' .. i)
                while edition_key == 'e_base' do
                  edition_key = pick_center('Edition', 'joker_metro_ed' .. i)
                end
                target:set_edition(edition_key, true)
              end
            end
          end
          return true
        end
      }))

      return { message = localize('k_upgrade_ex'), colour = G.C.FILTER }
    end
  end
}
