// Script de registro de datos de la sesión
//  1) Por defectp: archivo CSV local  balanza_<CODIGO>.csv  (se agrega una fila por evento y se cierra el archivo en cada escritura, así no se pierde nada si el juego se cierra de golpe).
//  2) Opcional: subida automática de las mismas filas a una hoja de Google (si LOG_UPLOAD_URL no está vacía). Si falla, el CSV local no se afecta y la subida se reintenta sola.

// El CSV usa ";" como separador (así se abre bien con doble clic en Excel en español) y solo caracteres ASCII

// Columnas del archivo (17 en total)
function log_header() {
    return "tipo;codigo;sesion;version;fecha_hora;nivel;contexto;origen;ejercicio_id;ecuacion;intento;respuesta;correcto;tiempo_agotado;tiempo_ms;limite_s;detalle";
}

// Estado del sistema de registro. obj_game lo llama una vez (evento Create)
function log_system_init() {
    global.session_id     = "";
    global.log_ready      = false;    // true cuando hay un archivo abierto para el participante
    global.upload_queue   = [];       // filas pendientes de subir
    global.upload_busy    = false;    // hay una solicitud en curso
    global.upload_req     = -1;       // id de la solicitud en curso
    global.upload_batch_n = 0;        // cuántas filas lleva esa solicitud
    global.upload_sent    = 0;        // filas ya subidas
    global.upload_fail    = 0;        // fallos seguidos
    global.upload_retry_at = 0;       // no reintentar antes de este instante
}

// Utilidades
function pad2(_n) {
    return ((_n < 10) ? "0" : "") + string(_n);
}

// "2026-10-09 14:03:22" (hora local del equipo)
function datetime_text() {
    var _d = date_current_datetime();
    return string(date_get_year(_d)) + "-" + pad2(date_get_month(_d)) + "-" + pad2(date_get_day(_d))
         + " " + pad2(date_get_hour(_d)) + ":" + pad2(date_get_minute(_d)) + ":" + pad2(date_get_second(_d));
}

// "20261009-140322": identifica cada sesión de juego
function session_stamp() {
    var _d = date_current_datetime();
    return string(date_get_year(_d)) + pad2(date_get_month(_d)) + pad2(date_get_day(_d))
         + "-" + pad2(date_get_hour(_d)) + pad2(date_get_minute(_d)) + pad2(date_get_second(_d));
}

// Función que deja un valor listo para una celda: sin ";" ni saltos de línea y sin "²"
function csv_clean(_v) {
    var _s = string(_v);
    _s = string_replace_all(_s, SYM_SQ, "^2");
    _s = string_replace_all(_s, ";", "|");
    _s = string_replace_all(_s, "\n", " ");
    _s = string_replace_all(_s, "\r", " ");
    return _s;
}

function log_file_name() { return LOG_FILE_PREFIX + global.player_code + ".csv"; }
function log_file_path() { return game_save_id + log_file_name(); }

// Apertura del archivo del participante (la llama session_start)
function log_init() {
    global.log_ready = false;
    if (global.player_code == "") return;

    var _path = log_file_path();
    if (!file_exists(_path)) {
        var _f = file_text_open_write(_path);
        if (_f == -1) {
            show_debug_message("LOG: no se pudo crear " + _path);
            return;
        }
        file_text_write_string(_f, log_header());
        file_text_writeln(_f);
        file_text_close(_f);
    }
    global.log_ready = true;
    show_debug_message("LOG: archivo de datos -> " + _path);
}

// Escritura de filas:
// Las 5 primeras columnas, comunes a todo evento
function log_base(_tipo) {
    return [ _tipo, global.player_code, global.session_id, GAME_VERSION, datetime_text() ];
}

// Escribe una fila (array de 17 valores) en el CSV y la pone en cola de subida
function log_write(_cols) {
    if (!global.log_ready) return;

    var _line = "";
    for (var i = 0; i < array_length(_cols); i++) {
        _line += ((i > 0) ? ";" : "") + csv_clean(_cols[i]);
    }

    var _f = file_text_open_append(log_file_path());
    if (_f != -1) {
        file_text_write_string(_f, _line);
        file_text_writeln(_f);
        file_text_close(_f);
    } else {
        show_debug_message("LOG: no se pudo escribir en " + log_file_path());
    }
    log_upload_enqueue(_cols);
}

// Evento sin ejercicio (inicio/fin de sesión, etc.)
function log_event(_tipo, _detalle) {
    var _row = log_base(_tipo);
    for (var i = 0; i < 11; i++) array_push(_row, "");    // nivel ... limite_s
    array_push(_row, _detalle);
    log_write(_row);
}

// Un único intento de respuesta. Es la llamada que ya hace obj_exercise: _r = { ex, ctx, attempt, answer, correct, ms, timeout }
function log_attempt(_r) {
    var _ex    = _r.ex;
    var _limit = (_r.ctx == "battle") ? cfg_time(_ex.level) : 0;

    var _row = log_base("intento");
    array_push(_row, _ex.level);
    array_push(_row, _r.ctx);
    array_push(_row, _ex.src);
    array_push(_row, _ex.id);
    array_push(_row, ex_equation_string(_ex));
    array_push(_row, _r.attempt);
    array_push(_row, _r.answer);
    array_push(_row, _r.correct ? 1 : 0);
    array_push(_row, _r.timeout ? 1 : 0);
    array_push(_row, _r.ms);
    array_push(_row, _limit);
    array_push(_row, "");

    if (DEBUG_MODE) {
        show_debug_message("LOG | " + _ex.id + " | intento " + string(_r.attempt) + " | resp='" + _r.answer + "' | "
            + (_r.correct ? "CORRECTA" : "incorrecta") + (_r.timeout ? " | TIEMPO AGOTADO" : "") + " | " + string(_r.ms) + " ms");
    }
    log_write(_row);
}

// Resumen de un nivel (se registra al abrir su pantalla de resultados)
function log_level_summary(_level, _stats, _new_badges) {
    var _b = "";
    for (var i = 0; i < array_length(_new_badges); i++) {
        _b += ((i > 0) ? "," : "") + _new_badges[i].id;
    }
    var _d = "puntos=" + string(_stats.points)
           + "|primer=" + string(_stats.first)
           + "|segundo=" + string(_stats.second)
           + "|sin_resolver=" + string(_stats.failed)
           + "|vida_perdida=" + string(round(_stats.life_lost))
           + "|puntaje_total=" + string(global.score)
           + "|insignias_nuevas=" + _b;

    var _row = log_base("nivel_completo");
    array_push(_row, _level);
    for (var j = 0; j < 10; j++) array_push(_row, "");        // contexto ... limite_s
    array_push(_row, _d);
    log_write(_row);
}


// Subida automática (opcional):
function log_upload_enqueue(_cols) {
    if (LOG_UPLOAD_URL == "") return;
    var _row = [];
    for (var i = 0; i < array_length(_cols); i++) array_push(_row, csv_clean(_cols[i]));
    array_push(global.upload_queue, _row);
}

// Se llama en cada evento Step de obj_game: envía hasta 20 filas por solicitud
function log_upload_pump() {
    if (LOG_UPLOAD_URL == "" || global.upload_busy) return;
    if (array_length(global.upload_queue) == 0) return;
    if (current_time < global.upload_retry_at) return;

    var _n = min(20, array_length(global.upload_queue));
    var _batch = [];
    for (var i = 0; i < _n; i++) array_push(_batch, global.upload_queue[i]);

    var _hdr = ds_map_create();
    _hdr[? "Content-Type"] = "text/plain";      // evita la verificación previa (CORS) en HTML5
    global.upload_req     = http_request(LOG_UPLOAD_URL, "POST", _hdr, json_stringify(_batch));
    global.upload_batch_n = _n;
    global.upload_busy    = true;
    ds_map_destroy(_hdr);
}

// Se llama desde obj_game, evento Async - HTTP
function log_http_response(_load) {
    if (_load[? "id"] != global.upload_req) return;
    var _status = _load[? "status"];            // 1 = en curso, 0 = terminó, <0 = error
    if (_status == 1) return;

    global.upload_busy = false;
    var _code = _load[? "http_status"];

    // Apps Script responde 200 (o una redirección 302 tras ejecutar el script)
    if (_status == 0 && (_code == 200 || _code == 302)) {
        array_delete(global.upload_queue, 0, global.upload_batch_n);
        global.upload_sent += global.upload_batch_n;
        global.upload_fail  = 0;
    } else {
        global.upload_fail++;
        global.upload_retry_at = current_time + min(60000, 3000 * global.upload_fail);
        show_debug_message("LOG: fallo de subida (estado " + string(_status) + ", http " + string(_code) + "); se reintentará.");
    }
}

// Texto de estado de la subida, para la pantalla de fin de sesión
function log_upload_status() {
    if (LOG_UPLOAD_URL == "") return "Subida automática: desactivada (los datos quedan en el archivo).";
    var _pend = array_length(global.upload_queue);
    if (_pend == 0) return "Subida automática: todo enviado (" + string(global.upload_sent) + " filas).";
    return "Subida automática: " + string(global.upload_sent) + " enviadas, " + string(_pend) + " pendientes...";
}
