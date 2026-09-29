local SUIT_INVERTED = {
  Hearts    = 'c_Sculio_twilight',
  Diamonds  = 'c_Sculio_collapse',
  Clubs     = 'c_Sculio_eclipse',
  Spades    = 'c_Sculio_cave',
}

SMODS.Joker {
  key = 'evidence_board',
  attributes = { 'generation', 'consumables', 'tarot' },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  config = {},
  unlocked = true,
  discovered = false,
  rarity = 3, -- Rare
  atlas = 'Sculio',
  pos = { x = 0, y = 8 },
  cost = 7,
  calculate = function(self, card, context)
    if context.setting_blind then
      G.GAME.Sculio_evidence_created = nil
    end
    -- First suited scoring card of each round determines the Inverted Tarot
    if context.individual and context.cardarea == G.play and context.other_card
        and not G.GAME.Sculio_evidence_created then
      local c = context.other_card
      if not c.debuff and SMODS.has_no_suit(c) then return end
      local suit = c.base and c.base.suit
      if suit then
        local inverted = SUIT_INVERTED[suit]
        if inverted and G.P_CENTERS[inverted]
            and G.consumeables.config.card_limit > #G.consumeables.cards then
          G.GAME.Sculio_evidence_created = true
          local eff_card = context.blueprint_card or card
          Sculio.create_center_card(inverted, G.consumeables, 1, 'sculio_evidence_board')
          return {
            extra = { message = localize('k_Sculio_plus_inverted'), focus = eff_card },
            colour = G.C.SECONDARY_SET.Inverted,
            card = eff_card,
          }
        end
      end
    end
  end,
}
