SMODS.Joker {
  key = 'computer_virus',
  attributes = { 'boss_blind', 'destruction' },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = {} },
  unlocked = true,
  discovered = false,
  rarity = 3,
  atlas = 'Sculio',
  pos = { x = 7, y = 5 },
  cost = 8,
  loc_vars = function(self, info_queue, card)
    return { vars = {} }
  end,
  calculate = function(self, card, context)
    if context.blind_defeated and not context.blueprint and G.GAME.blind:get_type() == 'Boss' and #G.jokers.cards > 1 then
      -- Si este Virus es el comodin del extremo derecho, no hace nada (nunca se autodestruye)
      if G.jokers.cards[#G.jokers.cards] == card then return end
      local rightmost = nil
      for i = #G.jokers.cards, 1, -1 do
        local other = G.jokers.cards[i]
        if other ~= card
            and other.config.center.key ~= 'j_Sculio_computer_virus'
            and not other.ability.eternal then
          rightmost = other
          break
        end
      end
      if not rightmost then return end

      rightmost.ability.eternal = nil
      rightmost.ability.perishable = nil
      rightmost.ability.rental = nil
      G.jokers:remove_card(rightmost)
      rightmost:remove()

      local new_joker = SMODS.create_card({
        set = 'Joker',
        rarity = 'Common',
        major = false,
        no_soul = true,
      })
      local edition = pseudorandom('computer_virus_edition') < 0.5 and 'e_negative' or 'e_polychrome'
      new_joker:set_edition(edition, true)
      new_joker.no_sell_value = true
      G.jokers:emplace(new_joker)
    end
  end
}
