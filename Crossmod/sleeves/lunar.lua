if CardSleeves then
  local function is_paired(self)
    return self.get_current_deck_key() == 'b_Sculio_lunar'
  end

  CardSleeves.Sleeve {
    key = 'lunar',
    atlas = 'Sculio_Sleeves',
    pos = { x = 1, y = 0 },
    config = { extra = { numerator = 1, denominator = 6, levels = 1 } },
    loc_vars = function(self)
      local extra = self.config.extra
      local numerator, denominator = SMODS.get_probability_vars(self, extra.numerator, extra.denominator, 'sculio_lunar_sleeve')
      local key = is_paired(self) and 'sleeve_Sculio_lunar_alt' or nil
      return { key = key, vars = { numerator, denominator } }
    end,
    calculate = function(self, sleeve, context)
      if not is_paired(self) then Sculio.add_lunar_pack_to_shop(context) end

      local extra = self.config.extra
      if is_paired(self) and context.before and context.scoring_name
          and G.GAME.hands[context.scoring_name]
          and SMODS.pseudorandom_probability(self, 'sculio_lunar_sleeve', extra.numerator, extra.denominator, 'sculio_lunar_sleeve') then
        local hand = context.scoring_name
        local eff_card = context.blueprint_card or sleeve
        update_hand_text({ sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3 },
          { handname = localize(hand, 'poker_hands'), chips = G.GAME.hands[hand].chips,
            mult = G.GAME.hands[hand].mult, level = G.GAME.hands[hand].level })
        level_up_hand(eff_card, hand, false, extra.levels)
        update_hand_text({ sound = 'button', volume = 0.7, pitch = 1.1, delay = 0 },
          { mult = 0, chips = 0, handname = '', level = '' })
      end
    end,
  }
end
