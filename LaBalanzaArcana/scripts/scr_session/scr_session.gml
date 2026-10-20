// Script de configuración de la recolección de datos, código de participante, inicio y fin de sesión

// Configuración:
#macro LAST_PLAYABLE_LEVEL 4

// Prefijo del archivo de datos: balanza_<CODIGO>.csv
#macro LOG_FILE_PREFIX "balanza_"

// Subida automática: URL de la aplicación web de Google Apps Script. Vacío = desactivada; los datos igual quedan en el CSV local
#macro LOG_UPLOAD_URL ""

// Código de participante:
// Regla definida: 2 letras del nombre + 2 letras del apellido + día de nacimiento con 2 cifras (ej.: NAGO15). Total: 6 caracteres
#macro CODE_LEN 6

// Convierte un carácter escrito a mayúscula sin tilde (ñ -> N). Devuelve "" si no es una letra A-Z ni un dígito
function code_char(_ch) {
    var _c = _ch;
    switch (_c) {
        case "á": case "Á": case "à": case "À": case "ä": case "Ä": _c = "A"; break;
        case "é": case "É": case "è": case "È": case "ë": case "Ë": _c = "E"; break;
        case "í": case "Í": case "ì": case "Ì": case "ï": case "Ï": _c = "I"; break;
        case "ó": case "Ó": case "ò": case "Ò": case "ö": case "Ö": _c = "O"; break;
        case "ú": case "Ú": case "ù": case "Ù": case "ü": case "Ü": _c = "U"; break;
        case "ñ": case "Ñ": _c = "N"; break;
    }
    _c = string_upper(_c);
    var _o = ord(_c);
    if ((_o >= 65 && _o <= 90) || (_o >= 48 && _o <= 57)) return _c;
    return "";
}

// Deja solo letras A-Z y dígitos, en mayúscula, con el largo máximo
function code_sanitize(_s) {
    var _out = "";
    for (var i = 1; i <= string_length(_s); i++) {
        _out += code_char(string_char_at(_s, i));
    }
    return string_copy(_out, 1, CODE_LEN);
}

// 4 letras + 2 cifras entre 01 y 31
function code_is_valid(_s) {
    if (string_length(_s) != CODE_LEN) return false;
    for (var i = 1; i <= 4; i++) {
        var _o = ord(string_char_at(_s, i));
        if (_o < 65 || _o > 90) return false;
    }
    var _day = string_copy(_s, 5, 2);
    if (string_digits(_day) != _day) return false;
    var _d = real(_day);
    return (_d >= 1 && _d <= 31);
}

function code_error_text(_s) {
    if (string_length(_s) < CODE_LEN) {
        return "Faltan caracteres: son 4 letras y 2 números (" + string(CODE_LEN) + " en total).";
    }
    for (var i = 1; i <= 4; i++) {
        var _o = ord(string_char_at(_s, i));
        if (_o < 65 || _o > 90) return "Los primeros 4 caracteres deben ser letras.";
    }
    return "Los 2 últimos son el día de nacimiento: de 01 a 31.";
}

// Sesión:
// Inicia una sesión de juego para un participante: reinicia la partida, abre su archivo de datos y deja constancia del inicio
function session_start(_code) {
    global.player_code = _code;
    global.session_id  = session_stamp();
    progress_reset();                 // partida nueva (puntaje, vida, misiones, etc.)
	level_checkpoint_save(1);
    log_init();                       // crea el archivo con su encabezado si no existe
    log_event("sesion_inicio", "build=" + GAME_VERSION);
}

// Resumen de la sesión en una sola línea, para copiar y pegar en un formulario
function session_summary_text() {
    var _s = "BALANZA|v" + GAME_VERSION + "|" + global.player_code + "|" + global.session_id
           + "|puntos=" + string(global.score)
           + "|insignias=" + string(array_length(global.badges));
    for (var l = 1; l <= MAX_LEVEL; l++) {
        var _st = level_stats(l);
        if (_st.total <= 0) continue;
        _s += "|N" + string(l) + ":pts=" + string(_st.points)
            + ",1ro=" + string(_st.first)
            + ",2do=" + string(_st.second)
            + ",fallos=" + string(_st.failed)
            + ",vida=" + string(round(_st.life_lost));
    }
    return _s;
}

// Abre la carpeta donde se guardan los datos (solo escritorio)
function open_data_folder() {
    if (os_type == os_windows) {
        execute_shell_simple(game_save_id);
        return true;
    }
    return false;
}

// Pantalla de fin de sesión:
function session_end_show() {
    if (session_end_active()) return noone;
    var _e = instance_create_depth(0, 0, -950, obj_session_end);
    return _e;
}

function session_end_active() {
    var _active = false;
    with (obj_session_end) {
        if (!closing) _active = true;
    }
    return _active;
}

// ¿Hay algo "modal" abierto que deba congelar el mundo?
function ui_modal_active() {
    return exercise_active() || dialogue_active() || results_active()
        || session_end_active() || transition_active() || battle_active()
        || choice_active() || boss_active() || system_menu_active();
}
