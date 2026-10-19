# Un objeto para el portón del castillo y la barrera del puente

Estos archivos son **propuestas para integrar en GameMaker**. Están aparte: no se ha editado el código ni las salas del proyecto.

## Lo que encontré

- `rm_forest` y `rm_castle` ya tienen las capas de tiles y los tilesets propios. `rm_castle` tiene jugador y los cinco enemigos de nivel 3 colocados.
- `rm_castle` **no contiene una instancia de `obj_gate`**. El objeto existente tampoco tiene sprite asignado: su evento Draw dibuja una puerta provisional con rectángulos. La puerta pintada en `ts_castle` es un tile estático y no cambia al derrotar enemigos.
- `rm_village` **no contiene una instancia de `obj_bridge_region`**. El código actual puede bloquear el índice 2 de `Collision` hasta terminar la misión de la guardiana, pero por sí solo no dibuja la barrera ni muestra el aviso de proximidad.

La propuesta mantiene `gate_interact()` y `bridge_locked()` y añade **un solo `obj_barrier`** para la imagen, la zona sólida y la interacción de ambos casos. El portón siempre impide atravesarlo: cerrado muestra el aviso existente y abierto permite examinarlo para elegir si entras a la batalla final. La barrera del puente bloquea solo mientras la misión de la guardiana está pendiente.

## 1. Preparar dos sprites de dos fotogramas

| Sprite | Fotograma 0 | Fotograma 1 | Tamaño de prueba | Origen |
| --- | --- | --- | --- | --- |
| `spr_gate_barrier` | puerta cerrada | puerta abierta | 32 × 32 px | `(8, 15)` |
| `spr_bridge_barrier` | barrera visible | transparente, o barrera levantada | 4 × 32 px | `(0, 0)` |

Puedes copiar la puerta que dibujaste en `spr_tiles_castle` al fotograma 0 de `spr_gate_barrier` y dibujar su variante abierta en el fotograma 1. Si usas dimensiones distintas, ajusta también `hb_l`, `hb_r`, `hb_t` y `hb_b` en el evento Create propuesto. El sprite del puente representa **solo la barrera**: los tablones o el camino del puente permanecen en `Ground`.

GameMaker no dibuja automáticamente el sprite de un objeto que tiene un evento Draw personalizado; por eso el nuevo Draw usa `draw_self()` ([manual de eventos Draw](https://manual.gamemaker.io/lts/en/The_Asset_Editors/Object_Properties/Draw_Events.htm)).

## 2. Crear `obj_barrier`

1. Crea un objeto `obj_barrier` y asígnale `spr_gate_barrier` como sprite predeterminado.
2. En **Variable Definitions** añade estas variables: `barrier_kind` de tipo String con valor `gate`, `span_px` de tipo Real con valor `32` y `notice_margin` de tipo Real con valor `12`.
3. Crea los eventos **Create**, **Step**, **Draw** y **Draw GUI**, pegando los archivos correspondientes de [NuevoObjeto](NuevoObjeto). No añadas evento de colisión: el jugador usa `solid_at()` y la caja de pies, no las máscaras de GameMaker.
4. Aplica los fragmentos de [CAMBIOS_scr_world.md](CAMBIOS_scr_world.md). Crea primero `obj_barrier`, porque `scr_world.gml` lo referencia.

Las variables de objeto pueden sobreescribirse por instancia en el editor de salas antes de ejecutar Create ([manual de Object Variables](https://manual.gamemaker.io/lts/en/The_Asset_Editors/Object_Properties/Object_Variables.htm)).

## 3. Colocar el portón en `rm_castle`

1. En `Instances`, coloca **una** instancia de `obj_barrier` donde estará el portón. Deja `barrier_kind = gate` y el sprite predeterminado `spr_gate_barrier`.
2. Con el origen sugerido `(8, 15)`, el objeto cubre 32 × 32 px desde `x-8` hasta `x+23` y de `y-15` a `y+16`, como el `obj_gate` antiguo. Sitúalo en el hueco de dos por dos tiles.
3. Borra de `Obstacles` la puerta **cerrada** pintada bajo esa instancia. Conserva el marco y los muros alrededor. Borra también de `Collision` los tiles sobre los 32 × 32 px del hueco: la caja del objeto bloqueará el paso antes y después de abrirse. Un tile sólido escondido seguiría bloqueando aunque el sprite cambiara.
4. No añadas `obj_gate` antiguo a esta sala. El `obj_barrier` llama a `gate_interact()`, que ya conserva el aviso de guardianes pendientes y la elección antes del jefe.

La apertura se calcula con `level_requirements_met(3)`. El banco actual registra exactamente a `sombra`, `guerrero`, `centinela`, `espectro` y `esqueleto` como fuentes de nivel 3; por tanto, el fotograma cambia cuando los cinco estén completados. No hace falta contar manualmente enemigos visibles ni editar el banco.

## 4. Colocar la barrera en `rm_village`

1. En `Instances`, coloca otra instancia de `obj_barrier` en la entrada izquierda del puente. En el Inspector cambia **`barrier_kind` a `bridge`** y **sobreescribe el sprite de esa instancia** con `spr_bridge_barrier`. GameMaker permite cambiar el sprite de una instancia colocada en la sala ([manual de capas de instancia](https://manual.gamemaker.io/monthly/en/The_Asset_Editors/Room_Properties/Layer_Properties.htm)).
2. El origen `(0, 0)` debe quedar en la esquina superior izquierda de la barrera vertical. `span_px = 32` cubre las dos casillas de altura del paso; ajústalo si el puente tiene otra anchura visual. El código conserva el aviso automático cuando se intenta avanzar a la derecha, sin exigir pulsar una tecla.
3. Deja los tiles del **piso del puente** en `Ground` y el agua/terreno sólido alrededor en `Collision`. Puedes borrar los índices 2 de `Collision` exactamente bajo la barrera cuando verifiques que la instancia ocupa el paso; si quedan, su bloqueo anterior seguirá funcionando como respaldo. No pongas índice 1 en el paso, porque ese índice siempre bloquea incluso después de ayudar a la guardiana.
4. No necesitas colocar `obj_bridge_region` además de `obj_barrier`.

## 5. Verificación

| Estado | Dibujo | Colisión | Interacción |
| --- | --- | --- | --- |
| Castillo: quedan guardianes | puerta cerrada | bloquea | `gate_interact()` muestra el aviso existente |
| Castillo: cinco derrotados | puerta abierta | sigue bloqueando | `gate_interact()` ofrece entrar o continuar explorando |
| Aldea: guardiana pendiente | barrera cerrada | bloquea | al intentar cruzar muestra el aviso existente |
| Aldea: misión terminada | barrera abierta/oculta | deja pasar | sin aviso |

Prueba también volver a las salas tras cambiar de nivel y activar F1 para comprobar las cajas. Si la puerta sigue visible cerrada tras derrotar a los cinco, revisa que no quede su tile fijo en `Obstacles`. Si la barrera abierta aún detiene al jugador, revisa si hay índice 1 en `Collision` bajo el paso.

No se ha ejecutado GameMaker desde esta carpeta; la tabla es la comprobación que debes realizar al integrar los fragmentos.
