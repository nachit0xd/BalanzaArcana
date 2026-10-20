// Script para la batalla contra El Rey del Desequilibrio

// Inicia la batalla final (lo llama obj_boss_room al entrar a la sala del jefe)
function boss_begin() {
    if (ui_modal_active()) return noone;
    var _b = instance_create_depth(0, 0, -50, obj_boss);
    _b.start();
    return _b;
}

// Check de ¿hay una batalla final en curso? (se ignora una que ya se está cerrando)
function boss_active() {
    var _active = false;
    with (obj_boss) {
        if (!closing) _active = true;
    }
    return _active;
}

// Frases del jefe. Se definen en global.src_text[$ "rey_desequilibrio"] = { intro: [...], win: [...] }.
function boss_intro_lines() {
    var _t = global.src_text[$ "rey_desequilibrio"];
    if (!is_undefined(_t) && variable_struct_exists(_t, "intro")) return _t.intro;
    return [ "Así que tú eres el aprendiz que se atreve a equilibrar mi reino...",
             "Tres sellos protegen mi poder. ¡Rómpelos si puedes, y dime las dos soluciones de cada uno!" ];
}

function boss_win_lines() {
    var _t = global.src_text[$ "rey_desequilibrio"];
    if (!is_undefined(_t) && variable_struct_exists(_t, "win")) return _t.win;
    return [ "Imposible... los números vuelven a coincidir a ambos lados...",
             "El Desequilibrio se desvanece y la Balanza Arcana brilla de nuevo." ];
}

// Frases del jefe cuando el escudo cae (empieza la segunda etapa)
function boss_shield_lines() {
    var _t = global.src_text[$ "rey_desequilibrio"];
    if (!is_undefined(_t) && variable_struct_exists(_t, "shield")) return _t.shield;
    return [ "¡Mi escudo...! No importa: sin él aún puedo derrotarte.",
             "¡Ahora cada golpe tuyo contará! Pero cada error tuyo también." ];
}
