// Script con "piezas" de interfaz reutilizables, dibujadas por código

// Color de acento según quién habla o actúa:
//   maestro = celeste | NPC = dorado | enemigo o jefe = rojo | sin personaje = borde normal
function role_color(_pid) {
    if (_pid == "maestro") return make_colour_rgb(110, 230, 240);
    if (_pid != "" && variable_struct_exists(global.bank_src, _pid)) {
        return (global.bank_src[$ _pid].kind == "npc") ? COL_WARN : COL_BAD;
    }
    return COL_BORDER;
}

// Placa del HUD: fondo casi opaco, sombra y borde fino
function draw_plaque(_x, _y, _w, _h) {
    draw_set_alpha(0.35);
    draw_set_colour(c_black);
    draw_rectangle(_x + 4, _y + 4, _x + _w + 4, _y + _h + 4, false);
    draw_set_alpha(0.92);
    draw_set_colour(COL_PANEL);
    draw_rectangle(_x, _y, _x + _w, _y + _h, false);
    draw_set_alpha(1);
    draw_set_colour(COL_BORDER);
    draw_rectangle(_x, _y, _x + _w, _y + _h, true);
    draw_rectangle(_x + 1, _y + 1, _x + _w - 1, _y + _h - 1, true);
}

// Tarjeta con borde de color (la ecuación va dentro de una)
function draw_card(_x, _y, _w, _h, _col) {
    draw_set_colour(COL_INPUT_BG);
    draw_rectangle(_x, _y, _x + _w, _y + _h, false);
    draw_set_colour(_col);
    draw_rectangle(_x, _y, _x + _w, _y + _h, true);
    draw_rectangle(_x + 1, _y + 1, _x + _w - 1, _y + _h - 1, true);
}

// Íconos
function draw_heart(_cx, _cy, _s, _col) {
    draw_set_colour(_col);
    draw_circle(_cx - _s * 0.5, _cy - _s * 0.35, _s * 0.55, false);
    draw_circle(_cx + _s * 0.5, _cy - _s * 0.35, _s * 0.55, false);
    draw_triangle(_cx - _s * 1.02, _cy - _s * 0.1, _cx + _s * 1.02, _cy - _s * 0.1, _cx, _cy + _s * 1.05, false);
}

function draw_star(_cx, _cy, _r, _col) {
    draw_primitive_begin(pr_trianglefan);
    draw_vertex_colour(_cx, _cy, _col, 1);
    for (var i = 0; i <= 10; i++) {
        var _rad = ((i mod 2) == 0) ? _r : _r * 0.45;
        var _a   = 90 + i * 36;                                // la primera punta mira hacia arriba
        draw_vertex_colour(_cx + lengthdir_x(_rad, _a), _cy + lengthdir_y(_rad, _a), _col, 1);
    }
    draw_primitive_end();
}

// Ícono redondo con un símbolo: "ok" (visto), "err" (cruz), "hint" (?), otro (i)
function draw_icon(_kind, _cx, _cy, _r, _col) {
    draw_set_colour(_col);
    draw_circle(_cx, _cy, _r, false);
    draw_set_colour(COL_PANEL);
    switch (_kind) {
        case "ok":
            draw_line_width(_cx - _r * 0.45, _cy + _r * 0.02, _cx - _r * 0.1, _cy + _r * 0.42, 3);
            draw_line_width(_cx - _r * 0.1,  _cy + _r * 0.42, _cx + _r * 0.5, _cy - _r * 0.38, 3);
            break;
        case "err":
            draw_line_width(_cx - _r * 0.4, _cy - _r * 0.4, _cx + _r * 0.4, _cy + _r * 0.4, 3);
            draw_line_width(_cx + _r * 0.4, _cy - _r * 0.4, _cx - _r * 0.4, _cy + _r * 0.4, 3);
            break;
        default:
            draw_set_font(fnt_ui);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text(_cx, _cy, (_kind == "hint") ? "?" : "i");
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
            break;
    }
}

// Alto que tendría un banner con esos textos (para reservar espacio sin dibujarlo)
function banner_height(_w, _title, _body, _foot) {
    draw_set_font(fnt_ui);
    var _lh = string_height("M") + 6;
    var _tw = _w - 72 - 16;
    var _th = (_title != "") ? string_height_ext(_title, _lh, _tw) : 0;
    var _bh = (_body  != "") ? string_height_ext(_body,  _lh, _tw) : 0;
    var _fh = (_foot  != "") ? string_height_ext(_foot,  _lh, _tw) : 0;
    var _h  = 14 + _th + ((_th > 0 && _bh > 0) ? 4 : 0) + _bh + ((_fh > 0) ? 6 : 0) + _fh + 14;
    return max(_h, 64);
}

// Banner de mensaje: franja de color + ícono + título + texto + línea final
// Devuelve su alto. _kind: "ok" | "err" | "hint" | "info". _body y _foot pueden ser ""
function draw_banner(_x, _y, _w, _kind, _title, _body, _foot) {
    var _col;
    switch (_kind) {
        case "ok":   _col = COL_GOOD;   break;
        case "err":  _col = COL_BAD;    break;
        case "hint": _col = COL_WARN;   break;
        default:     _col = COL_BORDER; break;
    }
    draw_set_font(fnt_ui);
    var _lh = string_height("M") + 6;
    var _tx = _x + 72;
    var _tw = _w - 72 - 16;

    var _th = (_title != "") ? string_height_ext(_title, _lh, _tw) : 0;
    var _bh = (_body  != "") ? string_height_ext(_body,  _lh, _tw) : 0;
    var _fh = (_foot  != "") ? string_height_ext(_foot,  _lh, _tw) : 0;
    var _h  = 14 + _th + ((_th > 0 && _bh > 0) ? 4 : 0) + _bh + ((_fh > 0) ? 6 : 0) + _fh + 14;
    _h = max(_h, 64);

    draw_set_colour(make_colour_rgb(30, 25, 52));
    draw_rectangle(_x, _y, _x + _w, _y + _h, false);
    draw_set_colour(_col);
    draw_rectangle(_x, _y, _x + 7, _y + _h, false);               // franja de color
    draw_rectangle(_x, _y, _x + _w, _y + _h, true);
    draw_icon(_kind, _x + 40, _y + 14 + _lh / 2 - 3, 17, _col);

    var _ty = _y + 14;
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    if (_th > 0) { draw_set_colour(_col);       draw_text_ext(_tx, _ty, _title, _lh, _tw); _ty += _th + 4; }
    if (_bh > 0) { draw_set_colour(COL_TEXT);   draw_text_ext(_tx, _ty, _body,  _lh, _tw); _ty += _bh + 6; }
    if (_fh > 0) { draw_set_colour(COL_GOOD);   draw_text_ext(_tx, _ty, _foot,  _lh, _tw); }
    return _h;
}

// Puntos de intento: _n puntos, los primeros _filled llenos (el último queda en _x)
function draw_dots(_x, _y, _n, _filled, _col) {
    var _x0 = _x - (_n - 1) * 34;
    for (var i = 0; i < _n; i++) {
        var _cx = _x0 + i * 34;
        draw_set_colour((i < _filled) ? _col : COL_INPUT_BG);
        draw_circle(_cx, _y, 10, false);
        draw_set_colour((i < _filled) ? _col : COL_DIM);
        draw_circle(_cx, _y, 10, true);
    }
}

// Cronómetro por segmentos (20). En los últimos 5 s parpadea
function draw_timer_bar(_x, _y, _w, _h, _frac, _secs_left) {
    var _n   = 20;
    var _gap = 3;
    var _sw  = (_w - (_n - 1) * _gap) / _n;
    var _on  = ceil(_frac * _n);
    var _col = (_frac > 0.5) ? COL_GOOD : ((_frac > 0.25) ? COL_WARN : COL_BAD);
    var _blink = (_secs_left <= 5 && ((current_time div 250) mod 2 == 0));
    for (var i = 0; i < _n; i++) {
        var _c = COL_INPUT_BG;
        if (i < _on) _c = _blink ? merge_colour(_col, COL_INPUT_BG, 0.65) : _col;
        draw_set_colour(_c);
        var _sx = _x + i * (_sw + _gap);
        draw_rectangle(_sx, _y, _sx + _sw, _y + _h, false);
    }
}

// Fila de "teclas": _pairs = [ ["Enter", "Enviar"], ["H", "Pista"] ], centrada en _cx
function draw_keycaps_row(_cx, _y, _pairs) {
    draw_set_font(fnt_ui);
    var _h = string_height("M") + 4;
    var _gk = 10, _gp = 36;
    var _total = 0;
    for (var i = 0; i < array_length(_pairs); i++) {
        _total += string_width(_pairs[i][0]) + 24 + _gk + string_width(_pairs[i][1]);
        if (i > 0) _total += _gp;
    }
    var _x = _cx - _total / 2;
    draw_set_valign(fa_middle);
    for (var j = 0; j < array_length(_pairs); j++) {
        var _kw = string_width(_pairs[j][0]) + 24;
        draw_set_colour(COL_INPUT_BG);
        draw_rectangle(_x, _y - _h / 2, _x + _kw, _y + _h / 2, false);
        draw_set_colour(COL_DIM);
        draw_rectangle(_x, _y - _h / 2, _x + _kw, _y + _h / 2, true);
        draw_set_colour(COL_TEXT);
        draw_set_halign(fa_center);
        draw_text(_x + _kw / 2, _y, _pairs[j][0]);
        draw_set_halign(fa_left);
        draw_set_colour(COL_DIM);
        draw_text(_x + _kw + _gk, _y, _pairs[j][1]);
        _x += _kw + _gk + string_width(_pairs[j][1]) + _gp;
    }
    draw_set_valign(fa_top);
}

// Retrato pequeño cuadrado (encabezado de la pantalla de ejercicio)
function portrait_mini(_pid, _x, _y, _size, _accent) {
    var _info = portrait_info(_pid);
    draw_set_colour(COL_INPUT_BG);
    draw_rectangle(_x, _y, _x + _size, _y + _size, false);
    if (!is_undefined(_info)) {
        if (_info.kind == "sprite") {
            var _sw = sprite_get_width(_info.spr);
            var _sh = sprite_get_height(_info.spr);
            var _sc = max(1, floor(min((_size - 12) / _sw, (_size - 12) / _sh)));
            draw_sprite_ext(_info.spr, _info.frame, _x + _size / 2, _y + _size - 6, _sc, _sc, 0, c_white, 1);
        } else {
            var _u = floor((_size - 12) / 20);
            draw_portrait_maestro(_x + _size / 2 - 8 * _u, _y + _size - 6 - 20 * _u, _u);
        }
    }
    draw_set_colour(_accent);
    draw_rectangle(_x, _y, _x + _size, _y + _size, true);
    draw_rectangle(_x + 1, _y + 1, _x + _size - 1, _y + _size - 1, true);
    draw_set_colour(c_white);
}
