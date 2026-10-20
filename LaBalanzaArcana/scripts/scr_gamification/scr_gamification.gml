// Script de vida, estadísticas por nivel, insignias y pantalla de resultados

function level_name(_level) {
    switch (_level) {
        case 1: return "Aldea inicial";
        case 2: return "Bosque encantado";
        case 3: return "Castillo ruinoso";
        case 4: return "Batalla final";
    }
    return "";
}

// Estado de gamificación de una partida nueva (lo llama progress_reset)
function gamification_reset() {
    global.life      = 100;       // porcentaje de vida del nivel actual
    global.badges    = [];        // ids de las insignias ya obtenidas
    global.life_lost = {};        // "1" -> porcentaje de vida perdido en ese nivel
    badges_init();
}

// Vida:
// Resta vida (en puntos porcentuales) y lo anota en el nivel actual. Devuelve true si el jugador se quedó sin vida.
function life_lose(_pct) {
    var _before = global.life;
    global.life = max(0, global.life - _pct);

    var _key  = string(global.level);
    var _prev = variable_struct_exists(global.life_lost, _key) ? global.life_lost[$ _key] : 0;
    global.life_lost[$ _key] = _prev + (_before - global.life);

    return (global.life <= 0);
}

// La vida se restaura al iniciar cada nivel
function life_reset() {
    global.life = 100;
}

// Resultados: 
// Marcas para descartar los puntos de un combate perdido
function results_mark() {
    return array_length(global.results);
}

function results_rollback(_mark) {
    while (array_length(global.results) > _mark) {
        var _r = array_pop(global.results);
        global.score -= _r.points;
    }
}

// Estadísticas de un nivel (se calculan desde global.results)
function level_stats(_level) {
    var _s = {
        level: _level,
        points: 0,          // puntos ganados en el nivel
        total: 0,           // ejercicios presentados
        first: 0,           // resueltos al primer intento
        second: 0,          // resueltos al segundo intento
        failed: 0,          // sin resolver (incluye tiempo agotado)
        timeouts: 0,        // de los anteriores, por tiempo agotado
        fast: 0,            // primer intento con más del 50 % del tiempo (solo batalla)
        life_lost: 0        // % de vida perdido en el nivel
    };

    for (var i = 0; i < array_length(global.results); i++) {
        var _r = global.results[i];
        if (_r.level != _level) continue;

        _s.total++;
        _s.points += _r.points;

        if (_r.correct) {
            if (_r.attempt == 1) _s.first++; else _s.second++;
        } else {
            _s.failed++;
            if (_r.timed_out) _s.timeouts++;
        }

        if (_r.ctx == "battle" && _r.correct && _r.attempt == 1
            && _r.time_left_pct > global.cfg.bonus_threshold) {
            _s.fast++;
        }
    }

    var _key = string(_level);
    _s.life_lost = variable_struct_exists(global.life_lost, _key) ? global.life_lost[$ _key] : 0;
    return _s;
}

// Aciertos y fallos por NPC/enemigo del nivel, en el orden del banco
function source_stats(_level) {
    var _ids = [];
    for (var i = 0; i < array_length(global.bank_list); i++) {
        var _ex = global.bank_list[i];
        if (_ex.level != _level) continue;
        var _seen = false;
        for (var j = 0; j < array_length(_ids); j++) {
            if (_ids[j] == _ex.src) _seen = true;
        }
        if (!_seen) array_push(_ids, _ex.src);
    }

    var _rows = [];
    for (var k = 0; k < array_length(_ids); k++) {
        var _row = { name: global.bank_src[$ _ids[k]].name, first: 0, second: 0, failed: 0 };
        for (var n = 0; n < array_length(global.results); n++) {
            var _r = global.results[n];
            if (_r.src != _ids[k]) continue;
            if (_r.correct) {
                if (_r.attempt == 1) _row.first++; else _row.second++;
            } else {
                _row.failed++;
            }
        }
        array_push(_rows, _row);
    }
    return _rows;
}

// Insignias:
// Cada una se obtiene una sola vez por partida. Se evalúan al cerrar un nivel. "hidden: true" las mostraría como "???" hasta obtenerlas
function badges_init() {
    global.badge_defs = [
        {   id: "equilibrio_inicial", name: "Equilibrio inicial", hidden: false,
            desc: "Completar el Nivel 1.",
            check: function(_lv) { return (_lv == 1); } },

        {   id: "mente_veloz", name: "Mente veloz", hidden: false,
            desc: "Resolver 3 ejercicios al primer intento con más del 50 % del tiempo restante, dentro de un mismo nivel.",
            check: function(_lv) { return (level_stats(_lv).fast >= 3); } },

        {   id: "balanza_intacta", name: "Balanza intacta", hidden: false,
            desc: "Completar un nivel sin perder vida.",
            check: function(_lv) { return (level_stats(_lv).life_lost <= 0); } },

        {   id: "dominio_arcano", name: "Dominio arcano", hidden: false,
            desc: "Resolver al primer intento al menos el 80 % de los ejercicios de un nivel.",
            check: function(_lv) {
                var _s = level_stats(_lv);
                return (_s.total > 0 && (_s.first / _s.total) >= 0.8);
            } },

        {   id: "guardian_balanza", name: "Guardián de la Balanza", hidden: false,
            desc: "Derrotar al jefe final sin perder vida durante la batalla.",
            check: function(_lv) { return (_lv == 4 && level_stats(4).life_lost <= 0); } },

        {   id: "heroe_social", name: "Héroe social", hidden: false,
            desc: "Completar todas las misiones de NPC de todos los niveles.",
            check: function(_lv) { return all_npc_missions_done(); } },

        {   id: "rey_equilibrio", name: "El Rey del Equilibrio", hidden: false,
            desc: "Completar todos los niveles sin perder vida y resolver los combates con más del 50 % del tiempo.",
            check: function(_lv) { return (_lv == 4 && game_flawless()); } }
    ];
}

function badge_owned(_id) {
    for (var i = 0; i < array_length(global.badges); i++) {
        if (global.badges[i] == _id) return true;
    }
    return false;
}

// Check de ¿todas las misiones de NPC de todos los niveles están hechas?
function all_npc_missions_done() {
    var _names = variable_struct_get_names(global.bank_src);
    for (var i = 0; i < array_length(_names); i++) {
        var _s = global.bank_src[$ _names[i]];
        if (_s.kind == "npc" && !quest_get(_s.id).done) return false;
    }
    return true;
}

// Para la insignia "El Rey del Equilibrio": 4 niveles completos, sin perder vida y todos los combates resueltos con más del 50 % del tiempo restante
function game_flawless() {
    for (var l = 1; l <= MAX_LEVEL; l++) {
        if (!variable_struct_exists(global.level_done, string(l))) return false;
        if (level_stats(l).life_lost > 0) return false;
    }
    for (var i = 0; i < array_length(global.results); i++) {
        var _r = global.results[i];
        if (_r.ctx == "battle" && !(_r.correct && _r.time_left_pct > global.cfg.bonus_threshold)) return false;
    }
    return true;
}

// Evalúa las insignias al cerrar un nivel y devuelve las nuevas. _commit = false permite previsualizar sin guardar nada
function badges_evaluate(_level, _commit) {
    var _new = [];
    for (var i = 0; i < array_length(global.badge_defs); i++) {
        var _b = global.badge_defs[i];
        if (badge_owned(_b.id)) continue;
        if (_b.check(_level)) {
            array_push(_new, _b);
            if (_commit) array_push(global.badges, _b.id);
        }
    }
    return _new;
}

// Pantalla de resultados:
function results_show(_level, _preview) {
    if (results_active()) return noone;
    var _r = instance_create_depth(0, 0, -950, obj_results);
    _r.start(_level, _preview);
    return _r;
}

function results_active() {
    var _active = false;
    with (obj_results) {
        if (!closing) _active = true;
    }
    return _active;
}

