return {
  descriptions = {
    Mod = {
      Sculio = {
        name = 'Sculio',
        text = {
          'A vanilla-esque mod that aims to add',
          'new and faithful content to Balatro',
          '(72 Jokers, 18 Inverted Tarots, 7 Enhancements)',
          ' ',
          '{C:attention}Credits:{}',
          '{C:money}crmykybord{}: Sprite Artist',
          "{C:money}Marffe{}: Developer",
          '{C:money}BrandonE{}: Developer',
          '{C:money}chily{}: Emotional Support',
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
      undiscovered_inverted = {
        name = 'Undiscovered Inverted Tarot',
        text = {
          'Find or use this Inverted Tarot',
          'to discover it.',
        },
      },
      Sculio_refrigerable_jokers = {
        name = 'Food Jokers',
        text = {
          'Any {C:attention}Joker{} that is',
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
      sculio_inverted_seal = {
        name = 'Inverted Seal',
        text = {
          'Creates a {C:inverted}Inverted Tarot{}',
          'when {C:attention}discarded',
          '{C:inactive}(Must Have Room)',
        },
      },
      p_Sculio_inverted_normal = {
        name = 'Arcana Pack?',
        text = {
          'Choose {C:attention}#1#{} of up to',
          '{C:attention}#2# {C:inverted}Inverted Tarot{} cards',
          'to use immediately',
        },
      },
      p_Sculio_inverted_jumbo = {
        name = 'Jumbo Arcana Pack?',
        text = {
          'Choose {C:attention}#1#{} of up to',
          '{C:attention}#2# {C:inverted}Inverted Tarot{} cards',
          'to use immediately',
        },
      },
      p_Sculio_inverted_mega = {
        name = 'Mega Arcana Pack?',
        text = {
          'Choose {C:attention}#1#{} of up to',
          '{C:attention}#2# {C:inverted}Inverted Tarot{} cards',
          'to use immediately',
        },
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
          '{C:chips}chips{} equal to {C:attention}half of the number{}',
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
          '{C:attention}their rank out of #2#{} to',
          'be retriggered once'
        }
      },  
      -- 11. Handheld
      j_Sculio_handheld = {
        name = 'Handheld',
        text = {
          'Grants the last obtained {C:attention}Enhancement{}',
          'to the {C:attention}first scored card{}',
          '{C:inactive}(Currently: #1#){}',
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
          'this Joker gains the {C:attention}edition\'s bonus{}',
          '{C:inactive}(Currently {C:chips}+#1#{}{C:inactive} Chips, {C:mult}+#2#{}{C:inactive} Mult, {X:mult,C:white}X#3#{}{C:inactive} Mult)'
        },
      }, 
      -- Figurine XChips alt text (applied at runtime when an XChips edition exists)
      j_Sculio_figurine_xchips = {
        name = 'Figurine',
        text = {
          'When a Joker with an {C:attention}edition{} is sold,',
          'this Joker gains the {C:attention}edition\'s bonus{}',
          '{C:inactive}(Currently {C:chips}+#1#{}{C:inactive} Chips, {C:mult}+#2#{}{C:inactive} Mult, {X:mult,C:white}X#3#{}{C:inactive} Mult, and {X:chips,C:white}X#4#{}{C:inactive} Chips)',
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
      -- 16. Reach
      j_Sculio_reach = {
        name = 'Reach',
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
      -- 22. Restroom Sign
      j_Sculio_signage = {
        name = 'Restroom Sign',
        text = {
          'Only {C:attention}Jokers{} will',
          'appear in the shop',
          "{C:inactive,s:0.8}Does not interfere with Vouchers{}"
        },
      }, 
      -- 23. Jokerium
      j_Sculio_jokerium = {
        name = 'Jokerium',
        text = {
          'Levels up {C:planet}all hands{}',
          'when a {C:attention}Boss Blind{} is defeated',
        },
      }, 
      -- 24. Effigy
      j_Sculio_effigy = {
        name = 'Effigy',
        text = {
          'Copies ability of a random',
          '{C:attention}compatible Joker{} during hand',
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
          'cannot {C:attention}decay{} or {C:attention}expire{}',
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
          'Scored cards have a',
          '{C:green}#1# in #2#{} chance to copy the',
          'effect of {C:attention}enhanced{}',
          'cards {C:attention}held in hand{}'
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
        },
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
      -- 45. Craft Joker
      j_Sculio_craft_joker = {
        name = 'Craft Joker',
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
          'After defeating a {C:attention}Boss Blind{},',
          'grants a random {C:attention}Enhancement{},',
          '{C:attention}Seal{} or {C:dark_edition}Edition{} to {C:attention}#1#{} cards',
          'in your deck that have none'
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
      -- 50. Jokes against Humanity
      j_Sculio_jokes_against_humanity = {
        name = 'Jokes Against Humanity',
        text = {
          '{X:mult,C:white}X#1#{} Mult',
          '{C:green}#2# in #3#{} chance to {C:attention}debuff{}',
          '2 random Jokers before each hand'
        },
      },
      -- 51. Letter Tile
      j_Sculio_letter_tile = {
        name = 'Letter Tile',
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
          'When {C:attention}High Card{} is played,',
          'gains {C:mult}+#1#{} Mult per previous',
          '{C:attention}High Card{} played',
          '{C:inactive}(Currently {C:mult}+#2#{}{C:inactive} Mult)'
        },
      },
      -- 54. Sheriff
      j_Sculio_sheriff = {
        name = 'Sheriff',
        text = {
          '{X:mult,C:white}X#1#{} Mult for each',
          '{C:attention}Boss Blind{} defeated',
          '{C:inactive}(Currently {X:mult,C:white}X#2#{}{C:inactive} Mult)',
        },
      },
      -- 55. Computer Virus
      j_Sculio_computer_virus = {
        name = 'Computer Virus',
        text = {
          'After defeating a {C:attention}Boss Blind{},',
          'destroy the {C:attention}rightmost{} Joker',
          'and create a {C:common}Common Joker{}',
          'with {C:dark_edition}Negative{} or {C:dark_edition}Polychrome{}'
        },
      },
      -- 56. Manilla Folder
      j_Sculio_manilla_folder = {
        name = 'Manilla Folder',
        text = {
          'When playing a {C:attention}Secret Hand{},',
          'fill empty consumable slots with',
          '{C:attention}random consumables{}',
          '{C:inactive}(Must have room){}',
        },
      },
      -- 57. Nonogram Joker
      j_Sculio_nonogram_joker = {
        name = 'Nonogram Joker',
        text = {
          'Scored cards give alternating',
          '{C:chips}+#1#{} Chips and {C:mult}+#2#{} Mult',
        },
      },
      -- 58. Telephone
      j_Sculio_telephone = {
        name = 'Telephone',
        text = {
          'Scored {C:attention}#1#s{} trigger',
          '{C:attention}one additional time{}',
          '{C:inactive,s:0.8}Changes each round{}',
        },
      },
      -- 59. Joker of Nothing
      j_Sculio_joker_of_nothing = {
        name = 'Joker of Nothing',
        text = {
          'Scored {C:attention}Kings{} give {X:mult,C:white}X#1#{} Mult',
          'for each {C:attention}missing rank{} in deck',
          '{C:inactive}(#2# missing ranks, {}{X:mult,C:white}X#3#{}{C:inactive} Mult)',
        },
      },
      -- 60. Game Package
      j_Sculio_game_package = {
        name = 'Game Package',
        text = {
          '{C:attention}2s{} and {C:attention}4s{} in held hand',
          'give {X:mult,C:white}X#1#{} Mult per played card',
        },
      },
      -- 61. Lost Keys
      j_Sculio_lost_keys = {
        name = 'Lost Keys',
        text = {
          'After defeating any {C:attention}Blind{},',
          'shop has {C:attention}#1# free{}',
          '{C:attention}booster packs{}',
        },
      },
      -- 62. Gun Target
      j_Sculio_gun_target = {
        name = 'Gun Target',
        text = {
          'Earn {C:money}$#1#{} when',
          'defeating a {C:attention}Small Blind{}',
        },
      },
      -- 63. ECG Joker
      j_Sculio_ecg = {
        name = 'ECG Joker',
        text = {
          'If you run out of hands, grants',
          '{C:blue}+1{} hand and {C:red}+1{} discard',
          '{C:inactive}(Once per round){}',
        },
      },
      -- 64. Test Dummy
      j_Sculio_test_dummy = {
        name = 'Test Dummy',
        text = {
          'Gains {X:chips,C:white}X#1#{} Chips for',
          'each destroyed {C:attention}Glass Card{}',
          '{C:inactive}(Currently {X:chips,C:white}X#2#{}{C:inactive} Chips)',
        },
      },
      -- 65. The Joker is Watching
      j_Sculio_joker_watching = {
        name = 'The Joker is Watching',
        text = {
          '{C:attention}Retriggers{} scored cards',
          'if a {C:attention}King{} is held in hand',
        },
      },
      -- 66. LED Joker
      j_Sculio_led = {
        name = 'LED Joker',
        text = {
          'Gains {C:mult}+#2#{} Mult for each',
          '{C:attention}card{} bought in the shop',
          '{C:inactive}(Currently {C:mult}+#1#{}{C:inactive} Mult)',
        },
      },
      -- 67. Blue Comet
      j_Sculio_blue_comet = {
        name = 'Blue Comet',
        text = {
          'After defeating a {C:attention}Boss Blind{},',
          '{C:planet}levels{} up your most',
          '{C:attention}played hand{}',
        },
      },
      -- 68. Dong Fang
      j_Sculio_dong_fang = {
        name = 'Dong Fang',
        text = {
          'Gains {C:mult}+#2#{} Mult for each',
          'discarded {C:attention}Wandering Card{}',
          '{C:inactive}(Currently {C:mult}+#1#{}{C:inactive} Mult)',
        },
      },
      -- 69. Pipe Dream
      j_Sculio_pipe_dream = {
        name = 'Pipe Dream',
        text = {
          'Scored cards have a',
          '{C:green}#1# in #2#{} chance to give',
          '{C:chips}+#3#{} Chips',
        },
      },
      -- 70. Autopsy Form
      j_Sculio_autopsy_form = {
        name = 'Autopsy Form',
        text = {
          'Gains {C:mult}+#2#{} Mult for each',
          'destroyed {C:attention}enhanced card{}',
          'Loses {C:mult}-#3#{} Mult per hand played',
          '{C:inactive}(Currently {C:mult}+#1#{}{C:inactive} Mult)',
        },
      },
      -- 71. Manuscript
      j_Sculio_manuscript = {
        name = 'Manuscript',
        text = {
          'Gains {C:chips}+#2#{} Chips each time',
          'a {C:attention}Profane Card{} scores',
          '{C:inactive}(Currently {C:chips}+#1#{}{C:inactive} Chips)',
        },
      },
      -- 72. Cartomancer?
      j_Sculio_cartomante = {
        name = 'Cartomancer?',
        text = {
          'Creates a random {C:inverted}Inverted Tarot{}',
          'when selecting a Blind',
          '{C:inactive}(Must have room){}',
        },
      },
      -- 100. Puck
      j_Sculio_puck = {
        name = 'Puck',
        text = {
          'When a card with an {C:attention}edition{} is scored,',
          'this Joker gains the {C:attention}edition\'s bonus{}',
          '{C:inactive,s:0.8}(Currently {C:chips,s:0.8}+#1#{}{C:inactive,s:0.8} Chips, {C:mult,s:0.8}+#2#{}{C:inactive,s:0.8} Mult, {X:mult,C:white,s:0.8}X#3#{}{C:inactive,s:0.8} Mult)'
        }
      },
      -- Puck XChips alt text (applied at runtime when an XChips edition exists)
      j_Sculio_puck_xchips = {
        name = 'Puck',
        text = {
          'When a card with an {C:attention}edition{} is scored,',
          'this Joker gains the {C:attention}edition\'s bonus{}',
          '{C:inactive,s:0.8}(Currently {C:chips,s:0.8}+#1#{}{C:inactive,s:0.8} Chips, {C:mult,s:0.8}+#2#{}{C:inactive,s:0.8} Mult, {X:mult,C:white,s:0.8}X#3#{}{C:inactive,s:0.8} Mult, and {X:chips,C:white,s:0.8}X#4#{}{C:inactive,s:0.8} Chips)',
        }
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
    Voucher = {
      v_Sculio_inverted_merchant = {
        name = 'Tarot Forger',
        text = {
          '{C:inverted}Inverted Tarot{} cards',
          'appear in the shop',
        },
      },
      v_Sculio_inverted_tycoon = {
        name = 'Tarot Smuggler',
        text = {
          '{C:inverted}Inverted Tarot{} cards now',
          'appear in the shop,',
          '{C:attention}#1#X{} more frequently',
        },
      },
      v_Sculio_droste_effect = {
        name = 'Droste Effect',
        text = {
          '{C:inverted}Inverted Arcana Packs{} have',
          '{C:attention}1{} extra card and {C:attention}1{}',
          'extra choice',
        },
      },
      v_Sculio_distorted_flow = {
        name = 'Distorted Flow',
        text = {
          'Boosts the effects of',
          '{C:inverted}Inverted Tarots{}. Check each',
          'one for its specific upgrade',
        },
      },
    },
    Back = {
      b_Sculio_cetonic = {
        name = 'Cthonic Deck',
        text = {
          '{C:tarot}Arcana Packs{} no longer',
          'appear in the shop',
          'Start with {T:v_Sculio_inverted_merchant,C:attention}Tarot Forger{}',
        },
      },
    },
    Enhanced = {
      m_Sculio_experimental = {
        name = 'Experimental Card',
        text = {
          'After scoring {C:attention}#2# times{} {C:inactive}(#1#/#2#){},',
          'creates a random {C:attention}Tag{}',
          'and becomes a {C:attention}Lead Card{}',
        },
      },
      m_Sculio_experimental_distorted_flow = {
        name = 'Experimental Card',
        text = {
          'After scoring {C:attention}#2# times{} {C:inactive}(#1#/#2#){},',
          'creates a random {C:attention}Tag{},',
          'becomes a {C:attention}Lead Card{}',
          'and pays {C:money}$15{}',
        },
      },
      m_Sculio_lead = {
        name = 'Lead Card',
        text = {
          'Stays at the bottom',
          'of your {C:attention}deck{}',
        },
      },
      m_Sculio_wandering = {
        name = 'Wandering Card',
        text = {
          'Gains {C:mult}+#1# Mult{} when discarded,',
          'discards itself when a hand is played',
        },
      },
      m_Sculio_profane = {
        name = 'Profane Card',
        text = {
          'Drains {C:chips}3 Chips{} from a card',
          'in hand and gains {C:chips}+3 Chips{}',
          'when scored',
          '{C:inactive,s:0.8}(Cannot drain other Profane cards)',
        },
      },
      m_Sculio_profane_distorted_flow = {
        name = 'Profane Card',
        text = {
          'Gains {C:chips}+7 Chips{} when scored',
          'without draining any card',
        },
      },
      m_Sculio_punched = {
        name = 'Punched Card',
        text = {
          '{X:mult,C:white}X#1#{} Mult when scored,',
          'destroyed when discarded',
        },
      },
      m_Sculio_smeared = {
        name = 'Smeared Card',
        text = {
          {
            '{X:mult,C:white}X1.75{} Mult before',
            'and after the hand is played',
          },
          {
            '{C:red}Self-destructs{}',
            'if played with another',
            'Smeared Card',
          },
        },
      },
      m_Sculio_phalanx = {
        name = 'Phalanx Card',
        text = {
          'Grants {X:mult,C:white}X#1#{} Mult',
          'accumulating at the end of the hand',
        },
      },
      m_Sculio_trap = {
        name = 'Trap Card',
        text = {
          'When this card is {C:attention}#1#{},',
          'it triggers:',
          '#2#',
        },
      },
      m_Sculio_divine = {
        name = 'Divine Card',
        text = {
          'While held in hand, scoring cards',
          'get {C:chips}+7 Chips{} or {C:mult}+3 Mult{}.',
          'Alternates its mode between hands',
        },
      },
      m_Sculio_siege = {
        name = 'Siege Card',
        text = {
          'No rank or suit,',
          'cannot be debuffed',
          'Earns {C:money}$#1#, $#2# or $#3#{} if part of',
          'the hand that defeats the Blind',
          '{C:inactive}(Small, Big, Boss Blind){}',
        },
      },
    },
    Spectral = {
      c_Sculio_snuff = {
        name = 'Snuff',
        text = {
          'Add a {C:inverted}Inverted Seal{}',
          'to {C:attention}1{} selected',
          'card in your hand',
        },
      },
      c_Sculio_transfix = {
        name = 'Transfix',
        text = {
          'Enhance {C:attention}3{} selected cards',
          'into {C:attention}Punched Cards{}',
        },
      },
    },
    Inverted = {
      c_Sculio_sane = {
        name = 'The Sane',
        text = {
          'Copies the last {C:inverted}Inverted Tarot{} used',
          '{C:inactive}(Currently: #1#){}',
          'Copies it {C:attention}x#2#{}; if it were to copy itself,',
          'it becomes {C:attention}The Fool{} instead',
        },
      },
      c_Sculio_sane_distorted_flow = {
        name = 'The Sane',
        text = {
          'Copies the last {C:inverted}Inverted Tarot{} used',
          '{C:inactive}(Currently: #1#){}',
          'Copies it {C:attention}x#2#{} and also creates',
          'a copy of its counterpart {C:attention}#3#{}',
        },
      },
      c_Sculio_scholar = {
        name = 'The Scholar',
        text = {
          'Enhances {C:attention}#1#{} selected cards',
          'into {C:attention}Experimental Cards{}',
        },
      },
      c_Sculio_scholar_distorted_flow = {
        name = 'The Scholar',
        text = {
          'Enhances {C:attention}#1#{} selected cards into',
          '{C:attention}Experimental Cards{} that activate at',
          '{C:attention}5{} and pay {C:money}$15{}',
        },
      },
      c_Sculio_secularist = {
        name = 'The Secularist',
        text = {
          'Levels up between {C:attention}#1#{} and',
          '{C:attention}#2#{} random Poker Hands',
        },
      },
      c_Sculio_exiled = {
        name = 'The Exiled',
        text = {
          'Enhances {C:attention}#1#{} selected cards',
          'into {C:attention}Wandering Cards{}',
        },
      },
      c_Sculio_regicide = {
        name = 'Regicide',
        text = {
          'Creates up to {C:attention}#1#{} random',
          '{C:inverted}Inverted Tarot{} cards',
          '{C:inactive}(Must have room){}',
        },
      },
      c_Sculio_regicide_distorted_flow = {
        name = 'Regicide',
        text = {
          'Creates up to {C:attention}#1#{} random',
          '{C:inverted}Inverted Tarot{} cards',
          '{C:inactive}(Ignores Consumable slots){}',
        },
      },
      c_Sculio_apostate = {
        name = 'The Apostate',
        text = {
          'Enhances {C:attention}#1#{} selected cards',
          'into {C:attention}Profane Cards{}',
        },
      },
      c_Sculio_apostate_distorted_flow = {
        name = 'The Apostate',
        text = {
          'Enhances {C:attention}#1#{} selected cards',
          'into {C:attention}Profane Cards{} that gain',
          '{C:chips}+7 Chips{} without draining',
        },
      },
      c_Sculio_adversaries = {
        name = 'The Adversaries',
        text = {
          'Enhances {C:attention}#1#{} cards',
          'into {C:attention}Smeared Cards{}',
        },
      },
      c_Sculio_pikeman = {
        name = 'The Pikeman',
        text = {
          'Enhances {C:attention}#1#{} selected cards',
          'into a {C:attention}Phalanx Card{}',
        },
      },
      c_Sculio_arbitrariness = {
        name = 'Arbitrariness',
        text = {
          'Enhances {C:attention}1{} selected card',
          'into an {C:attention}Trap Card{} with a',
          'random trigger and random effect',
        },
      },
      c_Sculio_mundane = {
        name = 'The Mundane',
        text = {
          'Recovers {C:money}#1#%{} of money spent',
          'in current Ante, up to {C:money}$#2#{}',
          '{C:inactive}(Currently: $#3#){}',
        },
      },
      c_Sculio_immutable_wheel = {
        name = 'The Immutable Wheel',
        text = {
          'Activates the effect of',
          '{C:attention}#1#{} random {C:tarot}Tarot{} or {C:inverted}Inverted Tarot{}',
          'Always does something',
        },
      },
      c_Sculio_immutable_wheel_distorted_flow = {
        name = 'The Immutable Wheel',
        text = {
          'Activates the effect of {C:attention}1{} random',
          '{C:tarot}Tarot{} and {C:attention}1{} random',
          '{C:inverted}Inverted Tarot{}',
          'Always does something',
        },
      },
      c_Sculio_weakness = {
        name = 'Weakness',
        text = {
          'Decreases the rank of',
          'up to {C:attention}#1#{} selected cards by {C:attention}1{}',
        },
      },
      c_Sculio_atoned = {
        name = 'The Atoned',
        text = {
          'Copies the Enhancement from the last',
          'destroyed card onto {C:attention}#2#{} selected cards',
          '{C:inactive}(#1#){}',
        },
      },
      c_Sculio_reborn = {
        name = 'Reborn',
        text = {
          'Destroys {C:attention}1{} random card in your hand and copies',
          'one of its modifiers onto {C:attention}#2#{} random cards',
          'in your hand. Can be an Enhancement, Seal or Edition',
        },
      },
      c_Sculio_reborn_distorted_flow = {
        name = 'Reborn',
        text = {
          'Copies one modifier from a random card in your',
          'hand onto {C:attention}#1#{} random cards in your hand,',
          'without destroying it.',
          'Can be an Enhancement, Seal or Edition',
        },
      },
      c_Sculio_impatient = {
        name = 'The Impatient',
        text = {
          'Gives money based on the sell value',
          'of all Jokers and Consumables',
          'Maximum payout of {C:money}$#1#{}. Then reduces the',
          'sell value of a random Joker by {C:money}$1{}',
        },
      },
      c_Sculio_archangel = {
        name = 'The Archangel',
        text = {
          'Enhances {C:attention}1{} selected card',
          'into a {C:attention}Divine Card{}',
        },
      },
      c_Sculio_siege = {
        name = 'The Siege',
        text = {
          'Enhances {C:attention}1{} selected card',
          'into a {C:attention}Siege Card{}',
        },
      },
      c_Sculio_collapse = {
        name = 'The Collapse',
        text = {
          'For every {C:diamonds}#1# Diamonds{} in your deck,',
          'give a random card in your hand a random {C:dark_edition}Edition{}',
          '{C:inactive}(Currently: {C:dark_edition}+#2#{C:inactive} Editions){}',
        },
      },
      c_Sculio_collapse_distorted_flow = {
        name = 'The Collapse',
        text = {
          'For every {C:diamonds}#1# Diamonds{} in your deck,',
          'give a random card in your hand a random {C:dark_edition}Edition{}',
          '{C:inactive}(Currently: {C:dark_edition}+#2#{C:inactive} Editions){},',
          'affected cards pay {C:money}$1{} when scored',
        },
      },
      c_Sculio_eclipse = {
        name = 'The Eclipse',
        text = {
          'For every {C:clubs}10 Clubs{} in your deck,',
          'cards held in hand permanently gain',
          '{C:mult}+#3# Mult{}',
          '{C:inactive}(Currently: {C:red}+#2#{C:inactive} Mult){}',
        },
      },
      c_Sculio_twilight = {
        name = 'The Twilight',
        text = {
          'For every {C:hearts}10 Hearts{} in your deck,',
          '{C:attention}#3#{} random cards in your hand receive',
          'random Enhancements',
          '{C:inactive}(Currently: {C:attention}#2#{C:inactive} Enhancements){}',
        },
      },
      c_Sculio_twilight_distorted_flow = {
        name = 'The Twilight',
        text = {
          'For every {C:hearts}10 Hearts{} in your deck,',
          '{C:attention}#3#{} random cards in your hand receive',
          'random Enhancements, each with a',
          '{C:attention}1 in 6{} chance to gain a Seal',
          '{C:inactive}(Currently: {C:attention}#2#{C:inactive} Enhancements){}',
        },
      },
      c_Sculio_cave = {
        name = 'The Cave',
        text = {
          'For every {C:spades}10 Spades{} in your deck,',
          'cards held in hand permanently gain',
          '{C:chips}+#3# Chips{}',
          '{C:inactive}(Currently: {C:blue}+#2#{C:inactive} Chips){}',
        },
      },
      c_Sculio_mercy = {
        name = 'Mercy',
        text = {
          'Creates a {C:dark_edition}Negative{}#2# copy',
          'of the last Joker sold',
          '{C:inactive}(Currently: #1#){}',
          'The copy has {C:money}$0{} sell value',
        },
      },
      c_Sculio_mercy_distorted_flow = {
        name = 'Mercy',
        text = {
          'Creates a {C:dark_edition}Negative{} copy of the last',
          'Joker sold, and also a random {C:dark_edition}Negative{}',
          '{C:attention}Perishable{} Joker',
          '{C:inactive}(Currently: #1#){}',
          'Both copies have {C:money}$0{} sell value',
        },
      },
    },
  },
  misc = {
    dictionary = {
      k_Sculio_binary_scale_chips = '01000011',
      k_Sculio_binary_scale_mult = '01001101',
      k_Sculio_crime_scene = '+Mult!',
      k_Sculio_crooked_stole = 'Stole $#1#',
      k_Sculio_crooked_bailed = 'Stole $#1#, bailed!',
      k_Sculio_mad_scientist_spawn = 'Science!',
      k_Sculio_beyond_reach_saved = 'It was not beyond reach!',
      k_Sculio_cloning_vat_active = 'Cloned!',
      k_Sculio_sticky_keys_changed = 'Mult Changed!',
      k_Sculio_bad_trip_randomized = 'Deck randomized!',
      k_Sculio_ecg_discard = '+1 Discard',
      k_Sculio_compatible = 'Compatible',
      k_Sculio_incompatible = 'Incompatible',
      k_Sculio_none = 'None',
      k_Sculio_plus_inverted = '+1 Inverted Tarot',
      k_inverted = 'Inverted Tarot',
      Sculio_perishable_suffix = ', Perishable',
      b_inverted_cards = 'Inverted Tarots',
      k_booster_group_sculio_inverted = 'Inverted Arcana Packs',
      Sculio_trap_unknown_trigger = 'rolled',
      Sculio_trap_unknown_effect = 'A random effect from weighted rarity pools',
      Sculio_trap_played = 'played',
      Sculio_trap_scored = 'scored',
      Sculio_trap_discarded = 'discarded',
      Sculio_trap_held = 'held in hand',
      Sculio_trap_destroyed = 'destroyed',
      Sculio_trap_chips75 = '{C:chips}+75 Chips{}',
      Sculio_trap_mult20 = '{C:mult}+20 Mult{}',
      Sculio_trap_dollars5 = '{C:money}$5{}',
      Sculio_trap_draw2 = 'Draws {C:attention}2{} cards',
      Sculio_trap_xmult175 = '{X:mult,C:white}X1.75{} Mult',
      Sculio_trap_xchips15 = '{X:chips,C:white}X1.5{} Chips',
      Sculio_trap_create_tarot = 'Creates a random {C:tarot}Tarot{}',
      Sculio_trap_create_planet = 'Creates a random {C:planet}Planet{}',
      Sculio_trap_enhance = 'Applies a random Enhancement to a random card',
      Sculio_trap_seal = 'Applies a random Seal to a random card',
      Sculio_trap_buff_others = 'Gives {C:mult}+4 Mult{} to up to 2 other cards in hand',
      Sculio_trap_reduce_blind = 'Reduces the Blind by {C:attention}5%{}',
      Sculio_trap_spectral_draw = 'Creates a random {C:spectral}Spectral{} and draws {C:attention}2{} cards',
      Sculio_trap_protect_xmult = 'Adjacent cards cannot be debuffed, and {X:mult,C:white}X1.75{} Mult',
      Sculio_trap_seal_buff = 'Applies a random Seal and gives {C:mult}+4 Mult{} to other cards',
    },
    labels = {
      inverted = 'Inverted Tarot',
      sculio_inverted_seal = 'Inverted Seal',
    },
  },
}
