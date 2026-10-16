if (closing) exit;

var _cx = GUI_W / 2;
draw_set_alpha(0.7);
draw_set_colour(c_black);
draw_rectangle(0, 0, GUI_W, GUI_H, false);
draw_set_alpha(1);

var _pw = 880, _ph = 640;
var _px = _cx - _pw / 2, _py = (GUI_H - _ph) / 2;
draw_panel(_px, _py, _pw, _ph);

draw_set_font(fnt_math);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_colour(COL_WARN);
draw_text(_cx, _py + 24, "Opciones");
var _th = string_height("M");

draw_set_font(fnt_ui);
var _lh = string_height("M") + 14;
var _y0 = _py + 24 + _th + 28;
var _lx = _px + 64, _rx = _px + _pw - 64;

for (var i = 0; i < array_length(rows); i++) {
    var _r  = rows[i];
    var _y  = _y0 + i * _lh;
    var _on = (i == sel);

    // Etiqueta
    draw_set_halign(fa_left);
    draw_set_colour(_on ? COL_WARN : COL_TEXT);
    draw_text(_lx, _y, (_on ? "> " : "  ") + _r.label);

    // Valor
    draw_set_halign(fa_right);
    switch (_r.kind) {
        case "slider":
            var _v = global.opt[$ _r.id];
            var _bw = 260, _bx = _rx - 90 - _bw;
            for (var k = 0; k < 10; k++) {                      // 10 segmentos
                draw_set_colour((k < _v / 10) ? (_on ? COL_WARN : COL_GOOD) : COL_INPUT_BG);
                draw_rectangle(_bx + k * (_bw / 10) + 1, _y + 4, _bx + (k + 1) * (_bw / 10) - 3, _y + _lh - 14, false);
            }
            draw_set_colour(_on ? COL_WARN : COL_TEXT);
            draw_text(_rx, _y, string(_v) + " %");
            break;
        case "toggle":
            draw_set_colour(global.opt[$ _r.id] ? COL_GOOD : COL_DIM);
            draw_text(_rx, _y, global.opt[$ _r.id] ? "Sí" : "No");
            break;
        case "choice":
            draw_set_colour(_on ? COL_WARN : COL_TEXT);
            draw_text(_rx, _y, "<  " + _r.values[global.opt[$ _r.id]] + "  >");
            break;
    }
}

// Descripción de la fila elegida
draw_set_halign(fa_center);
draw_set_colour(COL_DIM);
draw_text_ext(_cx, _py + _ph - 100, rows[sel].desc, _lh - 6, _pw - 120);
draw_text(_cx, _py + _ph - 48, "Arriba/abajo: elegir     Izquierda/derecha: cambiar     Esc: volver");

// Restaurar estado de dibujo
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_colour(c_white);
