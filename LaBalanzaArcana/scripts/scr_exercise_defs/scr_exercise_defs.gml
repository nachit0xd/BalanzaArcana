// Script de definiciones compartidas por obj_exercise y obj_answer_box

// Estados del flujo de un ejercicio:
//  ASK1   : primer intento (entrada activa, cronómetro si es batalla)
//  WRONG1 : falló el 1.º intento -> muestra la pista (sin dar la respuesta)
//  ASK2   : segundo intento (la pista sigue visible)
//  KCR    : falló el 2.º intento o se acabó el tiempo -> respuesta + procedimiento
//  OK     : acertó -> refuerzo positivo + puntos
enum EX_STATE { ASK1, WRONG1, ASK2, KCR, OK }

// Frames en que se ignora Enter/Espacio tras entrar a un estado de feedback
#macro EX_FEEDBACK_LOCK 15

// Paleta provisional
#macro COL_PANEL     make_colour_rgb(28, 22, 46)
#macro COL_BORDER    make_colour_rgb(120, 96, 200)
#macro COL_TEXT      make_colour_rgb(240, 236, 255)
#macro COL_DIM       make_colour_rgb(160, 150, 190)
#macro COL_GOOD      make_colour_rgb(110, 220, 130)
#macro COL_BAD       make_colour_rgb(240, 100, 100)
#macro COL_WARN      make_colour_rgb(250, 210, 90)
#macro COL_INPUT_BG  make_colour_rgb(12, 10, 24)

// Validación de lo que escribe el jugador
// Función que deja solo dígitos y un "-" al inicio; recorta al largo máximo
function answer_sanitize(_s, _max) {
    var _out = "";
    for (var i = 1; i <= string_length(_s); i++) {
        var _ch = string_char_at(_s, i);
        if (string_digits(_ch) != "") {
            _out += _ch;                                          // dígito
        } else if (_ch == "-" && string_length(_out) == 0) {
            _out += _ch;                                          // "-" solo al inicio
        }
    }
    return string_copy(_out, 1, _max);
}

// Check de ¿es un entero bien escrito? ("" y "-" NO lo son)
function answer_is_valid(_s) {
    var _n = string_length(_s);
    if (_n == 0) return false;
    var _start = (string_char_at(_s, 1) == "-") ? 2 : 1;
    if (_start > _n) return false;                                // solo "-"
    return (string_length(string_digits(_s)) == (_n - _start + 1)); // el resto son dígitos
}

// Solo llamar si la función answer_is_valid(_s) es true (real() falla con texto inválido)
function answer_parse(_s) {
    return real(_s);
}

// Lanzador de ejercicios
// _ex             : ejercicio del banco (struct)
// _ctx            : "npc" (sin cronómetro) | "battle" (con cronómetro y bono)
// _first_of_level : true -> muestra la pista por defecto (primer ejercicio del nivel)
// _on_done        : function(result) que se ejecuta al terminar (puede ser undefined)
function exercise_launch(_ex, _ctx, _first_of_level, _on_done, _time) {
    if (exercise_active()) return noone;
    var _inst = instance_create_depth(0, 0, -1000, obj_exercise);
    _inst.start(_ex, _ctx, _first_of_level, _on_done, _time);
    return _inst;
}

// Dibuja texto con salto de línea a escala _s y devuelve su alto
function draw_text_scaled(_x, _y, _str, _sep, _w, _s) {
    draw_text_ext_transformed(_x, _y, _str, _sep / _s, _w / _s, _s, _s, 0);
    return string_height_ext(_str, _sep / _s, _w / _s) * _s;
}

// Check de ¿hay un ejercicio abierto? (se ignora uno que ya se está cerrando)
function exercise_active() {
    var _active = false;
    with (obj_exercise) {
        if (!closing) _active = true;
    }
    return _active;
}