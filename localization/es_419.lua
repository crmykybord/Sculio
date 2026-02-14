return {
  descriptions = {
    Mod = {
      Sculio = {
        name = 'Sculio',
        text = {
          'Un Mod Vanilla que busca agregar',
          'contenido nuevo a Balatro que se sienta',
          'como el original',
          '(¡Tenemos 45 Comodines y una Etiqueta!)',
          ' ',
          '{C:attention}Créditos:{}',
          '{C:money}crmykybord{}: Dibujo y Diseño',
          '{C:money}BrandonE{}: Desarrollador',
          '{C:money}chily{}: Ideas & Balance',
          '{C:money}Marffe{}: Ideas y Archivos de Traducción',
          ' ',
          '{C:attention}Agradecimientos especiales (Ideas):{}',
          '{C:inactive}u/Spicy_burritos (Dunce Artwork + Concept), u/The_Math_Hatter,',
          '{C:inactive}u/Different_Ad2722, u/reilywalker195, u/Geekazoid213, u/CraftyCreeper64,',
          '{C:inactive}u/Jazzlike_Spirit_9943, u/Lazy_Tutor9447, Valunar, u/DrBacon27,',
          '{C:inactive}u/mysterygift17, u/-Error-69, u/charsol1545, u/santh91, u/TheFunny64074,',
          '{C:inactive}u/Any_Thanks, u/zapirate_2020, isaaciscrying, u/manurosadilla,',
          '{C:inactive}Soup_can54, HumanDactyl, __Heavy_Water, Toasty, Glamdring',
        }
      }
    },
    Other = {
      Sculio_refrigerable_jokers = {
        name = 'Comodines Refrigerables',
        text = {
          '{C:attention}Helado{}, {C:attention}Refresco{}, {C:attention}Ramen{},',
          '{C:attention}Palomitas de maíz{} y {C:attention}Frijol Negro{}'
        }
      },
      Sculio_ailments = {
        name = 'Enfermedades',
        text = {
          'Los Stickers {C:attention}Eterno{},',
          '{C:attention}Perecedero{} y {C:attention}Alquiler{}'
        }
      },
    },
    Joker = {
      -- 1. Schrödinger's Joker
      j_Sculio_schrodinger = { 
        name = '{s:0.8}Comodín de Schrödinger{}',
        text = {
          'Prob. de {C:green}#1# en #2#{} de',
          'otorgar {X:mult,C:white}X#3#{} Multi'
          },
        },
      -- 2. Impossible Stairs
      j_Sculio_impossible_stairs = { 
        name = 'Escaleras Imposibles',
        text = {
          'Este comodín gana entre {C:mult}+#3#{}',
          'y {C:mult}#2#{} Multi por mano jugada.',
          'Se {C:red}destruye{} si el Multi llega a {C:mult}+#4#{}',
          '{C:inactive}(Actualmente {C:mult}+#1#{}{C:inactive} Multi)'
          },
        },
      -- 3. House Party
      j_Sculio_house_party = {
        name = 'Fiesta en Casa',
        text = {
          'Gana {X:mult,C:white}X#2#{} Multi por cada',
          'mano que contenga un {C:attention}Full House{}',
          'que hayas anotado {C:attention}consecutivamente{}',
          '{C:inactive}(Actualmente {X:mult,C:white}X#1#{}{C:inactive} Multi)',
          },
      },
      -- 4. Verified User
      j_Sculio_verified = {
        name = 'Usuario Verificado',
        text = {
          'Las cartas con {C:blue}Sello Azul{}',
          'salen primero de la baraja'
        },
      },
      -- 5. Schrödinger's Joker
      j_Sculio_stonks = {
        name = 'Comodín Inversionista',
        text = {
          'El {C:mult}+Multi{} de este comodín se',
          '{C:attention}duplica{} después de cada ciega jefe',
          '{C:inactive}(Actualmente {C:mult}+#1#{}{C:inactive} Multi)'
        },
      },
      -- 6. Gold ore
      j_Sculio_gold_ore = {
        name = 'Oro Bruto',
        text = {
          'Las {C:attention}Cartas de Piedra{}',
          'anotadas ganan un {C:attention}Sello de oro{}'
        },
      },
      -- 7. Pop Star
      j_Sculio_pop_star = {
        name = 'Estrella Pop',
        text = {
          'Prob. de {C:green}#1# en #2#{} de otorgar',
          'una {C:attention}mejora al azar{}',
          'a las {C:attention}cartas amotadas{},',
        },
      },
      -- 8. Addiction
      j_Sculio_addiction = {
        name = 'Adicción',
        text = {
          'Si juegas tu {C:attention}mano más jugada{},',
          'cada {C:attention}carta{} anotada gana {C:chips}fichas{}',
          'iguales a la {C:attention}mitad de veces que{}',
          '{C:attention}haya jugado la mano{}'
        },
      },      
      -- 9. Gumball Machine
      j_Sculio_gumball = {
        name = 'Maquina de Chicle',
        text = {
          '{C:mult}+#2#{} Multi al abrir {C:attention}paquetes potenciadores{}',
          '{C:mult}#3#{} Multi al saltar {C:attention}paquetes potenciadores{}',
          'Se destruye al llegar a {C:mult}+#4#{} Multi',
          '{C:inactive}(Actualmente {C:mult}+#1#{}{C:inactive} Multi)'
        },
      },
      -- 10. Anatomy
      j_Sculio_anatomy = {
        name = 'Anatomía',
        text = {
          'Cada {C:attention}carta de número{} tiene',
          'una prob. {C:green}igual a su valor{}',
          'de reactivarse'
        }
      },  
      -- 11. Handheld
      j_Sculio_handheld = {
        name = 'Juego Retro',
        text = {
          'Todas las cartas se consideran',
          '{C:attention}Cartas Versátiles{}'
        },
      }, 
      -- 12. Crime Scene
      j_Sculio_crime_scene = {
        name = 'Escena del Crimen',
        text = {
          'Si la {C:attention}primera mano{} de la ronda',
          'es {C:attention}1{} carta, el comodín gana',
          'la {C:attention}mitad{} de las {C:attention}fichas base{}',
          'de la carta notado como multi ',
          '{C:inactive}(Actualmente {C:mult}+#1#{}{C:inactive} Multi)'
        },
      }, 
      -- 13. Joker Cutout
      j_Sculio_cutout = {
        name = 'Comodín Cortado',
        text = {
          '{X:red,C:white} X#1# {} Multi por cada',
          'ranura de {C:attention}Comodín{} ocupada',
          '{C:inactive}(Actualmente {X:red,C:white} X#2# {C:inactive} Multi)',
          '{C:inactive,s:0.7}(No se cuenta a si mismo)',
        },
      }, 
      -- 14. Figurine
      j_Sculio_figurine = {
        name = 'Figurita',
        text = {
          'Al vender comodines con {C:attention}edición{}, este',
          'gana las {C:attention}mejoras de la edición{}',
          '{C:inactive,s:0.8}(Actualmente {C:chips,,s:0.8}+#1#{}{C:inactive,,s:0.8} Fichas, {C:mult,,s:0.8}+#2#{}{C:inactive,,s:0.8} Multi y {X:mult,C:white,,s:0.8}X#3#{}{C:inactive,,s:0.8} Multi)'
        },
      }, 
      -- 15. Crooked Joker
      j_Sculio_crooked = {
        name = 'Comodín Mafioso',
        text = {
          '{C:attention}+#1#{} al tamaño de mano, te cobra',
          '{C:money}$#2#{} al seleccionar una ciega.',
          'te abandona si no tienes {C:money}dinero{}',
        },
      }, 
      -- 16. Beyond Reach
      j_Sculio_beyond_reach = {
        name = 'Fuera de Alcance',
        text = {
          'Previene la muerte y se {S:1.1,C:red,E:2}destruye{}.',
          'Otorga {C:blue}+#1#{} mano adicional si tu puntuación',
          'fue al menos el {C:attention}#2#%{} de lo requeriado',
        },
      },
      -- 17. Mad Scientist
      j_Sculio_mad_scientist = {
        name = 'Cientifico Loco',
        text = {
          'Al seleccionar una {C:attention}ciega{},',
          'cambia al comodín de su derecha',
          'en otro de la misma {C:attention}rareza{}',
        }
      },
      -- 18. Chicken Coupon
      j_Sculio_kfc = {
        name = 'Vale de Comida',
        text = {
        'Roba {C:money}$#2#{} del {C:attention}valor de venta{} de los',
        'otros {C:attention}comodines{} al final de la ciega y',
        'gana {X:mult,C:white}X#3#{} Multi igual al dinero {C:money}$#4#{} tomado',
        '{C:inactive}(Actualmente {X:mult,C:white}X#1#{}{C:inactive} Multi)'
        }
      },
      -- 19. Dunce
      j_Sculio_dunce = {
        name = 'Tarado',
        text = {
        'Copia la habilidad del comodín',
        'del {C:attention}extremo derecho{} y debilita',
        'el comodín a su {C:attention}derecha{}',
        }
      },
      -- 20. Frequent Flyer
      j_Sculio_frequent_flyer = {
        name = 'Cliente Frecuente',
        text = {
          'Cada {C:money}$#4#{} {C:inactive}[$#5#]{} gastados',
          'en la tienda, dévuelve {C:money}$#1#{}',
          'y gana {C:mult}+#3# Multi{}',
          '{C:inactive}(Actualmente {C:mult}+#2#{}{C:inactive} Multi)'
        },
      },
      -- 21. Sticky Keys
      j_Sculio_sticky_keys = {
        name = 'Comodín en Ventana',
        text = {
          'Gana {C:mult}Multi{} igual a las fichas base',
          'de la priemra carta {C:attention}anotada{},',
          'cambia cada {C:attention}#2#{} manos jugadas',
          '{C:inactive}#3# para el siguiente cambio{}',
          '{C:inactive}(Actualmente {C:mult}+#1#{}{C:inactive} Multi)',
        }
      }, 
      -- 22. Signage
      j_Sculio_signage = {
        name = 'Área de Personal',
        text = {
          'Solo aparecerán',
          '{C:attention}Comodines{} en la tienda'
        },
      }, 
      -- 23. Jokerium
      j_Sculio_jokerium = {
        name = 'Jokerium',
        text = {
          'Ganas {C:attention}#1#{} {C:spectral}Agujero negro{}',
          '{C:dark_edition}negativo{} al derrotar',
          'a la {C:attention}Ciega Jefe{}',
        },
      }, 
      -- 24. Effigy
      j_Sculio_effigy = {
        name = 'Efigie',
        text = {
          'Copia la habilidad de un',
          '{C:attention}Comodín{} al azar'
        },
      }, 
      -- 25. Bad Trip
      j_Sculio_bad_trip = {
        name = 'Mala Nota',
        text = {
          'Después {C:attention}#1#{} ronda, vende esta',
          'carta para {C:attention}aleatorizar{} {C:red}todas{}',
          'las cartas de tu baraja',
          '{C:inactive}(Actualmente {C:attention}#2#{C:inactive} / #1#)'
        },
      }, 
      -- 26. Receipt
      j_Sculio_receipt = {
          name = 'Recibo',
          text = {
          'Vende esta carta para',
          'crea una {C:attention}etiqueta de vale{}',
        },
      }, 
      -- 27. Unstoppable Force
      j_Sculio_unstoppable = {
        name = 'Fuerza Imparable',
        text = {
          'Cada que {C:attention}vendes{} este, gana',
          '{X:mult,C:white}X#2# {} Multi y este {C:attention}volverá en',
          '{C:attention}la siguiente tienda{}.',
          '{C:attention}Su valor de venta{} comienza en {C:money}$#3#{}',
          '{C:inactive}(Actualmente {X:mult,C:white} X#1# {C:inactive} Multi)',
        },
      }, 
      -- 28. Refrigerator
      j_Sculio_refrigerator = {
        name = 'Nevera',
        text = {
          'Los {C:attention}Comodines de comida{} que se',
          'coloquen a la {C:attention}dercha de este comodín{}',
          'no {C:attention}pierden valor{} ni {C:attention}expiran{}'
        },
      }, 
      -- 29. Hammer and Chisel
      j_Sculio_hammer_and_chisel = {
        name = 'Martillo y Cinsel',
        text = {
          'Las {C:attention}Cartas de Piedra{}',
          'anotadas ganan {C:chips}+#3#{} fichas',
          'y tienen una prob. de {C:green}#1# en #2#{}',
          'de {C:attention}destruirse{}',
        },
      }, 
      -- 30. Prescription
      j_Sculio_prescription = { 
        name = 'Prescripción',
        text = {
          'Después de {C:attention}#1#{} rondas, vende este',
          'comodín para {C:attention}remover{} todas las',
          '{C:attention}enfermedades{} de tus {C:attention}comodines',
          'y {C:attention}restaurar perecibles caducados{}',
          '{C:inactive}(Actualmente {C:attention}#2#{C:inactive} / #1#)'
        },
      },
      -- 31. Intuition
      j_Sculio_intuition = {
        name = 'Intuición',
        text = {
          'Las {C:attention}Cartas de Oro{} y {C:attention}Cartas de Acero{}',
          'Activan sus efectos al anotar'
        },
      }, 
      -- 32. Sensory Overload
      j_Sculio_sensory_overload = {
        name = 'Sobrecarga Sensorial',
        text = {
          'Recibes {C:money}$#1#{} cada {C:attention}#2#{} {C:inactive}[#3#]{} {C:attention}activaciones{}',
          'de otros Comodines',
        },
      }, 
      -- 33. Cloning Vat
      j_Sculio_cloning_vat = {
        name = 'Tanque de Clonación',
        text = {
          'Comprar {C:attention}Cartas{} crea',
          'una {C:attention}copia{} adicional',
          'a tu baraja'
        },
      }, 
      -- 34. Rorschach
      j_Sculio_rorschach = {
        name = 'Comodín Rorschach',
        text = {
          'Las cartas de tu primer {C:red}descarte{}',
          'serán sacadas primero en la {C:attention}siguiente ciega{}',
          'mientras este comodín{C:attention} este al extremo derecho{}',
        },
      }, 
      -- 35. Critical Failure
      j_Sculio_critical_failure = {
        name = 'Error Critico',
        text = {
          'Gana {X:mult,C:white}X#2#{} Multi cada vez',
          'que una {C:attention}carta de la suerte{}',
          '{C:red}no se activa{}, se reinicia cuando',
          'una {C:attention}carta de la suerte{} se {C:green}activa{}',
          '{C:inactive}(Actualmente {X:mult,C:white} X#1# {C:inactive} Multi)'
        },
      }, 
      -- 36. Pyromaniac
      j_Sculio_pyromaniac = {
        name = 'Piromaniaco',
        text = {
          'Si tu {C:attention}primera mano{} es tu {C:attention}mano{}',
          '{C:attention}más jugada{}, {C:planet}subes de nivel{}',
          '{C:planet}{} la mano y {C:red}destruyes{} las',
          'cartas anotadas'
        },
      }, 
      -- 37. Pharaoh
      j_Sculio_pharaoh = {
        name = 'Faraón',
        text = {
          '{C:red}Debilita{} todas las {C:attention}cartas de{}',
          '{C:attention}números{} y las {C:attention}cartas de figura{}',
          'otorgan {X:mult,C:white}X#1#{} al anotar'
        },
      }, 
      -- 38. Soup Can
      j_Sculio_soup = {
        name = 'Lata de Sopa',
        text = {
          'Gana {X:mult,C:white}X#2#{} Multi',
          'por cada {C:blue}mano{} jugada',
          '{C:attention,s:0.8}Máximo{} {X:mult,C:white,s:0.8}X#3#{} Multi',
          '{C:inactive,s:0.8}(Actualmente {X:mult,C:white,s:0.8}X#1#{}{C:inactive,s:0.8} Multi)',
        },
      }, 
      -- 39. Treachery
      j_Sculio_pipe = {
        name = 'Comodín Altanero',
        text = {
          'Después de {C:attention}#1#{} ronda, vende este',
          'comodín para otorgar edición',
          '{C:dark_edition}negativa{} a un {C:attention}comodín{} al azar',
          '{C:inactive}(Actualmente {C:attention}#2#{C:inactive} / #1#)'
        },
      }, 
      -- 40. Nametag
      j_Sculio_nametag = {
        name = 'Escarapela',
        text = {
          'Gana {X:mult,C:white}X#2#{} Multi por cada',
          'cada {C:attention}Comodín{} vendido',
          '{C:inactive}(Actualmente {X:mult,C:white} X#1# {C:inactive} Multi)'
        },
      }, 
      -- 41. Binary Joker
      j_Sculio_binary = {
        name = 'Comodín Binario',
        text = {
          'Tiene una Prob. de {C:green}#1# en #2#{} de',
          'ganar {C:chips}+#3#{} fichas y {C:mult}+#4#{} multi',
          'al seleccionar una ciega',
          '{C:inactive,s:0.8}(Actualmente {C:chips,s:0.8}+#5#{}{C:inactive,s:0.8} Chips and {C:mult,s:0.8}+#6#{} Multi)'
        },
      }, 
      -- 42. Red Dragon
      j_Sculio_mahjong = {
        name = 'Pieza de Mahjong',
        text = {
          'Gana {C:chips}+#2#{} fichas si la mano jugada',
          'contiene un {C:attention}número par de cartas{}',
          'y la {C:attention}mitad{} son menores a {C:attention}#3#{}',
          '{C:inactive}(Actualmente {C:chips}+#1#{}{C:inactive} Fichas)',
        },
      }, 
      -- 43. Auto Battle
      j_Sculio_earthbound = {
        name = 'Combate Automático',
        text = {
          'Automáticamente selecciona',
          'la {C:attention}mejor{} mano disponible'
        },
      }, 
      -- 44. 
      j_Sculio_wacky = {
        name = 'Venta de Autos',
        text = {
          'Crea una copia de {C:tarot}El Loco{} si la mano',
          'anota un {C:attention}#1#%{} de las fichas requeridas',
          '{C:inactive}(Debe haber espacio){}'
        }
      }, 
      -- 100. Puck
      j_Sculio_puck = {
        name = 'Puck',
        text = {
          'Anotar cartas con {C:attention}edición{} otorga',
          'sus {C:attention}bonificaciones{} a este comodín',
          '{C:inactive,s:0.8}(Actualmente {C:chips,s:0.8}+#1#{}{C:inactive,s:0.8} Fichas, {C:mult,s:0.8}+#2#{}{C:inactive,s:0.8} Multi y {X:mult,C:white,s:0.8}X#3#{}{C:inactive,s:0.8} Multi)'
        }
      },
    },
    Tag = {
      tag_Sculio_unstoppable = {
        name = 'Etiqueta Imparable',
        text = {
          'La tienda tiene a',
          '{C:attention}Fuerza Imparable{}',
          'con {X:mult,C:white}X#1#{} Multi'
        },
      }
    },
  }
}
