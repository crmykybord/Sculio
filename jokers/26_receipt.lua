SMODS.Joker {
  key = 'receipt',
  attributes = { 'on_sell', 'generation', 'tag' },
  eternal_compat = false,
  blueprint_compat = false,
  perishable_compat = false,
  rental_compat = true,
  unlocked = true,
  discovered = false,
  rarity = 1, -- Common
  atlas = 'Sculio',
  pos = { x = 7, y = 2 },
  pixel_size = { w = 53, h = 87 },
  set_sprites = function(self, card)
    local sprite = card.children and card.children.center
    if not sprite or not sprite.sprite_pos then return end
    if sprite.sprite_pos.x ~= self.pos.x or sprite.sprite_pos.y ~= self.pos.y then return end
    sprite:set_sprite_pos({ x = self.pos.x + 9 / 71, y = self.pos.y + 1 / 95 })
  end,
  cost = 6,
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
