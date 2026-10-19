// Retrato de quien habla, que aparece arriba a la derecha de la caja de diálogo (lo dibuja obj_dialogue)

// Nombre que se muestra sobre la caja -> id del retrato ("" si no tiene)
function portrait_id_for_name(_name) {
    if (_name == "Maestro") return "maestro";
    var _ids = variable_struct_get_names(global.bank_src);
    for (var i = 0; i < array_length(_ids); i++) {
        if (global.bank_src[$ _ids[i]].name == _name) return _ids[i];
    }
    return "";
}

// Orden de los fotogramas de spr_portrait (retratos definitivos)
function portrait_frame(_pid) {
    switch (_pid) {
        case "herrero":           return 0;
        case "molinera":          return 1;
        case "guardiana":         return 2;
        case "duende":            return 3;
        case "herbolaria":        return 4;
        case "apicultor":         return 5;
        case "cartografa":        return 6;
        case "maestro":           return 7;
        case "hombrelobo":        return 8;
        case "golem":             return 9;
        case "arana":             return 10;
        case "sombra":            return 11;
        case "guerrero":          return 12;
        case "centinela":         return 13;
        case "espectro":          return 14;
        case "esqueleto":         return 15;
        case "rey_desequilibrio": return 16;
    }
    return -1;
}

// Qué dibujar para un retrato: { kind: "sprite", spr, frame } | { kind: "maestro" } | undefined
function portrait_info(_pid) {
    // 1) Retratos definitivos, si ya existe el sprite spr_portrait
    var _ps = asset_get_index("spr_portrait");
    var _frame = portrait_frame(_pid);
    if (_ps != -1) {
        if (_frame >= 0 && _frame < sprite_get_number(_ps)) {
            return { kind: "sprite", spr: _ps, frame: _frame };
        }
    }

    // 2) Provisional: el sprite del personaje, ampliado
    if (_pid == "maestro") return { kind: "maestro" };
    if (_pid == "rey_desequilibrio") return { kind: "sprite", spr: spr_boss, frame: 0 };
    if (variable_struct_exists(global.bank_src, _pid)) {
        var _s = global.bank_src[$ _pid];
        if (_s.kind == "npc") return { kind: "sprite", spr: spr_npc,   frame: npc_look_frame(_pid) };
        return                       { kind: "sprite", spr: spr_enemy, frame: enemy_look_frame(_pid) };
    }
    return undefined;
}

// Rectángulo en una cuadrícula de arte (ox, oy = esquina; u = píxeles por casilla de arte)
function pix_rect(_ox, _oy, _u, _x1, _y1, _x2, _y2) {
    draw_rectangle(_ox + _x1 * _u, _oy + _y1 * _u, _ox + (_x2 + 1) * _u - 1, _oy + (_y2 + 1) * _u - 1, false);
}

// Retrato provisional del maestro dibujado por código (cuadrícula de 16 x 20)
function draw_portrait_maestro(_ox, _oy, _u) {
    // Bastón con orbe
    draw_set_colour(make_colour_rgb(120, 80, 44));
    pix_rect(_ox, _oy, _u, 14, 4, 14, 19);
    draw_set_colour(make_colour_rgb(110, 230, 240));
    draw_circle(_ox + 14.5 * _u, _oy + 3 * _u, 1.6 * _u, false);

    // Túnica
    draw_set_colour(make_colour_rgb(70, 50, 140));
    pix_rect(_ox, _oy, _u, 3, 13, 12, 19);
    draw_set_colour(make_colour_rgb(100, 76, 180));
    pix_rect(_ox, _oy, _u, 7, 14, 8, 19);

    // Barba larga
    draw_set_colour(make_colour_rgb(235, 235, 240));
    pix_rect(_ox, _oy, _u, 5, 9, 10, 14);
    pix_rect(_ox, _oy, _u, 6, 15, 9, 16);

    // Cara
    draw_set_colour(make_colour_rgb(240, 200, 160));
    pix_rect(_ox, _oy, _u, 5, 5, 10, 8);
    draw_set_colour(make_colour_rgb(20, 20, 30));
    pix_rect(_ox, _oy, _u, 6, 6, 6, 6);
    pix_rect(_ox, _oy, _u, 9, 6, 9, 6);

    // Sombrero puntiagudo
    draw_set_colour(make_colour_rgb(70, 50, 140));
    draw_triangle(_ox + 4 * _u, _oy + 5 * _u, _ox + 11 * _u, _oy + 5 * _u, _ox + 7.5 * _u, _oy, false);
    pix_rect(_ox, _oy, _u, 3, 4, 12, 4);
    draw_set_colour(make_colour_rgb(250, 205, 70));
    pix_rect(_ox, _oy, _u, 4, 4, 11, 4);
}

// Dibuja el marco del retrato con el personaje dentro:
//   _x, _y, _w, _h : rectángulo del marco (coordenadas de GUI)
//   _t             : reservado para mantener la firma actual
//   _k             : 0..1, opacidad de la entrada
//   _accent        : color del marco (role_color); undefined = el normal
function portrait_draw(_pid, _x, _y, _w, _h, _t, _k, _accent) {
    var _info = portrait_info(_pid);
    if (is_undefined(_info)) return;

    var _a = clamp(_k, 0, 1);
    draw_set_alpha(_a);

    // Marco y fondo con degradado
    draw_panel(_x, _y, _w, _h);
    if (!is_undefined(_accent)) {
        draw_set_colour(_accent);
        draw_rectangle(_x, _y, _x + _w, _y + _h, true);
        draw_rectangle(_x + 2, _y + 2, _x + _w - 2, _y + _h - 2, true);
    }
    var _c1 = make_colour_rgb(46, 36, 80);
    var _c2 = make_colour_rgb(20, 16, 38);
    draw_rectangle_colour(_x + 4, _y + 4, _x + _w - 4, _y + _h - 4, _c1, _c1, _c2, _c2, false);

	// Retrato fijo, centrado y apoyado cerca del borde inferior del marco.
	var _cx   = _x + _w / 2;
	var _base = _y + _h - 16;

	if (_info.kind == "maestro") {
		var _u = 10; // Retrato provisional de 16 x 20 casillas; cabe en 224 x 224.
		draw_portrait_maestro(_cx - 8 * _u, _base - 20 * _u, _u);
	} else {
		var _sw = sprite_get_width(_info.spr);
		var _sh = sprite_get_height(_info.spr);
		var _sc = max(1, floor(min((_w - 32) / _sw, (_h - 32) / _sh)));
		draw_sprite_ext(_info.spr, _info.frame, _cx, _base, _sc, _sc, 0, c_white, _a);
	}
}
