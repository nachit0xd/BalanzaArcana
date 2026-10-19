# Retratos de los NPC y del Maestro (64 × 64 px)

Este plan se entrega aparte. No se han cambiado recursos ni código del proyecto.

## Estado actual

`scr_portrait.gml` ya reconoce al Maestro y a los siete NPC, y reserva los fotogramas **0 a 7** de `spr_portrait` para ellos. El sprite todavía no existe en el proyecto. La función `portrait_info()` se usa tanto en el diálogo grande como en la miniatura de la pantalla de misión; por eso basta importar **un sprite de ocho fotogramas** y hacer un pequeño ajuste de seguridad en esa función. No hace falta editar `obj_dialogue`, `obj_exercise`, `scr_ui_kit`, los textos ni el banco de preguntas.

## Paso 1: preparar las ocho imágenes

Usa ocho PNG de **64 × 64 px** sin escalarlos. Deja el fondo transparente si quieres conservar el marco, degradado y sombra que ya dibuja el juego. Mantén una altura visual parecida entre personajes, con rostro y parte superior del cuerpo dentro del lienzo.

| Fotograma en código | Posición visible en el editor | Imagen |
| ---: | ---: | --- |
| 0 | 1 | Herrero (`herrero`) |
| 1 | 2 | Molinera (`molinera`) |
| 2 | 3 | Guardiana (`guardiana`) |
| 3 | 4 | Duende (`duende`) |
| 4 | 5 | Herbolaria (`herbolaria`) |
| 5 | 6 | Apicultor (`apicultor`) |
| 6 | 7 | Cartógrafa (`cartografa`) |
| 7 | 8 | Maestro (`maestro`) |

GameMaker permite importar varias imágenes como fotogramas de un mismo sprite. El editor los muestra contando desde 1, pero GML los referencia desde 0 ([manual del editor de sprites](https://manual.gamemaker.io/monthly/en/The_Asset_Editors/Sprites.htm)). Comprueba el orden en la línea de tiempo después de importar; no dependas del orden en que el explorador de archivos seleccionó los PNG.

## Paso 2: crear `spr_portrait`

1. Crea un Sprite llamado **exactamente** `spr_portrait` e importa las ocho imágenes como fotogramas separados. El juego seleccionará un fotograma por personaje; **no es una animación que deba reproducirse**.
2. Verifica tamaño **64 × 64 px** y fija el origen personalizado en **`(32, 63)`**, centro inferior. El código dibuja cada retrato sobre una línea de base. Con el origen centrado verticalmente, el retrato quedaría demasiado bajo y podría cortarse dentro del marco.
3. Conserva los bordes nítidos. El proyecto ya tiene `interpolate_pixels = false` en la configuración de Windows; el retrato grande usa escala entera **3×** (192 × 192 px) y la miniatura escala **1×** (64 × 64 px). Por tanto, no hay que redimensionar los PNG ni cambiar el tamaño de la interfaz.

## Paso 3: aplicar el ajuste de seguridad

Aplica únicamente los cambios de [CAMBIO_GML.md](CAMBIO_GML.md) en `scripts/scr_portrait/scr_portrait.gml`. Ahora mismo, si existe `spr_portrait`, `portrait_info()` intenta usarlo para **todos** los personajes. Con solo ocho fotogramas, los enemigos y el jefe pedirían índices del 8 al 16. El ajuste comprueba que el índice exista y deja a esos personajes con su retrato provisional.

La función `portrait_id_for_name()` y las llamadas de `obj_dialogue` y `obj_exercise` ya están conectadas. También puedes conservar `draw_portrait_maestro()` como respaldo: dejará de usarse en el juego normal cuando el fotograma 7 esté disponible.

## Paso 4: comprobación para cerrar la etapa

1. Abre el diálogo inicial del Maestro y revisa su fotograma 7, tamaño, posición y transparencia.
2. Habla con los cuatro NPC del nivel 1 y los tres del nivel 2. Comprueba que cada uno muestra su retrato correcto y que cambia de imagen al cambiar el hablante.
3. Inicia una misión de NPC y revisa la miniatura del encabezado. La misma importación debe verse allí a escala 1×.
4. Habla de nuevo con un NPC que ya completó su misión y revisa su retrato en el diálogo repetido.
5. Revisa un diálogo de enemigo y el jefe, si aparece retrato fuera de combate: deben seguir usando su imagen provisional mientras no les agregues fotogramas nuevos.
6. Si alguno se ve cortado, revisa primero el origen `(32, 63)` y que **todas** las imágenes sean realmente 64 × 64 px; no cambies las dimensiones del cuadro de diálogo antes de corregir el recurso.

Este plan no incluye las imágenes porque no se adjuntaron a esta solicitud. La integración y la prueba visual deben hacerse en GameMaker después de importarlas.
