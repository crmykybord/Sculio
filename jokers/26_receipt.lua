SMODS.Joker {
  key = 'receipt',

  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 7, y = 2 },
  cost = 6,
  eternal_compat = false,
  calculate = function(self, card, context)
    if context.selling_self and not context.blueprint then
      G.E_MANAGER:add_event(Event({
        func = (function()
          add_tag(Tag('tag_voucher'))
          play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
          play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
          return true
        end)
      }))
    end
  end
}
