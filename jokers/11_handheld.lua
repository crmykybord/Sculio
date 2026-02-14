local Card_is_suit_ref = Card.is_suit
function Card:is_suit(suit, bypass_debuff, flush_calc)
  if flush_calc then
    if next(find_joker('j_Sculio_handheld')) and not self.debuff then
      return true
    end
  else
    if not (self.debuff and not bypass_debuff) then
      if next(find_joker('j_Sculio_handheld')) then
        return true
      end
    end
  end
  return Card_is_suit_ref(self, suit, bypass_debuff, flush_calc)
end

SMODS.Joker {
  key = 'handheld',

  unlocked = true,
  discovered = false,
  rarity = 3, -- Rare
  atlas = 'Sculio',
  pos = { x = 0, y = 1 },
  cost = 9,
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_wild
  end
}
