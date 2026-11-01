SMODS.Enhancement {
  key = 'divine',
  atlas = 'Sculio_Enhancements',
  pos = { x = 1, y = 1 },
  prefix_config = { atlas = false },
  config = { extra = { sell_min = 1, sell_max = 2 } },
  loc_vars = function(self, info_queue, card)
    local extra = self.config.extra
    return { vars = { extra.sell_min, extra.sell_max } }
  end,
  calculate = function(self, card, context)
    if not (context.main_scoring and context.cardarea == G.play) then return end
    if card.repetition_trigger then return end
    local extra = card.ability.extra or self.config.extra
    local hand = G.GAME.current_round.hands_played

    local pool = {}
    for _, j in ipairs(G.jokers.cards) do
      if not j.gone and not j.debuff then pool[#pool + 1] = j end
    end
    if #pool == 0 then return end
    local salt = 'sculio_divine' .. tostring(hand) .. '_' .. tostring(card.playing_card or card.id)
    local target = pool[math.floor(pseudoseed(salt .. '_joker') * #pool) + 1]
    local amount = extra.sell_min
      + math.floor(pseudoseed(salt .. '_amount') * (extra.sell_max - extra.sell_min + 1))
    G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.4, func = function()
      if target and not target.gone then
        target.sell_cost = target.sell_cost + amount
        target:juice_up(0.3, 0.5)
        card_eval_status_text(target, 'extra', nil, nil, nil, {
          message = localize { type = 'variable', key = 'k_Sculio_plus_sell', vars = { amount } },
          colour = G.C.MONEY,
        })
      end
      return true
    end }))
  end,
}
