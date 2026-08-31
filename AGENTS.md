# Sculio-ESP — DOX

## Purpose

Fork español del mod Sculio: mod de Balatro estilo vanilla basado en SMODS. Jokers, consumibles (tipo custom `Inverted`), mejoras de carta y localización ES.

## Ownership

- Todo el contenido del mod: `Sculio.lua` (entrada), `jokers/`, `consumables/`, `enhancements/`, `libs/`, `localization/`, `assets/`.
- Los assets y la convención de atlas de este mod se documentan aquí.

## Local Contracts

- Consultar `SMODS-Wiki/AGENTS.md` antes de escribir código SMODS (regla raíz).
- Toda traducción EN→ES sigue `../TRANSLATION_RULES.md` (es_419).

## Work Guidance

- `Sculio.lua` carga `jokers/`, `consumables/`, `enhancements/` vía `load_dir`; el prefijo numérico del nombre de archivo ordena la carga.
- **Contenido desactivado temporalmente** vía `skip_files` en `Sculio.lua` (quitar entradas de la lista para reactivar). `skip_files` DEBE ser un set (`['archivo.lua'] = true`) porque `load_dir` busca por clave (`skip_files[filename]`); una lista tipo array nunca salta nada:
  - Mejoras `divine`, `siege`, `trap` (aún con placeholder del atlas vanilla `centers`, sin arte en `Enhancements.png`).
  - Tarots Invertidos: `09_arbitrariness` (La Arbitrariedad), `11_immutable_wheel` (La Rueda Inmutable), `13_the_atoned` (El Expiado), `14_reborn` (El Renacido), `15_the_impatient` (El Impaciente), `16_the_archangel` (El Arcángel), `17_the_siege` (El Asedio), `18_the_collapse` (El Colapso), `19_the_eclipse` (El Eclipse), `20_the_twilight` (El Crepúsculo), `21_the_cave` (La Cueva).
  - Al reactivar, revisar referencias cruzadas: `09_arbitrariness` usa `m_Sculio_trap` y `16_the_archangel` usa `m_Sculio_divine` (se reactivan juntos sin problema).
- **Convención de atlas**: registrar con el prefijo incluido en la key (`Sculio`, `Sculio_Tags`, `Sculio_Consumables`, `Sculio_Enhancements`) y referenciar el nombre completo en los objetos. El safeguard de `SMODS.modify_key` (Smods `src/game_object.lua:45`) no duplica el prefijo si ya empieza con `Sculio_`; por eso NO se usa `prefix_config = { atlas = false }` con atlases propios (solo con atlases vanilla como `centers`).
- **Contratos del runtime verificados contra SMODS 1814a** (dump en `lovely/dump/`):
  - El mazo roba del FINAL de `self.cards` (`CardArea:remove_card`, tipo `deck`). Prioridades "salen primero" (Verified, Rorschach) van al final del array; "se hunden al fondo" (Plomo) van al FRENTE.
  - Las fichas del rango viven en `base.nominal`; `base.chips` no existe en `Card:set_base`.
  - La aplicación de mejoras/rangos desde consumibles usa `Sculio.flip_highlighted` (secuencia de volteo vanilla estilo Emperatriz: flip → aplicar → flip, con sonidos card1/tarot2).
  - Las cartas en mano reciben `main_scoring` con `cardarea == G.hand` (vía `SMODS.calculate_main_scoring`); usar ese contexto para triggers de cartas sostenidas, no el contexto global `before`.
  - Para destruir cartas jugadas antes de anotar, responder dentro del contexto `modify_scoring_hand` (se evalúa con `in_scoring = true` por carta jugada en `state_events`; sus flags `remove_from_hand` se respetan al construir `final_scoring_hand`).
  - `message_card` en un efecto de scoring reposiciona el popup (`SMODS.calculate_effect`).
  - El uso de consumibles se trackea con el contexto oficial `using_consumeable` Y con `Sculio.track_inverted_use(card)` al inicio de cada `use` (patrón `track_usage` de Ortalab). EXCEPCIÓN El Sensato: leer `Sculio_last_inverted` ANTES de trackearse a sí mismo.
  - Los eventos encolados DURANTE `evaluate_play` se ejecutan DESPUÉS de que la mano se resuelve; para destruir/afectar cartas jugadas antes del scoring, encolar en el contexto `press_play` (corre tras mover las jugadas a `G.play`, antes de `evaluate_play`).
  - `press_play` llega a las cartas de `G.hand` con `cardarea == G.hand`; las de `G.play` NO lo reciben (lógica de Perforadas vive en `Sculio:calculate`). En `press_play`, `card.highlighted` distingue jugadas de sobrantes. Descarte estilo The Hook: `G.hand:add_to_highlighted(card, true)` + `G.FUNCS.discard_cards_from_highlighted(nil, true)`.
  - Contexto `after` (con `scoring_hand`) = final de la mano para cartas jugadas; ahí convierte Experimental a Plomo con la animación de volteo.
  - `can_use` custom REEMPLAZA toda la lógica vanilla de límites de selección: los consumibles con objetivo usan `Sculio.can_select(card)` (min/max_highlighted). La deselección tras usar NO es automática: cada use debe cerrar con `G.hand:unhighlight_all()` (lo hace `Sculio.flip_highlighted`).
  - Crear etiquetas al azar: patrón de la Carta Reciclada de Ortalab — `get_current_pool('Tag')` + `pseudorandom_element` + remuestrear mientras salga `'UNAVAILABLE'`, luego `Tag(key, false, 'Small')` + `add_tag(tag)` dentro del evento. NUNCA `pseudorandom_element(G.P_TAGS, ...)` directo (los `in_pool` de los centers crashean).
  - La animación de volteo para aplicar modificadores sigue el patrón de `PB_UTIL.use_consumable_animation` de Paperback (dos olas de flip con la acción al medio); en Sculio es `Sculio.flip_highlighted(card, cards, apply_fn)`.
- **Instrumentación temporal**: `sendDebugMessage(..., 'SCULIO')` en utils (hook `use_consumeable` + `create_center_card`), `01_the_sane.lua` y `enhancements/experimental.lua`. Quitar cuando se cierren los bugs de El Sensato y la Experimental.
- **`assets/{1x,2x}/Enhancements.png`**: rejilla 7×5 de sprites 71×95 (2x = 142×190). Ambas resoluciones son obligatorias.
- **Mapa fila 0 de `Enhancements.png`**: X0 lead, X1 experimental, X2 sello Tarot inverso (sprite sin objeto aún, ignorar), X3 phalanx, X4 wandering, X5 profane, X6 pierced.

## Verification

Sin tests automatizados. Verificar en juego (recarga de Balatro; consola DebugPlus para los mensajes 'SCULIO') y contra la wiki SMODS antes de entregar.

## Child DOX Index

Ninguno.
