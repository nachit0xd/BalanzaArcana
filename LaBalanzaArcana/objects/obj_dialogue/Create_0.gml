lines     = [];            // array de strings o de dlg(...)
idx       = 0;             // línea actual
speaker   = "";            // hablante por defecto
cur_who   = "";            // hablante de la línea actual
on_done   = undefined;
text_full = "";            // línea actual ya partida en renglones
chars     = 0;             // letras visibles (con decimales)
cps       = opt_text_cps();   // letras por frame: depende de la opción "Velocidad del texto"
line_done = false;         // ¿ya se escribió toda la línea?
grace     = 0;             // frames iniciales en que se ignora la tecla
closing   = false;         // true mientras se está cerrando
portrait_id = "";         // id del retrato de quien habla ("" = sin retrato)
pt        = 0;             // frames desde que apareció el retrato (anima su entrada)

// Caja (coordenadas de GUI, 1280 x 720)
box_w = GUI_W - 128;
box_h = 184;
box_x = 64;
box_y = GUI_H - box_h - 40;
pad   = 28;

start = function(_lines, _speaker, _on_done) {
    lines   = _lines;
    speaker = _speaker;
    on_done = _on_done;
    idx     = 0;
    grace   = 6;           // la pulsación que abrió el diálogo no debe contar
    if (array_length(lines) == 0) { finish(); return; }
    fit_box();             // la caja se ajusta al texto más largo de este diálogo
    show_line();
};

// La caja mide entre 2 y 4 renglones, según el texto más largo de este diálogo
// (se calcula una vez, así no cambia de tamaño entre una línea y otra)
fit_box = function() {
    draw_set_font(fnt_ui);
    var _lh = string_height("M");
    var _maxh = 0;
    for (var i = 0; i < array_length(lines); i++) {
        var _l = lines[i];
        var _t = is_struct(_l) ? _l.text : _l;
        _maxh = max(_maxh, string_height(text_wrap(_t, box_w - pad * 2)));
    }
    box_h = clamp(_maxh + pad * 2, _lh * 2 + pad * 2, _lh * 4 + pad * 2);
    box_y = GUI_H - box_h - 40;
};

show_line = function() {
    var _l = lines[idx];
    var _t = is_struct(_l) ? _l.text : _l;
    cur_who = is_struct(_l) ? _l.who : speaker;

    // Retrato: se busca por el nombre de quien habla. Si cambia el hablante, entra de nuevo.
    var _pid = portrait_id_for_name(cur_who);
    if (_pid != portrait_id) pt = 0;
    portrait_id = _pid;

    draw_set_font(fnt_ui);                              // para medir con la fuente correcta
    text_full = text_wrap(_t, box_w - pad * 2);
    chars     = 0;
    line_done = false;

    if (DEBUG_MODE && string_height(text_full) > box_h - pad * 2) {
        show_debug_message("AVISO diálogo demasiado largo (no cabe en la caja): " + string_copy(_t, 1, 50) + "...");
    }
};

advance = function() {
    idx++;
    if (idx >= array_length(lines)) finish();
    else show_line();
};

finish = function() {
    closing = true;                                     // ya no cuenta como diálogo abierto
    var _cb = on_done;
    ui_block(10);                                       // evita reabrir con la misma pulsación
    instance_destroy();
    if (!is_undefined(_cb)) _cb();
};
