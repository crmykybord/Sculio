SMODS.Joker {
  key = 'cloning_vat',

  unlocked = true,
  discovered = false,
  rarity = 3, -- Rare
  atlas = 'Sculio',
  pos = { x = 4, y = 3 },
  cost = 10,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.playing_card_added and #context.cards == 1 and G.shop then
      local bought_card = context.cards[1]

      -- https://www.reddit.com/r/lua/comments/1dz389o/comment/lcghclt/
      local isbool = {[true]=true, [false]=true}
      if isbool[bought_card] then
        -- Incompatible: the cards being added (sometimes is true when used from vanilla items)
        -- Happens with DNA.
        return true
      end

      -- From Strength and Sigil.
      local suit_prefix = string.sub(bought_card.base.suit, 1, 1) .. '_'
      local rank_suffix = bought_card.base.id < 10 and tostring(bought_card.base.id) or
      bought_card.base.id == 10 and 'T' or bought_card.base.id == 11 and 'J' or
      bought_card.base.id == 12 and 'Q' or bought_card.base.id == 13 and 'K' or
      bought_card.base.id == 14 and 'A'

      local new_card = create_playing_card({front = G.P_CARDS[suit_prefix .. rank_suffix], center = bought_card.config.center}, G.deck, true, true)
      new_card:set_seal(bought_card.seal, true, true)
      new_card:set_edition(bought_card.edition, true, true)

      -- TODO: Replace with some version of this: copy_card(bought_card, nil, nil, G.playing_card)
      new_card:add_to_deck()

      return {
        message = localize('k_copied_ex'),
        colour = G.C.CHIPS,
        card = card,
        playing_cards_created = {true}
      }
    end
  end
}
