# Niveles 2 y 3 diseñados en el editor de salas

Esta carpeta contiene el parche y la guía de integración. **No se modificó el proyecto original.** Los mapas de texto de bosque y castillo quedan como respaldo mientras dibujas las salas.

## Qué cambia

Aplica [`scr_world.gml.patch`](Parches/scr_world.gml.patch) a `scripts/scr_world/scr_world.gml`. Cuando una sala tiene capas `Ground` y `Collision`, `world_setup()` toma el mapa y los personajes colocados en el editor; deja de extraer marcadores del mapa de texto y deja de crear NPC, enemigos y portón por código. Si esas dos capas aún no existen, conserva el mapa provisional. El parche también avisa en el registro de depuración si falta un personaje requerido.

No cambies `scr_forest_map.gml`, `scr_castle_map.gml`, el banco de preguntas, `scr_levels.gml` ni el código de los NPC y enemigos. `on_results_closed()` ya lleva del nivel 2 al 3, y el portón ya inicia el paso al jefe cuando corresponde.

## Recursos gráficos

| Sala | Sprite base nuevo | Tileset nuevo | Capas que lo usan |
| --- | --- | --- | --- |
| `rm_forest` | `spr_tiles_forest` | `ts_forest` | `Ground`, `Decor`, `Obstacles` |
| `rm_castle` | `spr_tiles_castle` | `ts_castle` | `Ground`, `Decor`, `Obstacles` |

Usa celdas de **16 × 16 px**, igual que la aldea, y deja vacía la primera celda de cada sprite de tileset: GameMaker reserva el índice 0 para borrar/dejar una casilla vacía ([manual del editor de tilesets](https://manual.gamemaker.io/monthly/en/The_Asset_Editors/Tile_Sets.htm)). Los dos tilesets pueden tener índices artísticos diferentes: el código ya no interpreta sus números cuando la sala está pintada.

Para la capa `Collision`, reutiliza `ts_collision` en ambas salas. **Índice 1** significa pared, agua, roca u otra huella infranqueable; **índice 0** queda libre. No uses el índice 2 para obstáculos normales: `solid_at()` solo lo bloquea cuando `bridge_locked()` es verdadero, una condición específica del puente de la aldea. Así las salas tienen arte diferente, pero comparten una regla de colisión estable.

## Preparar cada sala

En `rm_forest` y `rm_castle`, conserva `Instances` (profundidad 0) y el único `obj_overworld_ctrl` que ya tienen. Añade estas capas de tiles con **estos nombres exactos**:

| Capa | Profundidad | Tileset | Uso |
| --- | ---: | --- | --- |
| `Decor` | 100 | el del nivel | Flores, marcas, grietas y detalles de suelo |
| `Obstacles` | 200 | el del nivel | Piedras, muros, arbustos y elementos bajos |
| `Ground` | 300 | el del nivel | Suelo y caminos; cubre toda la superficie jugable |
| `Collision` | 400 | `ts_collision` | Solo la huella sólida, independiente de la imagen |

La sala actual mide **640 × 368 px**, o **40 × 23 casillas**. No necesitas cambiarla para esta primera migración. Pinta una zona inicial transitable y después dibuja obstáculos y colisiones. Antes de crear `Ground` y `Collision` juntas, el mapa provisional sigue funcionando; al tener ambas, el sistema pasa a leer la sala pintada. Por eso, coloca los personajes y comprueba los caminos antes de probar la nueva configuración.

### Nivel 2: `rm_forest`

En `Instances`, coloca **una** instancia de `obj_player` en una casilla libre, tres de `obj_npc` y dos de `obj_enemy`. En el inspector de cada instancia asigna exactamente estos valores a su variable de objeto:

| Objeto | Variable | Valor |
| --- | --- | --- |
| `obj_npc` | `npc_id` | `herbolaria` |
| `obj_npc` | `npc_id` | `apicultor` |
| `obj_npc` | `npc_id` | `cartografa` |
| `obj_enemy` | `enemy_id` | `golem` |
| `obj_enemy` | `enemy_id` | `arana` |

`obj_enemy` tiene también `radius` (48 px por defecto): redúcelo desde el inspector si la zona de patrulla es estrecha. Deja espacio libre alrededor de su punto inicial y comprueba que no aparezca dentro de `Collision`. Para árboles altos, evita representar toda la copa solo en `Obstacles`: es una capa de profundidad fija. Puedes crear `obj_tree_forest` como hijo de `obj_tree_village`, darle un sprite propio de bosque con origen en la base y ajustar sus variables heredadas `trunk_left/right/top/bottom`; así reutiliza la colisión del tronco y el orden por `y` sin GML adicional. No añadas eventos Create/Draw al hijo, para que herede los del padre ([manual de herencia](https://manual.gamemaker.io/lts/en/The_Asset_Editors/Object_Properties/Parent_Objects.htm)).

### Nivel 3: `rm_castle`

Coloca **una** instancia de `obj_player`, cinco de `obj_enemy` y una de `obj_gate` en `Instances`:

| Objeto | Variable | Valor |
| --- | --- | --- |
| `obj_enemy` | `enemy_id` | `sombra` |
| `obj_enemy` | `enemy_id` | `guerrero` |
| `obj_enemy` | `enemy_id` | `centinela` |
| `obj_enemy` | `enemy_id` | `espectro` |
| `obj_enemy` | `enemy_id` | `esqueleto` |
| `obj_gate` | — | una instancia frente al acceso al jefe |

El portón usa una caja propia de **32 × 32 px** y se dibuja por código. Sitúa su origen aproximadamente en el centro inferior de la casilla superior izquierda del hueco de 2 × 2; deja sin `Collision` las casillas que su propia caja bloquea, o se verá abierto pero seguirá siendo infranqueable. No coloques un segundo portón en el dibujo de `Obstacles` sobre él. El paso al jefe ocurre al interactuar con `obj_gate` después de vencer a los cinco guardianes; no necesita un marcador `G` ni una salida pintada.

## Prueba de integración

1. Aplica el parche y verifica que el nivel 1 sigue usando su mapa pintado, sus NPC y su puente.
2. En el nivel 2, comprueba aparición, diálogos de los tres NPC, patrulla y batalla de los dos enemigos, colisión del terreno y transición al nivel 3. Pulsa F1 en modo depuración para ver los marcadores recogidos de `Instances`.
3. En el nivel 3, comprueba los cinco enemigos y el portón antes y después de derrotarlos. Revisa que puedas acercarte y mirarlo de frente para interactuar.
4. Busca mensajes `AVISO:` en la consola de GameMaker: identifican IDs requeridos ausentes o falta de jugador/portón.

Comprobación estática del parche: `git apply --check` debe terminar sin errores. No se ha ejecutado GameMaker desde esta carpeta, por lo que el diseño final y las rutas de paso deben probarse en el editor y en juego.
