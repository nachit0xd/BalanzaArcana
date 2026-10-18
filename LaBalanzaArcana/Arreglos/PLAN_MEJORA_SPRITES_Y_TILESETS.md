# Plan de arte: personajes y escenarios

Este documento es una propuesta. No modifica los sprites, tilesets, rooms ni GML actuales.

## Herramienta recomendada

- **LibreSprite**: opción gratuita de escritorio para empezar. Tiene fotogramas, capas, vista de animación y dibujo en mosaico. Sitio oficial: https://github.com/LibreSprite/LibreSprite
- **Piskel**: opción gratuita en el navegador para probar diseños pequeños y exportar PNG o spritesheets. Sitio oficial: https://www.piskelapp.com/
- **Aseprite**: opción de pago si el trabajo de pixel art pasa a ser frecuente; incluye edición de tilemaps y exportación de tilesets. Sitio y documentación oficiales: https://www.aseprite.org/ y https://www.aseprite.org/docs/tilemap/
- **Editor de GameMaker**: suficiente para importar los PNG, ajustar fotogramas y comprobar orígenes; no hace falta diseñar dentro del IDE. Guías oficiales: https://gamemaker.io/en/tutorials/sprite-editor y https://gamemaker.io/en/tutorials/tile-set-editor

**Elección práctica:** empezar con LibreSprite, guardar el archivo editable de cada diseño fuera de las carpetas internas de GameMaker y exportar PNG. Usar el editor de GameMaker para la importación final.

## Lo que ya existe y conviene conservar

- El mundo se dibuja sobre una cuadrícula de **16 × 16 píxeles**. Los mapas de aldea, bosque y castillo tienen **40 × 23 casillas** y se construyen al entrar en cada room.
- Solo existe `ts_village`, basado en `spr_tiles_village`: imagen de **128 × 32 píxeles**, 16 casillas de 16 × 16. `world_build_placeholder_map()` lo asigna tanto a `Ground` como a `Solid` en los tres niveles.
- `spr_player`: **16 × 16**, origen **(8, 15)**, **12 fotogramas**. Grupos de tres: derecha 0–2, arriba 3–5, izquierda 6–8 y abajo 9–11; en cada grupo van reposo y dos pasos.
- `spr_npc`: **16 × 16**, origen **(8, 15)**, **7 fotogramas**. Los índices siguen `npc_look_frame()`: herrero, molinera, guardiana, duende, herbolaria, apicultor y cartógrafa.
- `spr_enemy`: **16 × 16**, origen **(8, 15)**, **8 fotogramas**. Los índices siguen `enemy_look_frame()`: hombre lobo, gólem, araña, sombra, guerrero, centinela, espectro y esqueleto.
- `spr_boss`: **32 × 32**, origen **(16, 31)**, un fotograma.
- Las colisiones del mundo **no dependen del color del arte**: cualquier casilla no vacía de `Solid` bloquea; en `Ground`, el índice 4 es agua sólida y el 5 es el puente que puede cerrarse. Cambiar esos índices exigiría ajustar `scr_world.gml`.

## Dirección visual propuesta

| Nivel | Tema y siluetas | Suelo y obstáculos | Colores dominantes |
| --- | --- | --- | --- |
| 1, aldea | Forja, molino y casas cálidas; habitantes con oficio reconocible por sombrero, herramienta o ropa | Césped claro, sendero de tierra, río, puente de madera, cercas, tejados | Verdes cálidos, tierra y amarillo |
| 2, bosque | Vegetación más densa, colmenas y cristales; enemigos con formas distintas al follaje | Musgo, tierra húmeda, agua oscura, raíces, troncos, piedras y cristales | Verdes fríos, turquesa y violeta |
| 3, castillo | Ruina arcana y guardianes; siluetas espectrales separadas de los muros | Losa agrietada, corredor, muros, escombros, runas y portón | Azul pizarra, púrpura y acentos rojos |
| 4, jefe | Rey y escudo como foco; mantener visibles los dos campos de respuesta y los tres sellos | Escenario de combate dibujado por GML, sin tilemap de overworld | Púrpura oscuro, rojo y oro |

Usar un contorno coherente, una dirección de luz común y una paleta corta por nivel. A 16 × 16 píxeles conviene priorizar la silueta, el rostro y un rasgo propio de cada personaje antes de añadir textura fina. Comprobar el resultado al tamaño real del juego y también ampliado con píxel nítido.

## Fases y archivos a modificar al ejecutar el plan

### 1. Personajes: sustituir imágenes conservando la interfaz actual

| Recurso actual | Trabajo | Código adicional |
| --- | --- | --- |
| `sprites/spr_player/spr_player.yy` y sus PNG de fotogramas | Redibujar los 12 fotogramas de 16 × 16; conservar orden, origen y pies en el mismo lugar. | Ninguno si se mantiene el formato. |
| `sprites/spr_npc/spr_npc.yy` y sus PNG | Redibujar los siete NPC como fotogramas del mismo recurso, sin reordenarlos. | Ninguno. |
| `sprites/spr_enemy/spr_enemy.yy` y sus PNG | Redibujar los ocho enemigos, cada uno con silueta y acento reconocibles. | Ninguno. |
| `sprites/spr_boss/spr_boss.yy` y su PNG | Redibujar el Rey en 32 × 32 y conservar su origen inferior. | Ninguno. |

Importar los PNG mediante el editor de sprites de GameMaker. No editar a mano los nombres internos de los PNG con UUID ni los `.yy`. El IDE administra esos archivos. Si más adelante se agregan fotogramas o se cambia el orden, revisar `objects/obj_player/Step_0.gml`, `scripts/scr_quest/scr_quest.gml` y `scripts/scr_battle/scr_battle.gml`.

**Retratos opcionales:** crear `spr_portrait` con **17 fotogramas** en el orden de `portrait_frame()` de `scripts/scr_portrait/scr_portrait.gml`. Ese script ya lo detecta por nombre y deja de ampliar los pequeños sprites del mundo. Incluir al Maestro y al Rey; mantener una misma medida para todos los retratos. No hace falta modificar GML si se respeta el nombre y el orden.

### 2. Tres tilesets con la misma estructura

Mantener `spr_tiles_village` y `ts_village` para el nivel 1. Crear con GameMaker `spr_tiles_forest` + `ts_forest` para el nivel 2 y `spr_tiles_castle` + `ts_castle` para el nivel 3. Cada nueva hoja debe empezar con **128 × 32 píxeles**, 16 casillas de **16 × 16**, sin separación entre casillas. Redibujar los motivos de cada nivel; compartir índices no significa compartir imágenes.

| Índice | Significado que debe conservarse | Ejemplo bosque | Ejemplo castillo |
| --- | --- | --- | --- |
| 0 | Vacío/transparente | Vacío | Vacío |
| 1 | Suelo base | Musgo | Losa base |
| 2 | Variante de suelo | Flores u hojas | Losa con grieta |
| 3 | Camino transitable | Sendero húmedo | Corredor de piedra |
| 4 | Agua sólida en `Ground` | Arroyo oscuro | Reservado: foso o vacío sólido |
| 5 | Puente en `Ground` | Pasarela de raíces | Reservado: pasarela |
| 6–9 | Obstáculos en `Solid` | Tronco, copa, raíz, cerca | Muro, arco, columna, reja |
| 10 | Puerta transitable | Entrada vegetal | Umbral |
| 11 | Obstáculo de piedra | Cristal o roca | Escombros |
| 12–15 | Libres por ahora | Detalles futuros | Detalles futuros |

El código actual escribe `Ground` y `Solid` a partir de los mismos símbolos de texto en los tres mapas. Por eso, **conservar la función de cada índice** es la forma de obtener escenarios distintos con un cambio GML pequeño. En especial, no colocar adornos atravesables en índices usados por `Solid`.

### 3. Único cambio GML necesario para los tiles por nivel

En `scripts/scr_world/scr_world.gml`, dentro de `world_build_placeholder_map()`, elegir el tileset según `room` antes de las dos llamadas a `layer_tilemap_create()`. Esas dos llamadas usarían la variable elegida en lugar de `ts_village`. Propuesta orientativa:

```gml
var _tileset = ts_village;
if (room == rm_forest) _tileset = ts_forest;
if (room == rm_castle) _tileset = ts_castle;

var _tg = layer_tilemap_create(_lg, 0, 0, _tileset, _w, _h);
var _ts = layer_tilemap_create(_ls, 0, 0, _tileset, _w, _h);
```

Los recursos nuevos quedarían registrados en `LaBalanzaArcana.yyp` al crearlos desde GameMaker. **No es necesario cambiar** `scripts/scr_village_map/scr_village_map.gml`, `scripts/scr_forest_map/scr_forest_map.gml` ni `scripts/scr_castle_map/scr_castle_map.gml` mientras se mantengan las posiciones y la función de los índices. Esos tres archivos se tocarían solo para rediseñar el recorrido, la ubicación de NPC/enemigos o las zonas bloqueadas.

**Evitar por ahora pintar capas `Ground` y `Solid` directamente en las rooms.** `world_setup()` deja de construir el mapa de texto si encuentra ambas capas, y los marcadores `spawn`, NPC, enemigos, salidas y portón se obtienen actualmente de ese mapa. Convertirlo a room pintada exige también migrar los marcadores; cambiar solo los tiles perdería esas posiciones.

### 4. Escenas de combate, si se desea una segunda pasada

Los fondos de batalla no usan `ts_village`: se dibujan con colores y formas en `objects/obj_battle/Draw_64.gml`, `objects/obj_boss/Draw_64.gml` y `objects/obj_boss_room/Draw_0.gml`. Se pueden rediseñar después de los sprites con fondos propios del bosque, castillo y sala del Rey, dejando intactas las posiciones del panel de ejercicios y el HUD. Es una fase visual separada; no hace falta para que el overworld de cada nivel tenga tiles propios.

## Comprobación antes de reemplazar el arte anterior

1. Duplicar el proyecto fuera de `Arreglos` o usar control de versiones; importar primero **un** personaje y **un** tileset de prueba.
2. Verificar en GameMaker el tamaño, orden de fotogramas, origen y transparencia. Caminar en las cuatro direcciones y abrir diálogos y batallas.
3. Entrar en `rm_village`, `rm_forest` y `rm_castle`: confirmar que cada uno carga su hoja, que agua/puente/muros bloquean como antes y que los marcadores siguen creando personajes y salidas.
4. Revisar legibilidad en la resolución interna y en pantalla completa. Ajustar contraste de personajes frente al suelo; mantener visibles efectos, textos e indicadores.
5. Probar `rm_boss` aparte: sus gráficos de escenario proceden de GML, no de un tileset.
