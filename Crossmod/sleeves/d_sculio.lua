if CardSleeves then
  local function is_paired(self)
    return self.get_current_deck_key() == 'b_Sculio_sculio'
  end

  CardSleeves.Sleeve {
    key = 'sculio',
    atlas = 'Sculio_Sleeves',
    pos = { x = 0, y = 0 },
    config = { extra = { joker_weight = 3, dollars = 10 } },
    loc_vars = function(self)
      local key = is_paired(self) and 'sleeve_Sculio_sculio_alt' or nil
      return { key = key, vars = { self.config.extra.joker_weight, self.config.extra.dollars } }
    end,
    calculate = function(self, sleeve, context)
      if not is_paired(self) then
        Sculio.modify_joker_weights(context, self.config.extra.joker_weight)
      end
    end,
    apply = function(self)
      if not is_paired(self) then return end

      local extra = self.config.extra
      G.GAME.starting_params.dollars = G.GAME.starting_params.dollars + extra.dollars
      G.GAME.used_vouchers.v_overstock_norm = true
      G.GAME.starting_voucher_count = (G.GAME.starting_voucher_count or 0) + 1
      G.E_MANAGER:add_event(Event({
        func = function()
          Card.apply_to_run(nil, G.P_CENTERS.v_overstock_norm)
          return true
        end,
      }))
    end,
  }
end
