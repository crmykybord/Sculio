if CardSleeves then
  local function is_paired(self)
    return self.get_current_deck_key() == 'b_Sculio_cetonic'
  end

  CardSleeves.Sleeve {
    key = 'cetonic',
    atlas = 'Sculio_Sleeves',
    pos = { x = 3, y = 0 },
    config = { vouchers = { 'v_Sculio_droste_effect' } },
    loc_vars = function(self)
      return { key = is_paired(self) and 'sleeve_Sculio_cetonic_alt' or nil }
    end,
    apply = function(self)
      if is_paired(self) then
        CardSleeves.Sleeve.apply(self)
      else
        local back = SMODS.Back.obj_table.b_Sculio_cetonic
        if back and back.apply then back:apply(self) end
      end
    end,
  }
end
