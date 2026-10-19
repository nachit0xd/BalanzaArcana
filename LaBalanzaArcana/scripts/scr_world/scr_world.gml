// Lógica del overworld: tiles, colisiones, NPC, enemigos y preparación de cada room de nivel

#macro TILE 16

// Índices del tileset ts_village
// Corresponden al orden del PNG, de izquierda a derecha y de arriba a abajo (el 0 siempre es la casilla vacía)
#macro T_EMPTY   0
#macro T_GRASS   1
#macro T_GRASS2  2
#macro T_PATH    3
#macro T_WATER   4     // sólido (en la capa Ground)
#macro T_BRIDGE  5
#macro T_WALL    6
#macro T_ROOF    7
#macro T_TREE    8
#macro T_FENCE   9
#macro T_DOOR    10
#macro T_STONE   11

// Colisiones:
// Es sólido todo lo que esté en la capa "Solid", el agua de la capa "Ground", los NPC y lo que quede fuera de la room
function tile_index_at(_tm, _x, _y) {
    if (_tm == -1) return 0;
    var _d = tilemap_get_at_pixel(_tm, _x, _y);
    if (_d == -1) return 0;
    return tile_get_index(_d);       // ignora los bits de volteo/rotación
}

function solid_at(_x, _y) {
    if (_x < 0 || _y < 0 || _x >= room_width || _y >= room_height) return true;
    if (global.tm_collision != -1) {
        var _c = tile_index_at(global.tm_collision, _x, _y);
        if (_c == 1 || (_c == 2 && bridge_locked())) return true;
    } else {
        if (tile_index_at(global.tm_solid, _x, _y) != T_EMPTY) return true;
        var _g = tile_index_at(global.tm_ground, _x, _y);
        if (_g == T_WATER) return true;
        if (_g == T_BRIDGE && bridge_locked()) return true;
    }
	if (tree_blocks(_x, _y)) return true;
	if (barrier_blocks(_x, _y)) return true;
    return npc_blocks(_x, _y);
}

// El puente de la aldea está cerrado hasta cumplir la misión de la guardiana
function bridge_locked() {
    return (room == rm_village && !quest_get("guardiana").done);
}

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

// ¿Este punto cae dentro de la caja de colisión de algún NPC?
function npc_blocks(_x, _y) {
    var _hit = false;
    with (obj_npc) {
        if (_x >= x + hb_l && _x <= x + hb_r && _y >= y + hb_t && _y <= y + hb_b) _hit = true;
    }
    with (obj_gate) {                      // el portón del castillo también bloquea el paso
        if (_x >= x + hb_l && _x <= x + hb_r && _y >= y + hb_t && _y <= y + hb_b) _hit = true;
    }
    return _hit;
}

function tree_blocks(_x, _y) {
    var _hit = false;
    with (obj_tree_village) {
        if (_x >= x + trunk_left && _x <= x + trunk_right
            && _y >= y + trunk_top && _y <= y + trunk_bottom) {
            _hit = true;
        }
    }
    return _hit;
}

// ¿El mundo debe quedarse quieto? (ejercicio, diálogo, combate, etc.)
function world_frozen() {
    return ui_modal_active();
}

// Posición de un marcador, en el centro de la casilla, a la altura de los pies
function marker_pos(_cx, _cy) {
    return { x: _cx * TILE + TILE / 2, y: _cy * TILE + TILE - 1 };
}

// Los marcadores se leen también cuando los tiles están pintados en la room.
function world_extract_markers(_rows, _legend) {
    for (var _y = 0; _y < array_length(_rows); _y++) {
        for (var _x = 0; _x < string_length(_rows[_y]); _x++) {
            var _ch = string_char_at(_rows[_y], _x + 1);
            if (_ch == "X") {
                global.markers[$ "exit_east_" + string(_y)] = marker_pos(_x, _y);
            } else {
                for (var k = 0; k < array_length(_legend); k++) {
                    if (_legend[k][0] == _ch) {
                        global.markers[$ _legend[k][1]] = marker_pos(_x, _y);
                    }
                }
            }
        }
    }
}


// Mapa provisional de cada room de nivel: filas de texto y leyenda de
// marcadores. Devuelve undefined si la room no tiene mapa de texto
function world_map_for_room() {
    switch (room) {
        case rm_village: return { rows: village_map(), legend: village_legend() };
        case rm_forest:  return { rows: forest_map(),  legend: forest_legend()  };
        case rm_castle:  return { rows: castle_map(),  legend: castle_legend()  };
    }
    return undefined;
}

// Prepara la room de overworld. Lo llama obj_overworld_ctrl (Create):
//  - Si la room ya trae capas de tiles "Ground" y "Solid" (mapa pintado
//    en el editor), solo las enlaza.
//  - Si no, construye el mapa provisional de texto.
// Después crea al jugador, los NPC y los enemigos del nivel actual
function world_setup() {
    global.markers   = {};      // nombre -> {x, y}  (aparición, NPC, enemigos, salidas)
    global.tm_ground = -1;
    global.tm_solid  = -1;
	global.tm_collision = -1;

    var _painted = layer_exists("Ground") && layer_exists("Collision");
    var _map = _painted ? undefined : world_map_for_room();
	if (!is_undefined(_map)) {
		world_extract_markers(_map.rows, _map.legend);
	}

    if (_painted) {
        global.tm_ground = layer_tilemap_get_id(layer_get_id("Ground"));
        global.tm_collision = layer_tilemap_get_id(layer_get_id("Collision"));
    } else if (layer_exists("Ground") && layer_exists("Solid")) {
        global.tm_ground = layer_tilemap_get_id(layer_get_id("Ground"));
        global.tm_solid  = layer_tilemap_get_id(layer_get_id("Solid"));
    } else {
        if (is_undefined(_map)) {
            show_debug_message("AVISO: la room " + room_get_name(room) + " no tiene mapa de texto ni capas Ground/Collision.");
        } else {
            world_build_placeholder_map(_map.rows, _map.legend);
        }
    }
	
	if (_painted) {
		if (instance_exists(obj_player)) {
			global.markers[$ "spawn"] = { x: obj_player.x, y: obj_player.y };
		} else {
			show_debug_message("AVISO: coloca obj_player en " + room_get_name(room) + ".");
		}
		with (obj_npc) {
			if (npc_id != "") global.markers[$ npc_id] = { x: x, y: y };
		}
		with (obj_enemy) {
			if (enemy_id != "") global.markers[$ enemy_id] = { x: x, y: y };
		}
		if (instance_exists(obj_gate)) {
			global.markers[$ "gate"] = { x: obj_gate.x, y: obj_gate.y };
		} else if (room == rm_castle && instance_exists(obj_barrier)) {
			global.markers[$ "gate"] = { x: obj_barrier.x, y: obj_barrier.y };
		}

		var _sources = variable_struct_get_names(global.bank_src);
		for (var i = 0; i < array_length(_sources); i++) {
			var _s = global.bank_src[$ _sources[i]];
			if (_s.level == global.level && !quest_get(_s.id).done
			    && !variable_struct_exists(global.markers, _s.id)) {
				show_debug_message("AVISO: falta " + _s.id + " en " + room_get_name(room) + ".");
			}
		}
		if (room == rm_castle && !instance_exists(obj_gate) && !instance_exists(obj_barrier)) {
			show_debug_message("AVISO: falta obj_barrier en rm_castle.");
		}
	}


    if (!instance_exists(obj_player)) {
        var _p = variable_struct_exists(global.markers, "spawn")
               ? global.markers[$ "spawn"]
               : { x: room_width / 2, y: room_height / 2 };
        instance_create_depth(_p.x, _p.y, 0, obj_player);
    }

	if (!_painted) {
		world_spawn_npcs();
		world_spawn_enemies();
		world_spawn_gate();
	}

}

// NPC del nivel actual en los marcadores cuyo nombre es el id del NPC
function world_spawn_npcs() {
    var _names = variable_struct_get_names(global.bank_src);
    for (var i = 0; i < array_length(_names); i++) {
        var _s = global.bank_src[$ _names[i]];
        if (_s.kind != "npc" || _s.level != global.level) continue;
        if (!variable_struct_exists(global.markers, _s.id)) continue;

        var _m    = global.markers[$ _s.id];
        var _inst = instance_create_depth(_m.x, _m.y, 0, obj_npc);
        _inst.setup(_s.id);
    }
}

// Enemigos del nivel actual que aún no fueron derrotados. Vagan cerca de su marcador (ver obj_enemy)
function world_spawn_enemies() {
    var _names = variable_struct_get_names(global.bank_src);
    for (var i = 0; i < array_length(_names); i++) {
        var _s = global.bank_src[$ _names[i]];
        if (_s.kind != "enemy" || _s.level != global.level) continue;
        if (quest_get(_s.id).done) continue;                       // ya derrotado
        if (!variable_struct_exists(global.markers, _s.id)) continue;

        var _m    = global.markers[$ _s.id];
        var _inst = instance_create_depth(_m.x, _m.y, 0, obj_enemy);
        _inst.setup(_s.id);
    }
}

// Portón del Rey (solo en el castillo), que se crea en el marcador "gate"
function world_spawn_gate() {
    if (global.level != 3) return;
    if (!variable_struct_exists(global.markers, "gate")) return;
    var _m = global.markers[$ "gate"];
    instance_create_depth(_m.x, _m.y, 0, obj_gate);
}

// Construye las capas de tiles desde el mapa de texto
//   _rows   : array de strings (una por fila)
//   _legend : array de pares [carácter, nombre de marcador]
function world_build_placeholder_map(_rows, _legend) {
    var _h = array_length(_rows);
    var _w = string_length(_rows[0]);

    // Capas: Ground (suelo, al fondo) y Solid (obstáculos, sobre el suelo).
    var _lg = layer_create(300, "Ground");
    var _ls = layer_create(200, "Solid");
    var _tg = layer_tilemap_create(_lg, 0, 0, ts_village, _w, _h);
    var _ts = layer_tilemap_create(_ls, 0, 0, ts_village, _w, _h);
    global.tm_ground = _tg;
    global.tm_solid  = _ts;

    for (var _y = 0; _y < _h; _y++) {
        for (var _x = 0; _x < _w; _x++) {
            var _ch = string_char_at(_rows[_y], _x + 1);
            var _g  = T_GRASS;      // suelo de esta casilla
            var _s  = T_EMPTY;      // obstáculo de esta casilla

            switch (_ch) {
                case ",": _g = T_GRASS2; break;
                case "=": _g = T_PATH;   break;
                case "~": _g = T_WATER;  break;
                case "B": _g = T_BRIDGE; break;
                case "D": _g = T_DOOR;   break;
                case "T": _s = T_TREE;   break;
                case "W": _s = T_WALL;   break;
                case "R": _s = T_ROOF;   break;
                case "F": _s = T_FENCE;  break;
                case "S": _s = T_STONE;  break;

                case "X":                                   // salida este
                    _g = T_PATH;
                    break;

                default:                                    // ¿es un marcador de la leyenda?
                    for (var k = 0; k < array_length(_legend); k++) {
                        if (_legend[k][0] == _ch) {
                            _g = T_PATH;
                        }
                    }
                    break;
            }

            tilemap_set(_tg, _g, _x, _y);
            if (_s != T_EMPTY) tilemap_set(_ts, _s, _x, _y);
        }
    }
}
