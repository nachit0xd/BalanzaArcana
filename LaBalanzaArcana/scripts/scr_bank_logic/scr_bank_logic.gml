// Script que contiene todo lo que se DERIVA de los números del banco: texto de la ecuación,
// corrección de respuestas, recordatorio, pista y procedimiento.

// Utilidades de texto
function term_x(_k) {                       // 1 -> "x" ; 4 -> "4x"
    return (_k == 1) ? "x" : string(_k) + "x";
}

function signed_term(_k, _suffix) {         // 5,"x" -> " + 5x" ; -1,"x" -> " - x" ; 0 -> ""
    if (_k == 0) return "";
    var _sign = (_k > 0) ? " + " : " - ";
    var _abs  = abs(_k);
    var _num  = (_abs == 1 && _suffix != "") ? "" : string(_abs);
    return _sign + _num + _suffix;
}

function factor_str(_r) {                   // raíz 2 -> "(x - 2)" ; raíz -3 -> "(x + 3)"
    return "(x " + ((_r >= 0) ? "- " : "+ ") + string(abs(_r)) + ")";
}

// Ecuación y solución como texto
function ex_equation_string(_ex) {
    switch (_ex.level) {
        case 1: return string(_ex.a) + " + x = " + string(_ex.c);
        case 2: return string(_ex.a) + " + " + term_x(_ex.b) + " = " + string(_ex.c);
        case 3: return string(_ex.a) + " + " + term_x(_ex.b) + " = " + string(_ex.c) + " + " + term_x(_ex.d);
        case 4: return "x" + SYM_SQ + signed_term(_ex.b, "x") + signed_term(_ex.c, "") + " = 0";
    }
    return "?";
}

function ex_solution_string(_ex) {
    if (_ex.level < 4) return "x = " + string(_ex.sol[0]);
    return SYM_X1 + " = " + string(_ex.sol[0]) + "  y  " + SYM_X2 + " = " + string(_ex.sol[1]);
}

// Corrección
// ¿Cumple x con la ecuación? (se usa en el validador)
function ex_solves(_ex, _x) {
    switch (_ex.level) {
        case 1: return (_ex.a + _x == _ex.c);
        case 2: return (_ex.a + _ex.b * _x == _ex.c);
        case 3: return (_ex.a + _ex.b * _x == _ex.c + _ex.d * _x);
        case 4: return (_x * _x + _ex.b * _x + _ex.c == 0);
    }
    return false;
}

// _ans: array con 1 entero (niveles 1-3) o 2 enteros (nivel 4)
// En el nivel 4 el orden de las raíces no importa
function ex_check(_ex, _ans) {
    if (_ex.level < 4) return (_ans[0] == _ex.sol[0]);
    var _s = _ex.sol;
    return (_ans[0] == _s[0] && _ans[1] == _s[1]) || (_ans[0] == _s[1] && _ans[1] == _s[0]);
}

// Cuántas raíces DISTINTAS acertó el jugador (0, 1 o 2): sirve para el "escudo" del jefe (1 raíz rompe el escudo, 2 hacen daño).
function ex_roots_hit(_ex, _ans) {
    var _hits = 0;
    for (var i = 0; i < 2; i++) {
        var _found = false;
        for (var j = 0; j < array_length(_ans); j++) if (_ans[j] == _ex.sol[i]) _found = true;
        if (_found) _hits++;
    }
    return _hits;
}

// Andamiaje
// Pista visible por defecto (primer ejercicio de cada nivel): 1 línea.
function ex_reminder(_ex) {
    switch (_ex.level) {
        case 1: return "Recuerda: resta " + string(_ex.a) + " en ambos lados.";
        case 2: return "Recuerda: primero resta " + string(_ex.a) + " y luego divide por " + string(_ex.b) + ".";
        case 3: return "Recuerda: junta primero las x en un solo lado de la igualdad.";
        case 4: return "Recuerda: busca dos números que multiplicados den " + string(_ex.c) + " y sumados den " + string(_ex.b) + ".";
    }
    return "";
}

// Pista tras el primer error: el procedimiento en 2 sub-pasos, SIN dar la respuesta.
function ex_hint(_ex) {
    switch (_ex.level) {
        case 1:
            return "Paso 1: quita " + string(_ex.a) + " de ambos lados de la balanza.\n"
                 + "Paso 2: lo que queda al otro lado es tu respuesta.";
        case 2:
            return "Paso 1: resta " + string(_ex.a) + " en ambos lados para dejar sola la parte con x.\n"
                 + "Paso 2: divide ambos lados por " + string(_ex.b) + ".";
        case 3:
            if (_ex.b > _ex.d) {
                return "Paso 1: junta las x restando " + term_x(_ex.d) + " en ambos lados.\n"
                     + "Paso 2: despeja x como en la zona anterior.";
            }
            return "Paso 1: junta las x restando " + term_x(_ex.b) + " en ambos lados (quedarán a la derecha).\n"
                 + "Paso 2: despeja x como en la zona anterior.";
        case 4:
            return "Busca p y q con p · q = " + string(_ex.c) + " y p + q = " + string(_ex.b) + ".\n"
                 + "Las raíces son -p y -q.";
    }
    return "";
}

// Procedimiento completo (se muestra tras el segundo error). Devuelve un array de líneas.
function ex_steps(_ex) {
    var _a = _ex.a, _b = _ex.b, _c = _ex.c, _d = _ex.d;
    var _s = [ ex_equation_string(_ex) ];

    switch (_ex.level) {
        case 1:
            array_push(_s, "Resta " + string(_a) + " en ambos lados: x = " + string(_c) + " - " + string(_a));
            array_push(_s, "x = " + string(_ex.sol[0]));
            break;

        case 2:
            array_push(_s, "Resta " + string(_a) + " en ambos lados: " + term_x(_b) + " = "
                         + string(_c) + " - " + string(_a) + " = " + string(_c - _a));
            array_push(_s, "Divide ambos lados entre " + string(_b) + ": x = "
                         + string(_c - _a) + " / " + string(_b) + " = " + string(_ex.sol[0]));
            break;

        case 3:
            if (_b > _d) {
                var _k = _b - _d;
                array_push(_s, "Resta " + term_x(_d) + " en ambos lados: " + string(_a) + " + " + term_x(_k) + " = " + string(_c));
                if (_k == 1) {
                    array_push(_s, "Resta " + string(_a) + " en ambos lados: x = " + string(_c) + " - " + string(_a) + " = " + string(_ex.sol[0]));
                } else {
                    array_push(_s, "Resta " + string(_a) + " en ambos lados: " + term_x(_k) + " = " + string(_c) + " - " + string(_a) + " = " + string(_c - _a));
                    array_push(_s, "Divide ambos lados entre " + string(_k) + ": x = " + string(_c - _a) + " / " + string(_k) + " = " + string(_ex.sol[0]));
                }
            } else {
                var _k2 = _d - _b;
                array_push(_s, "Resta " + term_x(_b) + " en ambos lados: " + string(_a) + " = " + string(_c) + " + " + term_x(_k2));
                if (_k2 == 1) {
                    array_push(_s, "Resta " + string(_c) + " en ambos lados: x = " + string(_a) + " - " + string(_c) + " = " + string(_ex.sol[0]));
                } else {
                    array_push(_s, "Resta " + string(_c) + " en ambos lados: " + term_x(_k2) + " = " + string(_a) + " - " + string(_c) + " = " + string(_a - _c));
                    array_push(_s, "Divide ambos lados entre " + string(_k2) + ": x = " + string(_a - _c) + " / " + string(_k2) + " = " + string(_ex.sol[0]));
                }
            }
            break;

        case 4:
            var _r1 = _ex.sol[0], _r2 = _ex.sol[1];
            array_push(_s, "p · q = " + string(_c) + "  y  p + q = " + string(_b));
            array_push(_s, factor_str(_r1) + factor_str(_r2) + " = 0");
            array_push(_s, SYM_X1 + " = " + string(_r1) + "   " + SYM_X2 + " = " + string(_r2));
            break;
    }
    return _s;
}

// Narrativa (la define scr_bank_text)
function ex_story(_ex) {
    var _t = global.bank_text[$ _ex.id];
    if (is_undefined(_t)) return "Resuelve la ecuación para encontrar el valor de x.";   // respaldo
    return _t;
}

// VALIDADOR — sustituye a la "prueba de 10 000 casos" del plan original. Se ejecuta solo en desarrollo (DEBUG_MODE) al iniciar el juego y
// atrapa errores de tipeo del banco (por ejemplo "4 + 5x = 24 → x = 24"). ERROR = hay que corregir | AVISO = revisar | PENDIENTE = falta narrativa
function bank_validate() {
    var _err = 0;
    var _n   = array_length(global.bank_list);
    var _ids = {};
    var _eqs = {};
    var _tests = bank_test_items();

    for (var i = 0; i < _n; i++) {
        var _ex  = global.bank_list[i];
        var _eqs_txt = ex_equation_string(_ex);
        var _tag = "[" + _ex.id + "] " + _eqs_txt;

        // 1. id único
        if (variable_struct_exists(_ids, _ex.id)) { show_debug_message("ERROR " + _tag + ": id repetido"); _err++; }
        _ids[$ _ex.id] = true;

        // 2. ecuación repetida dentro del banco
        if (variable_struct_exists(_eqs, _eqs_txt)) {
            show_debug_message("AVISO " + _tag + ": misma ecuación que " + _eqs[$ _eqs_txt]);
        }
        _eqs[$ _eqs_txt] = _ex.id;

        // 3. el NPC/enemigo existe y su nivel coincide
        if (!variable_struct_exists(global.bank_src, _ex.src)) {
            show_debug_message("ERROR " + _tag + ": el origen '" + _ex.src + "' no está registrado"); _err++;
        } else if (global.bank_src[$ _ex.src].level != _ex.level) {
            show_debug_message("ERROR " + _tag + ": el nivel no coincide con el de '" + _ex.src + "'"); _err++;
        }

        // 4. coeficientes coherentes con el nivel
        if (_ex.level == 2 && _ex.b < 2) { show_debug_message("AVISO " + _tag + ": b < 2 (sería de Nivel 1)"); }
        if (_ex.level == 3 && _ex.b == _ex.d) { show_debug_message("ERROR " + _tag + ": b = d (no tiene solución única)"); _err++; }

        // 5. las soluciones realmente cumplen la ecuación
        var _need = (_ex.level == 4) ? 2 : 1;
        if (array_length(_ex.sol) != _need) {
            show_debug_message("ERROR " + _tag + ": debe tener " + string(_need) + " solución(es)"); _err++;
        } else {
            for (var j = 0; j < _need; j++) {
                if (!ex_solves(_ex, _ex.sol[j])) {
                    show_debug_message("ERROR " + _tag + ": no se cumple con x = " + string(_ex.sol[j])); _err++;
                }
            }
            if (_need == 2 && _ex.sol[0] == _ex.sol[1]) {
                show_debug_message("ERROR " + _tag + ": las dos raíces son iguales"); _err++;
            }
        }

        // 6. ¿coincide con un ítem del pre-test o post-test?
        if (variable_struct_exists(_tests, _eqs_txt)) {
            show_debug_message("AVISO " + _tag + ": es idéntica al ítem " + _tests[$ _eqs_txt] + " del test");
        }

        // 7. narrativa
        if (!variable_struct_exists(global.bank_text, _ex.id)) {
            show_debug_message("PENDIENTE " + _tag + ": sin narrativa");
        }
    }

    // Resumen por NPC/enemigo
    var _names = variable_struct_get_names(global.bank_src);
    array_sort(_names, true);
    for (var k = 0; k < array_length(_names); k++) {
        var _src = global.bank_src[$ _names[k]];
        show_debug_message("  " + _src.name + " (nivel " + string(_src.level) + "): "
                           + string(array_length(_src.order)) + " ejercicios");
    }
    show_debug_message("=== Banco: " + string(_n) + " ejercicios, " + string(_err) + " errores ===");
    return (_err == 0);
}

// Ítems de los tests, con el mismo formato de ex_equation_string
function bank_test_items() {
    var _t = {};
    _t[$ "4 + x = 15"]          = "1 del pre-test";
    _t[$ "10 + x = 3"]          = "2 del pre-test";
    _t[$ "3 + 2x = 11"]         = "3 del pre-test";
    _t[$ "12 + 2x = 4"]         = "4 del pre-test";
    _t[$ "5 + 4x = 9 + 3x"]     = "5 del pre-test";
    _t[$ "10 + 2x = 4 + 3x"]    = "6 del pre-test";
    _t[$ ("x" + SYM_SQ + " - 5x + 6 = 0")]  = "7 del pre-test";
    _t[$ ("x" + SYM_SQ + " + 7x + 6 = 0")]  = "8 del pre-test";
    _t[$ "7 + x = 20"]          = "1 del post-test";
    _t[$ "8 + x = 2"]           = "2 del post-test";
    _t[$ "9 + 3x = 30"]         = "3 del post-test";
    _t[$ "11 + 5x = 1"]         = "4 del post-test";
    _t[$ "6 + 5x = 13 + 4x"]    = "5 del post-test";
    _t[$ "4 + 5x = 16 + 2x"]    = "6 del post-test";
    _t[$ ("x" + SYM_SQ + " - 7x + 12 = 0")] = "7 del post-test";
    _t[$ ("x" + SYM_SQ + " + 7x + 12 = 0")] = "8 del post-test";
    return _t;
}

// Imprime el banco completo en la consola para revisarlo
function bank_dump() {
    for (var i = 0; i < array_length(global.bank_list); i++) {
        var _ex = global.bank_list[i];
        show_debug_message(string_replace_all(_ex.id + "  |  " + ex_equation_string(_ex) + "  →  " + ex_solution_string(_ex), "\n", " "));
    }
}