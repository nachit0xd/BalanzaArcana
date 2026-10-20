// Script de opciones del juego (se guardan en un archivo) y menú de pausa

#macro OPT_FILE "balanza_opciones.ini"

// Opciones:
//   vol_master / vol_music / vol_sfx : 0 a 100 (de 10 en 10)
//   fullscreen    : pantalla completa sí/no
//   text_speed    : 0 lenta | 1 normal | 2 rápida (diálogos)
//   hints_always  : mostrar el recordatorio de ayuda en todos los ejercicios
function options_defaults() {
    return { vol_master: 80, vol_music: 70, vol_sfx: 80, fullscreen: false, win_size: 0, text_speed: 1, hints_always: false };
}

// Lee el archivo de opciones (si no existe, usa los valores por defecto)
function options_load() {
    global.opt = options_defaults();
    global.win_apply_t = 0;               // frames que faltan para aplicar el tamaño de la ventana
    ini_open(game_save_id + OPT_FILE);
    global.opt.vol_master   = clamp(ini_read_real("opciones", "vol_master", global.opt.vol_master), 0, 100);
    global.opt.vol_music    = clamp(ini_read_real("opciones", "vol_music",  global.opt.vol_music),  0, 100);
    global.opt.vol_sfx      = clamp(ini_read_real("opciones", "vol_sfx",    global.opt.vol_sfx),    0, 100);
    global.opt.fullscreen   = (ini_read_real("opciones", "fullscreen", 0) == 1);
    global.opt.win_size     = clamp(ini_read_real("opciones", "win_size", 0), 0, 4);
    global.opt.text_speed   = clamp(ini_read_real("opciones", "text_speed", 1), 0, 2);
    global.opt.hints_always = (ini_read_real("opciones", "hints_always", 0) == 1);
    ini_close();
}

function options_save() {
    ini_open(game_save_id + OPT_FILE);
    ini_write_real("opciones", "vol_master",   global.opt.vol_master);
    ini_write_real("opciones", "vol_music",    global.opt.vol_music);
    ini_write_real("opciones", "vol_sfx",      global.opt.vol_sfx);
    ini_write_real("opciones", "fullscreen",   global.opt.fullscreen ? 1 : 0);
    ini_write_real("opciones", "win_size",     global.opt.win_size);
    ini_write_real("opciones", "text_speed",   global.opt.text_speed);
    ini_write_real("opciones", "hints_always", global.opt.hints_always ? 1 : 0);
    ini_close();
}

// Aplica lo que se puede aplicar de inmediato (volumen y pantalla)
function options_apply() {
    audio_master_gain(global.opt.vol_master / 100);
    if (window_get_fullscreen() != global.opt.fullscreen) window_set_fullscreen(global.opt.fullscreen);
    // En ventana, el tamaño se aplica unos frames después (obj_game, Step): al salir de
    // pantalla completa el sistema puede ignorar un cambio de tamaño hecho de inmediato.
    if (!global.opt.fullscreen) global.win_apply_t = 3;
}

// Tamaño de la pantalla:
function win_scale_fit() {
    var _s = min((display_get_width() - 80) / GUI_W, (display_get_height() - 140) / GUI_H);
    return clamp(floor(_s * 4) / 4, 0.75, 3);
}

function win_scale_for(_idx) {
    var _fit = win_scale_fit();
    switch (_idx) {
        case 1: return min(1.0,  _fit);
        case 2: return min(1.25, _fit);
        case 3: return min(1.5,  _fit);
        case 4: return min(2.0,  _fit);
    }
    return _fit;                                  // 0 = automática
}

function window_apply_size() {
    if (window_get_fullscreen()) return;
    var _s = win_scale_for(global.opt.win_size);
    window_set_size(round(GUI_W * _s), round(GUI_H * _s));
    window_center();
}

// Ganancias de música y efectos (las usa scr_audio)
function opt_music_gain() { return global.opt.vol_music / 100; }
function opt_sfx_gain()   { return global.opt.vol_sfx / 100; }

// Letras por frame de los diálogos según la opción de velocidad
function opt_text_cps() {
    return [0.45, 0.7, 1.4][global.opt.text_speed];
}

// Resumen en una línea, para el registro de datos
function options_summary() {
    return "vol=" + string(global.opt.vol_master) + "/" + string(global.opt.vol_music) + "/" + string(global.opt.vol_sfx)
         + "|pantalla_completa=" + string(global.opt.fullscreen ? 1 : 0)
         + "|ventana=" + string(global.opt.win_size)
         + "|velocidad_texto=" + string(global.opt.text_speed)
         + "|pistas_permanentes=" + string(global.opt.hints_always ? 1 : 0);
}

// Menú de opciones (obj_options):
//   _on_close: function() que se ejecuta al cerrarlo (puede ser undefined)
function options_show(_on_close) {
    if (options_active()) return noone;
    var _o = instance_create_depth(0, 0, -915, obj_options);
    _o.start(_on_close);
    return _o;
}

function options_active() {
    var _active = false;
    with (obj_options) {
        if (!closing) _active = true;
    }
    return _active;
}

// Pausa (obj_pause):
//   Solo se puede pausar durante la exploración: no durante un diálogo, un ejercicio, un combate ni los resultados. Así nadie puede detener
//   el cronómetro de una pregunta (importa para los datos de la prueba)
function pause_allowed() {
    return instance_exists(obj_player) && !ui_modal_active() && global.player_code != "";
}

function pause_show() {
    if (!pause_allowed()) return noone;
    log_event("pausa_inicio", "");
    return instance_create_depth(0, 0, -910, obj_pause);
}

function pause_active() {
    var _active = false;
    with (obj_pause) {
        if (!closing) _active = true;
    }
    return _active;
}

// Cierra el menú de pausa (sin volver al menú principal)
function pause_close() {
    with (obj_pause) {
        closing = true;
        instance_destroy();
    }
    ui_block(10);
}

// Resultado de la pregunta "¿Volver al menú principal?"
function pause_exit_chosen(_index) {
    if (_index == 0) {
        log_event("sesion_abandonada", "nivel=" + string(global.level));
        pause_close();
        room_transition(rm_title);
    }
}

// Check de ¿algún menú de sistema abierto? (lo suma ui_modal_active)
function system_menu_active() {
    return pause_active() || options_active();
}
