-- Golden version of the Unstoppable Force tag.
-- Cross-mod with All in Jest
local GOLD_COPIES = 5

SMODS.Tag {
  key = 'visionary_gold',
  atlas = 'Sculio_Tags',
  pos = { x = 3, y = 0 },
  config = { aij = { upgrade = 'Sculio_visionary' } },
  attributes = { 'tarot', 'editions' },
  min_ante = 1,
  in_pool = function(self, args)
    return args and type(args.source) == 'string' and args.source:sub(-5) == '_gold'
  end,
  -- Only exists as an All in Jest golden tag.
  no_collection = function(self, args)
    return not (SMODS.find_mod('allinjest') and SMODS.find_mod('allinjest')[1])
  end,
  apply = function(self, tag, context)
    if context.type ~= 'new_blind_choice' then return end
    -- Depends on All in Jest's card-choice collection UI.
    if not (SMODS.jest_no_back_card_collection_UIBox and jest_create_select_card_ui) then return end

    tag:yep('+', G.C.SECONDARY_SET.Inverted, function()
      G.E_MANAGER:add_event(Event({
        func = function()
          G.SETTINGS.paused = true
          G.FUNCS.overlay_menu {
            config = { no_esc = true },
            definition = SMODS.jest_no_back_card_collection_UIBox(
              G.P_CENTER_POOLS.Inverted,
              { 5, 6 },
              {
                no_materialize = true,
                modify_card = function(card, center)
                  if card.config.center.discovered then
                    if G.GAME.banned_keys[card.config.center.key]
                        and not (type(G.GAME.banned_keys[card.config.center.key]) == 'string'
                          and G.GAME.banned_keys[card.config.center.key]:sub(1, 5) == 'j_aij') then
                      card.debuff = true
                    else
                      card:set_edition({ negative = true }, true, true)
                      jest_create_select_card_ui(card, G.consumeables, { copies = GOLD_COPIES })
                    end
                  end
                end,
                h_mod = 1.05,
              }
            ),
          }
          return true
        end
      }))
      G.E_MANAGER:add_event(Event({
        func = function()
          for i = 1, #G.GAME.tags do
            if G.GAME.tags[i]:apply_to_run({ type = 'new_blind_choice' }) then break end
          end
          return true
        end
      }))
      return true
    end)
    tag.triggered = true
    return true
  end,
}
