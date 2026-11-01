SMODS.Joker {
  key = 'cutout',
  attributes = { 'xmult', 'joker_slot' },
  config = { extra = { x_mult = 0.5 } },
  unlocked = true,
  discovered = false,
  rarity = 3, -- Rare
  atlas = 'Sculio',
  pos = { x = 2, y = 1 },
  pixel_size = { w = 43, h = 61 },
  set_sprites = function(self, card)
    local sprite = card.children and card.children.center
    if not sprite or not sprite.sprite_pos then return end
    if sprite.sprite_pos.x ~= self.pos.x or sprite.sprite_pos.y ~= self.pos.y then return end
    sprite:set_sprite_pos({ x = self.pos.x + 13 / 71, y = self.pos.y + 1 / 95 })
  end,
  cost = 8,
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  get_x_mult_mod = function(self)
    if G.jokers and #G.jokers.cards > 1 then
      return 1 + (self.config.extra.x_mult * (#G.jokers.cards - 1))
    else
      return 1
    end
  end,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.x_mult, self:get_x_mult_mod() } }
  end,
  calculate = function(self, card, context)
    local x_mult_mod = self:get_x_mult_mod()

    if context.joker_main and x_mult_mod > 1 then
      return { xmult = x_mult_mod }
    end
  end
}
