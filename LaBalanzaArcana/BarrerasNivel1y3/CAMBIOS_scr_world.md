# Cambios puntuales en `scripts/scr_world/scr_world.gml`

No reemplaces el archivo completo. Los mapas de texto y los objetos antiguos quedan disponibles como respaldo para salas sin capas pintadas.

## A. Agregar la colisión del objeto

Dentro de `solid_at(_x, _y)`, inmediatamente después de:

```gml
if (tree_blocks(_x, _y)) return true;
```

inserta:

```gml
if (barrier_blocks(_x, _y)) return true;
```

## B. Agregar las dos funciones compartidas

Después de `bridge_locked()` y antes de `npc_blocks()`, inserta:

```gml
function barrier_open(_kind) {
    switch (_kind) {
        case "gate":   return level_requirements_met(3);
        case "bridge": return !bridge_locked();
    }
    return false;
}

function barrier_blocks(_x, _y) {
    var _hit = false;
    with (obj_barrier) {
        // El portón siempre se examina; la barrera del puente desaparece al abrirse.
        var _solid = (barrier_kind == "gate") || !barrier_open(barrier_kind);
        if (_solid && _x >= x + hb_l && _x <= x + hb_r
                   && _y >= y + hb_t && _y <= y + hb_b) {
            _hit = true;
        }
    }
    return _hit;
}
```

La comprobación anterior del índice 2 de `Collision` y la colisión de `obj_gate` en `npc_blocks()` pueden permanecer: sirven para el mapa provisional y no alteran el nuevo objeto si despejas su zona como indica la guía.

## C. Actualizar el marcador y aviso del portón pintado

Dentro del bloque `if (_painted)` de `world_setup()`, **sustituye**:

```gml
if (instance_exists(obj_gate)) {
    global.markers[$ "gate"] = { x: obj_gate.x, y: obj_gate.y };
}
```

por:

```gml
if (instance_exists(obj_gate)) {
    global.markers[$ "gate"] = { x: obj_gate.x, y: obj_gate.y };
} else if (room == rm_castle && instance_exists(obj_barrier)) {
    global.markers[$ "gate"] = { x: obj_barrier.x, y: obj_barrier.y };
}
```

En el mismo bloque, **sustituye**:

```gml
if (room == rm_castle && !instance_exists(obj_gate)) {
    show_debug_message("AVISO: falta obj_gate en rm_castle.");
}
```

por:

```gml
if (room == rm_castle && !instance_exists(obj_gate) && !instance_exists(obj_barrier)) {
    show_debug_message("AVISO: falta obj_barrier en rm_castle.");
}
```

No cambies `gate_interact()`: ya contiene la advertencia y la elección solicitadas.
