// Script que inicia el combate contra un enemigo (lo llama el objeto obj_enemy al tocar al jugador)
//   _enemy_id   : id del enemigo en el banco ("hombrelobo", "golem", ...)
//   _enemy_inst : instancia del enemigo en el mundo (se elimina al ganar)
function battle_begin(_enemy_id, _enemy_inst) {
    if (ui_modal_active()) return noone;
    var _b = instance_create_depth(0, 0, -50, obj_battle);
    _b.start(_enemy_id, _enemy_inst);
    return _b;
}

// Check de ¿hay un combate en curso? (se ignora uno que ya se está cerrando)
function battle_active() {
    var _active = false;
    with (obj_battle) {
        if (!closing) _active = true;
    }
    return _active;
}

// Margen de gracia tras un combate: los enemigos no pueden iniciar otro de inmediato (global.battle_grace_until lo fija obj_battle al terminar)
function battle_grace_ok() {
    if (!variable_global_exists("battle_grace_until")) return true;
    return (current_time >= global.battle_grace_until);
}

// Frases del enemigo antes y después del combate
function battle_intro_lines(_id) {
    var _t = global.src_text[$ _id];
    if (!is_undefined(_t) && variable_struct_exists(_t, "intro")) return _t.intro;
    return [ "¡" + global.bank_src[$ _id].name + " te corta el paso!" ];
}

function battle_win_lines(_id) {
    var _t = global.src_text[$ _id];
    if (!is_undefined(_t) && variable_struct_exists(_t, "win")) return _t.win;
    return [ "¡" + global.bank_src[$ _id].name + " ha sido derrotado!" ];
}

// Fotograma de spr_enemy para cada enemigo
function enemy_look_frame(_id) {
    switch (_id) {
        case "hombrelobo": return 0;
        case "golem":      return 1;
        case "arana":      return 2;
        case "sombra":     return 3;
        case "guerrero":   return 4;
        case "centinela":  return 5;
        case "espectro":   return 6;
        case "esqueleto":  return 7;
    }
    return 0;
}
