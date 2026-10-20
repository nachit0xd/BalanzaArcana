// Objeto que controla la caja de respuestas para los ejercicios

fields    = 1;                 // 1 o 2
texts     = ["", ""];          // Texto escrito en cada campo
focus     = 0;                 // Campo activo (0 o 1)
enabled   = false;             // Check de ¿acepta teclado?
submitted = false;             // true cuando el jugador envió una respuesta válida
grace     = 0;                 // Frames iniciales en que se ignora el teclado
shake     = 0;                 // Temblor al pulsar Enter con algo inválido
max_len   = 4;                 // Por ejemplo, "-123" como máximo
labels    = ["x =", ""];

// Medidas en píxeles de GUI
label_w = 110;
box_w   = 190;
box_h   = 64;
gap     = 56;                  // Espacio entre los dos campos
gx = 0;                        // Esquina superior izquierda del bloque
gy = 0;

// Posiciona y define cuántos campos hay. _cx = centro horizontal
configure = function(_fields, _cx, _y, _compact) {
    fields = _fields;
    labels = (_fields == 1) ? ["x =", ""] : [SYM_X1 + " =", SYM_X2 + " ="];
    if (!is_undefined(_compact) && _compact) { label_w = 90;  box_w = 150; gap = 30; }
    else                                     { label_w = 110; box_w = 190; gap = 56; }
    var _total = fields * (label_w + box_w) + (fields - 1) * gap;
    gx = _cx - _total / 2;
    gy = _y;
    clear();
};

clear = function() {
    texts = ["", ""];
    focus = 0;
    submitted = false;
    keyboard_string = "";
};

enable = function() {
    clear();
    enabled = true;
    grace = 5;                 // Ignora teclas que venían pulsadas
};

disable = function() {
    enabled = false;           // Conserva el texto para mostrarlo en el feedback
};

all_valid = function() {
    for (var i = 0; i < fields; i++) {
        if (!answer_is_valid(texts[i])) return false;
    }
    return true;
};

// Respuestas como números [x] o [x1, x2]
get_values = function() {
    var _v = [];
    for (var i = 0; i < fields; i++) array_push(_v, answer_parse(texts[i]));
    return _v;
};

// Respuestas como texto para el registro "4" o "2;3"
get_text = function() {
    var _s = texts[0];
    if (fields == 2) _s += ";" + texts[1];
    return _s;
};