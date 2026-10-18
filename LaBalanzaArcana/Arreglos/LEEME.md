# Propuesta de ajustes de disposición

Estos dieciocho archivos `.patch` contienen únicamente fragmentos cambiados de los eventos GML indicados en su encabezado. Los originales del proyecto no se han editado ni se han registrado nuevos recursos en el archivo `.yyp`.

Para revisar cada parche, las líneas con `-` son las actuales y las líneas con `+` son las propuestas. Las cabeceras `@@` indican la zona aproximada del archivo. Los cambios de `obj_exercise` deben incorporarse juntos: uno calcula el espacio y el otro lo dibuja.

| Archivo de origen | Parche | Objetivo |
| --- | --- | --- |
| `objects/obj_title/Draw_64.gml` | `objects__obj_title__Draw_64.gml.patch` | Reducir el título, separar subtítulo y menú, y sacar el aviso de desarrollo del pie. |
| `objects/obj_battle/Draw_64.gml` | `objects__obj_battle__Draw_64.gml.patch` | Situar nombre y energía del enemigo entre el jugador y el sprite, fuera de la placa de puntaje. |
| `objects/obj_battle/Create_0.gml` | `objects__obj_battle__Create_0.gml.patch` | Hacer visibles los textos flotantes de daño bajo el HUD. |
| `objects/obj_boss/Draw_64.gml` | `objects__obj_boss__Draw_64.gml.patch` | Mover el nombre del Rey y disponer los sellos en una fila fuera del HUD y del escudo. |
| `objects/obj_boss/Create_0.gml` | `objects__obj_boss__Create_0.gml.patch` | Hacer visibles los textos flotantes de daño y de sellos. |
| `objects/obj_exercise/Create_0.gml` | `objects__obj_exercise__Create_0.gml.patch` | Reservar altura para la ecuación, el enunciado y la fila de teclas en combate. |
| `objects/obj_exercise/Draw_64.gml` | `objects__obj_exercise__Draw_64.gml.patch` | Dibujar la ecuación compacta sobre el enunciado y escalar este último solo cuando haga falta. |
| `objects/obj_title/Draw_64.gml` | `objects__obj_title__Draw_64__pantallas_secundarias.gml.patch` | Ajustar el contenido y los pies de Cómo jugar y Créditos; envolver la nota del código y separar texto, opciones y controles de la confirmación. |
| `objects/obj_options/Draw_64.gml` | `objects__obj_options__Draw_64__pantallas_secundarias.gml.patch` | Compactar las filas y reservar zonas distintas para la descripción y los controles. |
| `objects/obj_pause/Draw_64.gml` | `objects__obj_pause__Draw_64__hud_resultados.gml.patch` | Ajustar «Cómo jugar» al abrirlo desde la pausa durante la partida. |
| `objects/obj_answer_box/Draw_64.gml` | `objects__obj_answer_box__Draw_64__hud_resultados.gml.patch` | Dibujar los subíndices 1 y 2 junto a las dos x de la respuesta del jefe, sin depender de glifos ausentes en la fuente. |
| `objects/obj_hud/Draw_64.gml` | `objects__obj_hud__Draw_64__hud_resultados.gml.patch` | Sustituir los segmentos verdes de vida por corazones; tres en los niveles 1–3 y dos contra el jefe, según el cálculo de vida existente. |
| `objects/obj_results/Create_0.gml` | `objects__obj_results__Create_0__hud_resultados.gml.patch` | Calcular las páginas de insignias de dos en dos y esperar a que aparezcan las de cada página. |
| `objects/obj_results/Draw_64.gml` | `objects__obj_results__Draw_64__hud_resultados.gml.patch` | Mostrar todas las insignias obtenidas en páginas de dos, dentro del panel. |
| `objects/obj_results/Step_0.gml` | `objects__obj_results__Step_0__hud_resultados.gml.patch` | Reproducir el sonido al aparecer cada insignia en cualquier página. |
| `objects/obj_pause/Step_0.gml` | `objects__obj_pause__Step_0__opciones_npc_nivel3.gml.patch` | Impedir que la misma pulsación de Enter que cierra Opciones vuelva a abrirlo desde la pausa. |
| `objects/obj_mission/Create_0.gml` | `objects__obj_mission__Create_0__opciones_npc_nivel3.gml.patch` | Barajar solo las preguntas del NPC y entregar dos distintas por misión. |
| `scripts/scr_bank_test/scr_bank_test.gml` | `scripts__scr_bank_test__scr_bank_test__opciones_npc_nivel3.gml.patch` | Dar, tras cada batalla del nivel 3, una pista narrativa distinta sobre ecuaciones cuadráticas, dos raíces y los sellos del Rey. |

Los dos parches de pantallas secundarias se basan en la versión actual de los archivos, que ya contiene el ajuste anterior del menú principal. Si aún no incorporaste ese ajuste, aplícalo primero. Las coordenadas se calcularon para la interfaz de 1280 × 720 definida en `scr_display`. Después de integrar los parches, comprueba las cinco pantallas en GameMaker, incluido el código con error y la descripción más larga de Opciones. Esta propuesta no ha sido ejecutada en GameMaker.

Los seis parches de pausa, respuesta, vida y resultados también se basan en la versión actual. Incorpora juntos los tres de `obj_results`, ya que comparten el número de insignias por página. Comprueba en GameMaker una pantalla de pausa, una respuesta con dos raíces, tres corazones en niveles 1–3, dos corazones contra el jefe y un resultado que otorgue cuatro insignias. Estos parches tampoco se han ejecutado en GameMaker.

Los tres parches de Opciones, misiones NPC y diálogos del nivel 3 se basan en la versión actual. La selección de NPC baraja los IDs ya registrados para ese mismo personaje y usa los dos primeros; el banco matemático queda intacto. Prueba el botón «Volver» con Enter desde la pausa, una misión de cada NPC en dos partidas y los cinco diálogos posteriores a las victorias del nivel 3. No se han ejecutado en GameMaker.

Para la futura mejora gráfica, consulta `PLAN_MEJORA_SPRITES_Y_TILESETS.md`. Es un plan de diseño y de archivos; no contiene cambios aplicados al proyecto.
