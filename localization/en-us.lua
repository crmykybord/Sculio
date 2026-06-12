return {
  descriptions = {
    Mod = {
      Sculio = {
        name = 'Sculio',
        text = {
          'A vanilla-esque mod that aims to add',
          'new and faithful content to Balatro',
          '(Currently contains 45+ Jokers)',
          ' ',
          '{C:attention}Credits:{}',
          '{C:money}crmykybord{}: Sprite Artist',
          '{C:money}BrandonE{}: Developer',
          '{C:money}chily{}: Joker Ideas + Balancing',
          '{C:money}Marffe{}: Ideas + Loc files for translation',
          ' ',
          '{C:attention}Special Thanks (Joker Ideas):{}',
          '{C:inactive}u/Spicy_burritos (Dunce Artwork + Concept), u/The_Math_Hatter,',
          '{C:inactive}u/Different_Ad2722, u/reilywalker195, u/Geekazoid213, u/CraftyCreeper64,',
          '{C:inactive}u/Jazzlike_Spirit_9943, u/Lazy_Tutor9447, Valunar, u/DrBacon27,',
          '{C:inactive}u/mysterygift17, u/-Error-69, u/charsol1545, u/santh91, u/TheFunny64074,',
          '{C:inactive}u/Any_Thanks, u/zapirate_2020, isaaciscrying, u/manurosadilla,',
          '{C:inactive}Soup_can54, Marffe, HumanDactyl, __Heavy_Water, Toasty, Glamdring',
        }
      }
    },
    Other = {
      Sculio_refrigerable_jokers = {
        name = 'Food Jokers',
        text = {
          'Any {C:attention}Joker{} thats is',
          '{C:attention}Food{}'
        }
      },
      Sculio_ailments = {
        name = 'Ailments',
        text = {
          '{C:attention}Eternal{} and {C:attention}Perishable{},',
          'and {C:attention}Rental{} stickers'
        }
      },
    },
    Joker = {
      -- 1. Schrödinger's Joker
      j_Sculio_schrodinger = { 
        name = 'Schrödinger\'s Joker',
        text = {
          '{C:green}#1# in #2#{} chance',
          'for {X:mult,C:white}X#3#{} Mult'
          },
        },
      -- 2. Impossible Stairs
      j_Sculio_impossible_stairs = { 
        name = 'Impossible Stairs',
        text = {
          'This Joker gains between {C:mult}+#3#{}',
          'and {C:mult}#2#{} Mult per hand played',
          'Destroyed if Mult reaches {C:mult}+#4#{} Mult',
          '{C:inactive}(Currently {C:mult}+#1#{}{C:inactive} Mult)'
          },
        },
      -- 3. House Party
      j_Sculio_house_party = {
        name = 'House Party',
        text = {
          'This Joker gains {X:mult,C:white}X#2#{} Mult',
          'per {C:attention}consecutive{} hand played',
          'containing a {C:attention}Full House{}',
          '{C:inactive}(Currently {X:mult,C:white}X#1#{}{C:inactive} Mult)',
          },
      },
      -- 4. Verified User
      j_Sculio_verified = {
        name = 'Verified User',
        text = {
          'Cards with a {C:blue}Blue Seal{}',
          'get drawn first'
        },
      },
      -- 5. Schrödinger's Joker
      j_Sculio_stonks = {
        name = 'Wall Street Joker',
        text = {
          'The {C:mult}+Mult{} for this Joker',
          '{C:attention}doubles{} after every boss blind',
          '{C:inactive}(Currently {C:mult}+#1#{}{C:inactive} Mult)'
        },
      },
      -- 6. Gold ore
      j_Sculio_gold_ore = {
        name = 'Gold Ore',
        text = {
          'Scored {C:attention}Stone Cards{}',
          'gain a {C:attention}Gold Seal{}'
        },
      },
      -- 7. Pop Star
      j_Sculio_pop_star = {
        name = 'Pop Star',
        text = {
          '{C:green}#1# in #2#{} chance',
          'for {C:attention}each scored card{}',
          'to gain a {C:attention}new{},',
          '{C:attention}random enhancement{}'
        },
      },
      -- 8. Addiction
      j_Sculio_addiction = {
        name = 'Addiction',
        text = {
          'If you play your most played hand,',
          'each scored {C:attention}card{} permanently gains',
          '{C:chips}chips{} equal to {C:attention}#1#% of the number{}',
          '{C:attention}of times it has been played{}'
        },
      },      
      -- 9. Gumball Machine
      j_Sculio_gumball = {
        name = 'Gumball Machine',
        text = {
          '{C:mult}+#2#{} Mult when a {C:attention}booster pack{} is opened',
          '{C:mult}#3#{} Mult when a {C:attention}booster pack{} is skipped',
          'Destroyed if Mult reaches {C:mult}+#4#{} Mult',
          '{C:inactive}(Currently {C:mult}+#1#{}{C:inactive} Mult)'
        },
      },
      -- 10. Anatomy
      j_Sculio_anatomy = {
        name = 'Anatomy',
        text = {
          'Scored {C:attention}number cards{} have',
          '{C:green}#1#% of their rank out of #2#{}',
          'to be retriggered once'
        }
      },  
      -- 11. Handheld
      j_Sculio_handheld = {
        name = 'Handheld',
        text = {
          'All cards are treated',
          'like {C:attention}Wild Cards{}'
          -- TODO inaccurate text: for example, Extra Credit's Werewolf would not work
          -- (should be "cards have all suits", cards aren't actually wild)
        },
      }, 
      -- 12. Crime Scene
      j_Sculio_crime_scene = {
        name = 'Crime Scene',
        text = {
          'If {C:attention}first hand{} of round',
          'has only {C:attention}1{} card, this',
          'Joker\'s mult gains {C:attention}half{}',
          'of the {C:attention}card\'s base chips{}',
          '{C:inactive}(Currently {C:mult}+#1#{}{C:inactive} Mult)'
        },
      }, 
      -- 13. Joker Cutout
      j_Sculio_cutout = {
        name = 'Joker Cutout',
        text = {
          '{X:red,C:white}X#1#{} Mult for each',
          '{C:attention}other{} occupied {C:attention}Joker{} slot',
          '{C:inactive}(Currently {X:red,C:white}X#2#{C:inactive} Mult)',
        },
      }, 
      -- 14. Figurine
      j_Sculio_figurine = {
        name = 'Figurine',
        text = {
          'When a Joker with an {C:attention}edition{} is sold,',
          'this Joker gains {C:attention}#4#%{} of the {C:attention}edition\'s bonus{}',
          '{C:inactive}(Currently {C:chips}+#1#{}{C:inactive} Chips, {C:mult}+#2#{}{C:inactive} Mult, and {X:mult,C:white}X#3#{}{C:inactive} Mult)'
        },
      }, 
      -- 15. Crooked Joker
      j_Sculio_crooked = {
        name = 'Crooked Joker',
        text = {
          '{C:attention}+#1#{} hand size,',
          'steals {C:money}$#2#{} every round.',
          'Destroyed if money reaches {C:money}$#3#{}',
        },
      }, 
      -- 16. Beyond Reach
      j_Sculio_beyond_reach = {
        name = 'Beyond Reach',
        text = {
          'Prevents Death, {S:1.1,C:red,E:2}self destructs{}, and',
          'permanently gains {C:blue}+#1#{} hand if chips',
          'scored are at least {C:attention}#2#%{} of requirement.',
          'No effect if the Blind is defeated'
        },
      },
      -- 17. Mad Scientist
      j_Sculio_mad_scientist = {
        name = 'Mad Scientist',
        text = {
          'When {C:attention}Blind{} is selected,',
          'convert Joker to the right',
          'into another Joker',
          'of equal {C:attention}rarity{}'
        }
      },
      -- 18. Chicken Coupon
      j_Sculio_kfc = {
        name = 'Chicken Coupon',
        text = {
        'Steals {C:money}$#2#{} of {C:attention}sell{} value from every other',
        '{C:attention}Joker{} if available at the end of a blind',
        'Gains {X:mult,C:white}X#3#{} Mult for each {C:money}$#4#{} stolen',
        '{C:inactive}(Currently {X:mult,C:white}X#1#{}{C:inactive} Mult)'
        }
      },
      -- 19. Dunce
      j_Sculio_dunce = {
        name = 'Dunce',
        text = {
        'Copies the ability of the {C:attention}rightmost{} Joker',
        'and {C:attention}debuffs{} Joker to the right',
        'during played hand',
        '{C:inactive}(Copying: {C:attention}#1#{C:inactive} - {C:attention}#2#{C:inactive})'
        }
      },
      -- 20. Frequent Flyer
      j_Sculio_frequent_flyer = {
        name = 'Frequent Flyer',
        text = {
          'For every {C:money}$#4#{} {C:inactive}[$#5#]{} spent',
          'in shop, earn {C:money}$#1#{}',
          'and {C:mult}+#3# Mult{}',
          '{C:inactive}(Currently {C:mult}+#2#{}{C:inactive} Mult)'
        },
      },
      -- 21. Sticky Keys
      j_Sculio_sticky_keys = {
        name = 'Sticky Keys',
        text = {
          'Changes {C:mult}Mult{} to {C:attention}base chips{}',
          'of {C:attention}first scoring card{}',
          'every {C:attention}#2#{} hands played',
          '{C:inactive}#3# remaining{}',
          '{C:inactive}(Currently {C:mult}+#1#{}{C:inactive} Mult)',
        }
      }, 
      -- 22. Signage
      j_Sculio_signage = {
        name = 'Signage',
        text = {
          'Only {C:attention}Jokers{} will',
          'appear in the shop'
        },
      }, 
      -- 23. Jokerium
      j_Sculio_jokerium = {
        name = 'Jokerium',
        text = {
          'Levels up {C:planet}all hands{}',
          'when defeating a {C:attention}Boss Blind{}',
        },
      }, 
      -- 24. Effigy
      j_Sculio_effigy = {
        name = 'Effigy',
        text = {
          'Copies ability of a random',
          '{C:attention}compatible Joker{} during hand',
          '{C:inactive}(Currently copying: {C:attention}#1#{C:inactive})'
        },
      }, 
      -- 25. Bad Trip
      j_Sculio_bad_trip = {
        name = 'Bad Trip',
        text = {
          'After {C:attention}#1#{} rounds, sell this card to',
          '{C:attention}randomize{} the {C:attention}rank and suit{}',
          'of every card in deck',
          '{C:inactive}(Currently {C:attention}#2#{C:inactive} / #1#)'
        },
      }, 
      -- 26. Receipt
      j_Sculio_receipt = {
          name = 'Receipt',
          text = {
          'Sell this card to',
          'create a free',
          '{C:attention}Voucher Tag{}'
        },
      }, 
      -- 27. Unstoppable Force
      j_Sculio_unstoppable = {
        name = 'Unstoppable Force',
        text = {
          'When this Joker is {C:attention}sold{}, it',
          'gains {X:mult,C:white} X#2# {} Mult and',
          '{C:attention}returns to the next shop roll{}.',
          '{C:attention}Sell value{} starts at {C:money}$#3#{}',
          '{C:inactive}(Currently {X:mult,C:white} X#1# {C:inactive} Mult)',
        },
      }, 
      -- 28. Refrigerator
      j_Sculio_refrigerator = {
        name = 'Refrigerator',
        text = {
          '{C:attention}Food Jokers{} to the right',
          'cannot {C:attention}decay{}, {C:attention}expire{}, or be {C:red}destroyed{}',
        },
      }, 
      -- 29. Hammer and Chisel
      j_Sculio_hammer_and_chisel = {
        name = 'Hammer and Chisel',
        text = {
          'Scored {C:attention}Stone Cards{}',
          'permanently gain {C:chips}+#3#{} chips',
          'with a {C:green}#1# in #2#{} chance',
          'of {C:attention}being destroyed{}',
        },
      }, 
      -- 30. Prescription
      j_Sculio_prescription = { 
        name = 'Prescription',
        text = {
          'After {C:attention}#1#{} rounds,',
          'sell this card to {C:attention}remove{}',
          'all {C:attention}Ailments{} from all',
          '{C:attention}owned Jokers{} and',
          '{C:attention}rebuff perished Jokers{}',
          '{C:inactive}(Currently {C:attention}#2#{C:inactive} / #1#)'
        },
      },
      -- 31. Intuition
      j_Sculio_intuition = {
        name = 'Intuition',
        text = {
          'First scored {C:attention}Gold Card{} gives {C:money}$#1#{}',
          'First scored {C:attention}Steel Card{} gives {X:mult,C:white}X#2#{} Mult'
        },
      }, 
      -- 32. Sensory Overload
      j_Sculio_sensory_overload = {
        name = 'Sensory Overload',
        text = {
          'Earn {C:money}$#1#{} for every',
          '{C:attention}#2#{} {C:inactive}[#3#]{} times other',
          'Jokers are {C:attention}triggered{}'
        },
      }, 
      -- 33. Cloning Vat
      j_Sculio_cloning_vat = {
        name = 'Cloning Vat',
        text = {
          'Your {C:attention}most common rank{} appears in the',
          'shop and {C:attention}Standard Packs{} and always',
          'has at least one {C:attention}Enhancement{},',
          '{C:dark_edition}Edition{} or {C:attention}Seal{}'
        },mmmmmmm
      }, 
      -- 34. Rorschach
      j_Sculio_rorschach = {
        name = 'Rorschach',
        text = {
          'Cards in the {C:attention}first discard{} made',
          'while {C:attention}this is the rightmost Joker{}',
          'will be {C:attention}drawn first next blind{}'
        },
      }, 
      -- 35. Critical Failure
      j_Sculio_critical_failure = {
        name = 'Critical Failure',
        text = {
          'This Joker gains {X:mult,C:white} X#2# {} Mult',
          'every time a {C:attention}Lucky{} card',
          '{C:red}fails{} to trigger, resets when a',
          '{C:attention}Lucky{} card {C:green}successfully{} triggers',
          '{C:inactive}(Currently {X:mult,C:white} X#1# {C:inactive} Mult)'
        },
      }, 
      -- 36. Pyromaniac
      j_Sculio_pyromaniac = {
        name = 'Pyromaniac',
        text = {
          'If {C:attention}first hand{} of round is',
          'your {C:attention}most played hand,{}',
          '{C:attention}level up hand #1# time{} and',
          '{C:attention}destroy cards in that hand{}'
        },
      }, 
      -- 37. Pharaoh
      j_Sculio_pharaoh = {
        name = 'Pharaoh',
        text = {
          'All {C:attention}non-face cards{}',
          'are {C:attention}debuffed{}, {C:attention}face cards{}',
          'give {X:mult,C:white}X#1#{} Mult when scored'
        },
      }, 
      -- 38. Soup Can
      j_Sculio_soup = {
        name = 'Soup Can',
        text = {
          'This Joker gains {X:mult,C:white}X#2#{} Mult',
          'for {C:attention}every hand played{}.',
          '{C:attention}Maximum{} is {X:mult,C:white}X#3#{} Mult',
          '{C:inactive}(Currently {X:mult,C:white}X#1#{}{C:inactive} Mult)',
        },
      }, 
      -- 39. Treachery
      j_Sculio_pipe = {
        name = 'Treachery',
        text = {
          '{C:blue}-1 Hand{}, {C:red}-1 Discard{}',
          'After {C:attention}#1#{} rounds, sell this card to',
          'add {C:dark_edition}Negative{} to a random {C:attention}Joker{}',
          '{C:inactive}(Currently {C:attention}#2#{C:inactive} / #1#)'
        },
      }, 
      -- 40. Nametag
      j_Sculio_nametag = {
        name = 'Nametag',
        text = {
          'This Joker gains {X:mult,C:white} X#2# {} Mult',
          'every time a {C:attention}Joker{} is sold',
          '{C:inactive}(Currently {X:mult,C:white} X#1# {C:inactive} Mult)'
        },
      }, 
      -- 41. Binary Joker
      j_Sculio_binary = {
        name = 'Binary Joker',
        text = {
          'This Joker has a {C:green}#1# in #2#{} chance',
          'of obtaining {C:chips}+#3#{} Chips or {C:mult}+#4#{} Mult',
          'for each card held in hand at the end of round',
          '{C:inactive}(Currently {C:chips}+#5#{}{C:inactive} Chips and {C:mult}+#6#{} Mult)'
        },
      }, 
      -- 42. Red Dragon
      j_Sculio_mahjong = {
        name = 'Red Dragon',
        text = {
          'This Joker gains {C:chips}+#2#{} Chips if hand',
          'played contains a {C:attention}pair above 7{}',
          'and a {C:attention}pair below 7{}',
          '{C:inactive}(Currently {C:chips}+#1#{}{C:inactive} Chips)',
        },
      }, 
      -- 43. Auto Battle
      j_Sculio_earthbound = {
        name = 'Auto Battle',
        text = {
          '{X:mult,C:white}X#1#{} Mult',
          '{C:attention}Automatically{} selects the {C:attention}highest{}',
          '{C:attention}level{} hand available',
          "{C:inactive,s:0.8}(You can't select your cards){}"
        },
      }, 
      -- 44. Car Sale
      j_Sculio_wacky = {
        name = 'Car Sale',
        text = {
          'Create a copy of {C:tarot}The Fool{} if hand scores',
          'at least {C:attention}#1#%{} of required chips',
          '{C:inactive}(Must have room){}'
        }
      }, 
      -- 100. Puck
      j_Sculio_puck = {
        name = 'Puck',
        text = {
          'When a card with an {C:attention}edition{} is scored,',
          'this Joker gains {C:attention}#4#%{} of the {C:attention}edition\'s bonus{}',
          '{C:inactive}(Currently {C:chips}+#1#{}{C:inactive} Chips, {C:mult}+#2#{}{C:inactive} Mult, and {X:mult,C:white}X#3#{}{C:inactive} Mult)'
        }
      },
      -- 45. Googly Eyes
      j_Sculio_googly_eyes = {
        name = 'Googly Eyes',
        text = {
          'First scored card gives',
          'its {C:attention}base chips{} as {C:mult}Mult{}'
        },
      },
      -- 46. Pocket Money
      j_Sculio_pocket_money = {
        name = 'Pocket Money',
        text = {
          'Recover {C:money}$#1#{} on the',
          'first purchase each round'
        },
      },
      -- 47. Jimbo Says
      j_Sculio_jimbo_says = {
        name = 'Jimbo Says',
        text = {
          'First {C:attention}Flush{} of {V:1}#1#{}',
          'played each round',
          'grants a {C:attention}random tag{}',
          '{C:inactive}(Suit changes each round)'
        },
      },
      -- 48. Joker Metro
      j_Sculio_joker_metro = {
        name = 'Joker Metro',
        text = {
          'Gains {C:mult}+#2#{} Mult when',
          'playing {C:attention}#3#{} and',
          'advances to the next hand',
          '{C:inactive,s:0.8}(High Card > Pair > Two Pair > 3K',
          '{C:inactive,s:0.8}> Straight > Flush > 4K){}',
          '{C:inactive}(Currently {C:mult}+#1#{}{C:inactive} Mult)'
        },
      },
      -- 49. Gladiator Joker
      j_Sculio_gladiator = {
        name = 'Gladiator Joker',
        text = {
          'Gains {C:mult}+Mult{} equal to',
          'the {C:attention}base chips{} of',
          '{C:attention}destroyed{} cards',
          '{C:inactive}(Currently {C:mult}+#1#{}{C:inactive} Mult)'
        },
      },
      -- 50. Card Against Jokers
      j_Sculio_card_against = {
        name = 'Cards Against Jokers',
        text = {
          '{X:mult,C:white}X#1#{} Mult',
          '{C:green}1 in 3{} chance to {C:attention}debuff{}',
          '2 random Jokers before each hand'
        },
      },
      -- 51. Scrabble Joker
      j_Sculio_scrabble = {
        name = 'Scrabble Joker',
        text = {
          'Scored {C:attention}Jacks{} give',
          '{C:mult}+#1#{} Mult when scored'
        },
      },
      -- 52. Untextured Joker
      j_Sculio_untextured = {
        name = 'Untextured Joker',
        text = {
          'Scored {C:attention}Wild Cards{} give',
          '{C:mult}+#1#{} Mult for each',
          '{C:attention}Wild Card{} in your deck',
          '{C:inactive}(Currently {C:mult}+#2#{}{C:inactive} Mult)'
        },
      },
      -- 53. The Leader
      j_Sculio_leader = {
        name = 'The Leader',
        text = {
          '{C:attention}High Card{} gives',
          '{C:mult}+2{} Mult before scoring',
          'for each time it was played',
          '{C:inactive}(Currently {C:mult}+0{}{C:inactive} Mult)'
        },
      },
    },
    Tag = {
      tag_Sculio_unstoppable = {
        name = 'Unstoppable Force Tag',
        text = {
          'Shop has the Joker',
          '{C:attention}Unstoppable Force{}',
          'with {X:mult,C:white} X#1# {} Mult'
        },
      }
    },
  },
  misc = {
    dictionary = {
      k_Sculio_binary_scale_chips = '01000011',
      k_Sculio_binary_scale_mult = '01001101',
      k_Sculio_crime_scene = '+Mult!',
      k_Sculio_beyond_reach_saved = 'It was not beyond reach!',
      k_Sculio_cloning_vat_active = 'Cloned!',
      k_Sculio_compatible = 'Compatible',
      k_Sculio_incompatible = 'Incompatible',
    }
  }
}
