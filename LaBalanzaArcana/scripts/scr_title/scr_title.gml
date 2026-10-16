// Script con pantalla de inicio, cinemática de apertura y transiciones.
// Todo el arte de estas pantallas se dibuja por código (no necesita imágenes)

// Estados de la pantalla de inicio
enum TITLE_STATE { SPLASH, MENU, HOWTO, CREDITS, NOTICE, CODE, CONFIRM }

// TEXTOS: (todo es borrador salvo lo indicado)

// Créditos:
function title_credits() {
    return [
        "Ignacio Carrillo",
        "Héctor Fuentes",
        "Ingerber Sobarzo"
    ];
}

// Aviso de datos (se informa que los datos son anónimos y solo para este proyecto académico)  [BORRADOR]
function title_notice() {
    return [
        "La Balanza Arcana es un proyecto académico para practicar ecuaciones de primer grado.",
        "Mientras juegas se guardan tus respuestas y el tiempo que tardas en ellas, asociadas solo al código que vas a crear a continuación. No se guarda tu nombre, tu RUT ni tu correo.",
        "Los datos se usan de forma anónima, solo para evaluar este proyecto. Puedes dejar de jugar cuando quieras."
    ];
}

// Controles:  [BORRADOR]
function title_howto() {
    return [
        "Moverte: flechas o WASD.",
        "Hablar con un personaje: míralo de frente y pulsa Espacio, Enter o E.",
        "Responder: escribe el número (puede ser negativo, como -3) y pulsa Enter.",
        "Si hay dos soluciones, Tab cambia de campo.",
        "Tienes dos intentos por ejercicio: tras el primer error recibes una pista.",
        "En los combates hay tiempo límite para responder.",
		"Pista: pulsa H durante un ejercicio para ver un recordatorio.",
        "Pausa: Esc (durante la exploración)."
    ];
}

// Cinemática de apertura: 4 láminas breves  [BORRADOR]
// "from"/"to" = inclinación de la balanza en grados
// (0 = equilibrada, positivo = se inclina a la derecha). "hold" = frames
// que se mantiene el texto ya escrito.
function intro_slides() {
    return [
        { text: "En el reino de Aequor, la magia vive en el equilibrio. Mientras ambos lados de la Balanza Arcana pesen lo mismo, todo florece.",
          from: 0,  to: 0,  hold: 110 },
        { text: "Pero llegó El Desequilibrio. Los números dejaron de coincidir y la magia comenzó a apagarse.",
          from: 0,  to: 26, hold: 110 },
        { text: "Tú eres un joven aprendiz de mago. Tu amuleto en forma de balanza es la última esperanza del reino.",
          from: 26, to: 14, hold: 110 },
        { text: "Tu maestro te espera en la aldea. ¡Aprende a equilibrar cada ecuación!",
          from: 14, to: 0,  hold: 120 }
    ];
}

// Transiciones entre rooms (fundido a negro)
function room_transition(_room) {
	sfx("snd_whoosh");
    if (instance_exists(obj_transition)) return;
    var _t = instance_create_depth(0, 0, -2000, obj_transition);
    _t.target = _room;
}

function transition_active() {
    return instance_exists(obj_transition);
}

// DIBUJO: (coordenadas de GUI, 1280 x 720)

// Cielo nocturno con degradado. _tilt (0..1) lo tiñe de rojo oscuro.
function draw_sky(_tilt) {
    var _top = merge_colour(make_colour_rgb(10, 8, 28), make_colour_rgb(58, 12, 24), _tilt);
    var _bot = merge_colour(make_colour_rgb(46, 30, 88), make_colour_rgb(96, 28, 40), _tilt);
    draw_rectangle_colour(0, 0, GUI_W, GUI_H, _top, _top, _bot, _bot, false);
}

// Estrellas que parpadean. _stars: array de { x, y, ph, s }
function draw_stars(_stars, _t) {
    draw_set_colour(c_white);
    for (var i = 0; i < array_length(_stars); i++) {
        var _s = _stars[i];
        draw_set_alpha(0.35 + 0.65 * abs(dsin(_s.ph + _t * 2)));
        draw_rectangle(_s.x, _s.y, _s.x + _s.s, _s.y + _s.s, false);
    }
    draw_set_alpha(1);
}

// Símbolo flotante (x, +, =, números) que sube lentamente
function new_glyph(_anywhere) {
    return {
        x: irandom(GUI_W),
        y: _anywhere ? random(GUI_H) : GUI_H + 20,
        spd: random_range(0.25, 0.8),
        ch: choose("x", "+", "=", "-", "2", "5", "0", "7", "x", "="),
        a: random_range(0.10, 0.28)
    };
}

function draw_glyphs(_glyphs) {
    draw_set_font(fnt_ui);
    draw_set_halign(fa_center);
    draw_set_colour(COL_BORDER);
    for (var i = 0; i < array_length(_glyphs); i++) {
        draw_set_alpha(_glyphs[i].a);
        draw_text(_glyphs[i].x, _glyphs[i].y, _glyphs[i].ch);
    }
    draw_set_alpha(1);
    draw_set_halign(fa_left);
}

// La balanza. _ang en grados: positivo = el lado derecho baja.
function draw_balance(_x, _y, _ang, _s) {
    var _arm  = 150 * _s;
    var _lx = _x - _arm * dcos(_ang), _ly = _y - _arm * dsin(_ang);
    var _rx = _x + _arm * dcos(_ang), _ry = _y + _arm * dsin(_ang);
    var _drop = 90 * _s;       // largo de las cuerdas
    var _pw   = 46 * _s;       // medio ancho de cada platillo

    // Poste y base
    draw_set_colour(COL_BORDER);
    draw_triangle(_x - 26 * _s, _y + 190 * _s, _x + 26 * _s, _y + 190 * _s, _x, _y, false);
    draw_rectangle(_x - 70 * _s, _y + 190 * _s, _x + 70 * _s, _y + 206 * _s, false);

    // Brazo
    draw_line_width_colour(_lx, _ly, _rx, _ry, max(2, 8 * _s), COL_WARN, COL_WARN);
    draw_set_colour(COL_WARN);
    draw_circle(_x, _y, 12 * _s, false);

    // Platillos (cuelgan siempre verticales)
    var _ex = [_lx, _rx];
    var _ey = [_ly, _ry];
    for (var i = 0; i < 2; i++) {
        draw_line_width(_ex[i], _ey[i], _ex[i] - _pw, _ey[i] + _drop, max(1, 2 * _s));
        draw_line_width(_ex[i], _ey[i], _ex[i] + _pw, _ey[i] + _drop, max(1, 2 * _s));
        draw_rectangle(_ex[i] - _pw - 4 * _s, _ey[i] + _drop, _ex[i] + _pw + 4 * _s, _ey[i] + _drop + 8 * _s, false);
    }
    draw_set_colour(c_white);
}

// Panel con borde (mismo estilo que los demás paneles)
function draw_panel(_x, _y, _w, _h) {
    draw_set_colour(COL_PANEL);
    draw_rectangle(_x, _y, _x + _w, _y + _h, false);
    draw_set_colour(COL_BORDER);
    draw_rectangle(_x, _y, _x + _w, _y + _h, true);
    draw_rectangle(_x + 2, _y + 2, _x + _w - 2, _y + _h - 2, true);
    draw_set_colour(c_white);
}

// Texto con sombra, para que se lea sobre el cielo
function draw_text_shadow(_x, _y, _str, _col) {
    draw_set_colour(c_black);
    draw_text(_x + 3, _y + 3, _str);
    draw_set_colour(_col);
    draw_text(_x, _y, _str);
}
