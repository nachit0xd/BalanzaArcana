// Controla una misión de NPC de principio a fin:
//   [tutorial del maestro, solo la 1.ª vez del nivel] -> introducción del NPC
//   -> sus ejercicios, uno tras otro -> cierre del NPC (+ consejo)
//   -> misión marcada como hecha -> revisión de cierre de nivel.

npc_id = "";
src    = undefined;        // datos del NPC en el banco
deck   = undefined;        // sus ejercicios, en orden fijo
total  = 0;                // cuántos ejercicios tiene la misión
n_done = 0;                // cuántos van

// Inicio
// (El tutorial del maestro ya no va aquí: se muestra al inicio del nivel,
//  ver level_intro_start en scr_quests.)
start = function(_npc_id) {
    npc_id = _npc_id;
    src    = global.bank_src[$ npc_id];
    deck   = deck_create(npc_id);          // baraja propia: si se interrumpe, se reinicia igual
    total  = array_length(src.order);
    n_done = 0;
    intro();
};

// Introducción del NPC
intro = function() {
    var _t = global.src_text[$ npc_id];
    if (is_undefined(_t) || !variable_struct_exists(_t, "intro")) { next_exercise(); return; }
    dialogue_start(_t.intro, src.name, next_exercise);
};

// Ejercicios, uno tras otro
next_exercise = function() {
    if (n_done >= total) { outro(); return; }

    var _ex    = deck_next(deck);
    var _first = first_exercise_of_level(src.level);   // 1.º del nivel -> pista por defecto

    exercise_launch(_ex, "npc", _first, on_exercise_done);
};

on_exercise_done = function(_r) {
    record_result(_r);          // suma puntos y guarda el resultado
    n_done++;
    next_exercise();            // aunque falle se continúa con la misión
};

// Cierre del NPC + consejo
outro = function() {
    var _lines = [];
    var _t = global.src_text[$ npc_id];
    if (!is_undefined(_t)) {
        if (variable_struct_exists(_t, "outro")) {
            for (var i = 0; i < array_length(_t.outro); i++) array_push(_lines, _t.outro[i]);
        }
        if (variable_struct_exists(_t, "tip")) array_push(_lines, "Consejo: " + _t.tip);
    }
    if (array_length(_lines) == 0) finish();
    else dialogue_start(_lines, src.name, finish);
};

// Fin de la misión
finish = function() {
    quest_get(npc_id).done = true;
    var _lvl = src.level;
    instance_destroy();
    quest_check_level(_lvl);    // ¿se completó el nivel?
};
