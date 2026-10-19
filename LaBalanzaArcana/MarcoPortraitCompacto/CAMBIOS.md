# Marco de retrato compacto y estático

Aplica estos cambios a los archivos indicados. Este documento contiene solo los fragmentos que hay que modificar; los archivos originales del proyecto no se han alterado.

## 1. `objects/obj_dialogue/Draw_64.gml`

Dentro del bloque `if (portrait_id != "" && !battle_active() && !boss_active())`, sustituye las dos líneas de tamaño y llamada por:

```gml
var _prw = 224, _prh = 224;
portrait_draw(portrait_id, box_x + box_w - _prw, box_y - _prh - 8, _prw, _prh, pt, _k, _acc);
```

El marco pasa de 336×328 a 224×224 unidades de GUI. Quitar `(1 - _k) * 50` evita que entre deslizándose; `_k` conserva el fundido de aparición.

## 2. `scripts/scr_portrait/scr_portrait.gml`

En el comentario de parámetros de `portrait_draw`, sustituye la descripción de `_t` por:

```gml
//   _t             : reservado para mantener la firma actual; ya no mueve el retrato
```

Dentro de `portrait_draw`, sustituye desde `// Sombra en el suelo` hasta el final del bloque `if (_info.kind == "maestro") ... else ...` por:

```gml
// Retrato fijo, centrado y apoyado cerca del borde inferior del marco.
var _cx   = _x + _w / 2;
var _base = _y + _h - 16;

if (_info.kind == "maestro") {
    var _u = 10; // Retrato provisional de 16 x 20 casillas; cabe en 224 x 224.
    draw_portrait_maestro(_cx - 8 * _u, _base - 20 * _u, _u);
} else {
    var _sw = sprite_get_width(_info.spr);
    var _sh = sprite_get_height(_info.spr);
    var _sc = max(1, floor(min((_w - 32) / _sw, (_h - 32) / _sh)));
    draw_sprite_ext(_info.spr, _info.frame, _cx, _base, _sc, _sc, 0, c_white, _a);
}
```

Esto elimina el óvalo oscuro y el vaivén vertical. Con el sprite actual de 64×64 y origen `(32, 63)`, la escala será 3: el dibujo ocupará 192×192 dentro del marco de 224×224, con aproximadamente 16 unidades libres arriba y abajo.

## Comprobación rápida

Abre un diálogo con un NPC y con el Maestro. El borde derecho del marco debe quedar alineado con el de la caja de diálogo; el retrato debe permanecer quieto y caber completo. Si alguna imagen tiene mucho espacio transparente *dentro de su propio archivo de 64×64*, recorta o recoloca el arte en ese fotograma: el código solo puede ajustar el rectángulo del sprite entero.
