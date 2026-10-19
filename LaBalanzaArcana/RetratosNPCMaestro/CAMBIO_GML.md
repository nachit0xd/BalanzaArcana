# Dos cambios en `scripts/scr_portrait/scr_portrait.gml`

No sustituyas todo el archivo.

**1.** Al final de `portrait_frame(_pid)`, cambia el retorno por defecto:

```diff
-    return 0;
+    return -1;
```

Así un ID desconocido no se confundirá con el retrato del Herrero.

**2.** Al comienzo de `portrait_info(_pid)`, sustituye la condición que acepta cualquier fotograma de `spr_portrait`:

```diff
     var _ps = asset_get_index("spr_portrait");
-    if (_ps != -1) return { kind: "sprite", spr: _ps, frame: portrait_frame(_pid) };
+    var _frame = portrait_frame(_pid);
+    if (_ps != -1) {
+        if (_frame >= 0 && _frame < sprite_get_number(_ps)) {
+            return { kind: "sprite", spr: _ps, frame: _frame };
+        }
+    }
```

Con los ocho fotogramas propuestos, NPC y Maestro usan `spr_portrait`; los enemigos (índices 8–15) y el jefe (16) siguen el camino provisional que ya existe debajo. `sprite_get_number()` devuelve el número de fotogramas de un sprite ([manual de GameMaker](https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Asset_Management/Sprites/Sprite_Information/sprite_get_number.htm)). Más adelante, si añades sus fotogramas en el orden ya definido, se activarán automáticamente.
