-- Full 4-stat text used when an XChips edition exists (e.g. Bunco)
Sculio.PUCK_ALT_TEXT = {
  ['en-us'] = {
    'When a card with an {C:attention}edition{} is scored,',
    'this Joker gains the {C:attention}edition\'s bonus{}',
    '{C:inactive,s:0.8}(Currently {C:chips,s:0.8}+#1#{}{C:inactive,s:0.8} Chips, {C:mult,s:0.8}+#2#{}{C:inactive,s:0.8} Mult, {X:mult,C:white,s:0.8}X#3#{}{C:inactive,s:0.8} Mult, and {X:chips,C:white,s:0.8}X#4#{}{C:inactive,s:0.8} Chips)',
  },
  ['es_419'] = {
    'Anotar cartas con {C:dark_edition}edición{} otorga',
    'sus {C:attention}bonificaciones{} a este comodín',
    '{C:inactive,s:0.8}(Actualmente {C:chips,s:0.8}+#1#{}{C:inactive,s:0.8} Fichas, {C:mult,s:0.8}+#2#{}{C:inactive,s:0.8} Multi, {X:mult,C:white,s:0.8}X#3#{}{C:inactive,s:0.8} Multi y {X:chips,C:white,s:0.8}X#4#{}{C:inactive,s:0.8} Fichas)',
  },
  ['es_ES'] = {
    'Anotar cartas con {C:dark_edition}edición{} otorga',
    'sus {C:attention}bonificaciones{} a este comodín',
    '{C:inactive,s:0.8}(Actualmente {C:chips,s:0.8}+#1#{}{C:inactive,s:0.8} Fichas, {C:mult,s:0.8}+#2#{}{C:inactive,s:0.8} Multi, {X:mult,C:white,s:0.8}X#3#{}{C:inactive,s:0.8} Multi y {X:chips,C:white,s:0.8}X#4#{}{C:inactive,s:0.8} Fichas)',
  },
}

SMODS.Joker {
  key = 'puck',
  attributes = { 'chips', 'mult', 'xmult', 'xchips', 'editions', "scaling" },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = false,
  rental_compat = true,
  config = { extra = { chips = 0, mult = 0, x_mult = 1, x_chips = 1, bonus_mult = 1 } },
  unlocked = true,
  discovered = false,
  rarity = 4, -- Legendary
  atlas = 'Sculio',
  pos = { x = 8, y = 1 },
  soul_pos = { x = 9, y = 1 },
  cost = 20,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.x_mult, card.ability.extra.x_chips } }
  end,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and not context.blueprint then
      local ed = context.other_card.edition
      if not ed or context.other_card.debuff then return end
      local message = Sculio.absorb_edition(card, context.other_card, card.ability.extra.bonus_mult)
      if message then
        return { extra = { message = message, focus = card }, card = card }
      end
    end
    if context.joker_main then
      return { chips = card.ability.extra.chips, mult = card.ability.extra.mult, xmult = card.ability.extra.x_mult, x_chips = card.ability.extra.x_chips }
    end
  end
}
