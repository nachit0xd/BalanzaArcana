// Script de estructura del Banco de ejercicios de La Balanza Arcana.

// Símbolos
#macro SYM_SQ  chr(178)                // ²
#macro SYM_X1  ("x" + chr(8321))       // x₁
#macro SYM_X2  ("x" + chr(8322))       // x₂

// Función que se llama una vez desde obj_game (Create), después de config_init().
function bank_init() {
    global.bank_list  = [];   // todos los ejercicios, en orden fijo
    global.bank_by_id = {};   // id -> ejercicio
    global.bank_src   = {};   // id de NPC/enemigo -> datos
    global.decks      = {};   // barajas en curso (ver deck_get)

    bank_load_math();
    bank_text_init();

    if (DEBUG_MODE) {
        var _ok = bank_validate();
        if (!_ok) show_message("El banco tiene errores. Revisa la consola (Output).");
    }
}

// Registro de orígenes (NPC, enemigos, jefe)
//   _kind: "npc" | "enemy" | "boss"
//   _hp  : puntos de energía del enemigo (en el jefe = nº de sellos)
function src_add(_id, _name, _kind, _level, _hp) {
    global.bank_src[$ _id] = { id:_id, name:_name, kind:_kind, level:_level, hp:_hp, order:[] };
}

function ex_add(_ex) {
    array_push(global.bank_list, _ex);
    global.bank_by_id[$ _ex.id] = _ex;
    if (variable_struct_exists(global.bank_src, _ex.src)) {
        array_push(global.bank_src[$ _ex.src].order, _ex.id);
    }
    return _ex;
}

// Constructores de ejercicios (campos: a, b, c, d según el nivel)
// Nivel 1:  a + x = c
function eq1(_id, _src, _a, _c, _x) {
    return ex_add({ id:_id, level:1, src:_src, a:_a, b:1, c:_c, d:0, sol:[_x] });
}
// Nivel 2:  a + b·x = c
function eq2(_id, _src, _a, _b, _c, _x) {
    return ex_add({ id:_id, level:2, src:_src, a:_a, b:_b, c:_c, d:0, sol:[_x] });
}
// Nivel 3:  a + b·x = c + d·x
function eq3(_id, _src, _a, _b, _c, _d, _x) {
    return ex_add({ id:_id, level:3, src:_src, a:_a, b:_b, c:_c, d:_d, sol:[_x] });
}
// Nivel 4:  x² + b·x + c = 0   (dos raíces enteras r1 y r2)
function eq4(_id, _src, _b, _c, _r1, _r2) {
    return ex_add({ id:_id, level:4, src:_src, a:1, b:_b, c:_c, d:0, sol:[_r1, _r2] });
}

function bank_get(_id) { return global.bank_by_id[$ _id]; }

// Baraja: entrega los ejercicios de cada origen en el orden de su banco.
// Si se agotan durante un combate largo, repite solo los de ese mismo origen
function deck_create(_src_id) {
    var _s = global.bank_src[$ _src_id];
    var _d = { src:_src_id, level:_s.level, queue:[], given:{} };
    for (var i = 0; i < array_length(_s.order); i++) array_push(_d.queue, _s.order[i]);
    return _d;
}

// Devuelve la baraja en curso de un origen (la crea si no existe). Se conserva entre reintentos: al repetir una batalla perdida se continúa con ejercicios aún no vistos.
function deck_get(_src_id) {
    if (!variable_struct_exists(global.decks, _src_id)) {
        global.decks[$ _src_id] = deck_create(_src_id);
    }
    return global.decks[$ _src_id];
}

// Siguiente ejercicio de la baraja (struct del banco)
function deck_next(_d) {
    var _id;
    if (array_length(_d.queue) > 0) {
        _id = _d.queue[0];
        array_delete(_d.queue, 0, 1);
    } else {
        _id = deck_extra_id(_d);
    }
    _d.given[$ _id] = true;
    return global.bank_by_id[$ _id];
}

function deck_extra_id(_d) {
	var _own = global.bank_src[$ _d.src].order;
    for (var pass = 0; pass < 2; pass++) {
		for (var i = 0; i < array_length(_own); i++) {
            if (!variable_struct_exists(_d.given, _own[i])) return _own[i];
        }
        _d.given = {};   // solo se reinicia el ciclo de este NPC/enemigo
    }
    return undefined;
}

// Reinicia todas las barajas (al empezar una partida nueva)
function decks_reset() { global.decks = {}; }