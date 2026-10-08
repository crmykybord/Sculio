if CardSleeves then
  local function is_paired(self)
    return self.get_current_deck_key() == 'b_Sculio_mint'
  end

  CardSleeves.Sleeve {
    key = 'mint',
    atlas = 'Sculio_Sleeves',
    pos = { x = 2, y = 0 },
    config = { no_interest = true, extra = { sell_value = 2 } },
    loc_vars = function(self)
      local key = is_paired(self) and 'sleeve_Sculio_mint_alt' or nil
      return { key = key, vars = { self.config.extra.sell_value } }
    end,
    apply = function(self)
      CardSleeves.Sleeve.apply(self)
    end,
    calculate = function(self, sleeve, context)
      if context.end_of_round and context.main_eval and context.beat_boss
          and not context.game_over and not context.blueprint and is_paired(self)
          and G.jokers then
        local sellable_jokers = {}
        for _, joker in ipairs(G.jokers.cards) do
          if joker.sell_cost and joker.sell_cost > 0 then
            sellable_jokers[#sellable_jokers + 1] = joker
          end
        end
        if #sellable_jokers == 0 then return end

        local index = math.floor(pseudoseed('sculio_mint_sleeve' .. G.GAME.round_resets.ante) * #sellable_jokers) + 1
        local joker = sellable_jokers[index]
        joker.ability.extra_value = (joker.ability.extra_value or 0) + self.config.extra.sell_value
        joker:set_cost()
        return { message = localize('k_val_up'), colour = G.C.MONEY, message_card = joker }
      end
    end,
    calc_dollar_bonus = function(self)
      if is_paired(self) then return end
      return Sculio.total_joker_sell_value()
    end,
  }
end
