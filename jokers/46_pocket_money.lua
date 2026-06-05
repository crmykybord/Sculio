SMODS.Joker {
  key = 'pocket_money',

  config = { extra = { money_recover = 3, used_this_round = false } },
  unlocked = true,
  discovered = false,
  rarity = 1, -- Common
  atlas = 'Sculio',
  pos = { x = 7, y = 4 },
  cost = 4,
  blueprint_compat = false,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.money_recover } }
  end,
  calculate = function(self, card, context)
    if context.buying_card and not context.blueprint and context.card ~= card then
      if not card.ability.extra.used_this_round then
        card.ability.extra.used_this_round = true
        return {
          dollars = card.ability.extra.money_recover,
          message = localize('k_dollars')
        }
      end
    end
    
    if context.end_of_round and not context.repetition and context.game_over == false then
      card.ability.extra.used_this_round = false
    end
  end
}
