sprite_index = spr_player;
image_speed  = 0;               // la animación se controla a mano

spd    = 1.5;                   // píxeles por frame (90 px/s a 60 fps)
x_rem  = 0;                     // fracción de píxel pendiente en X
y_rem  = 0;                     // fracción de píxel pendiente en Y
dir    = 3;                     // mira a: 0 derecha, 1 arriba, 2 izquierda, 3 abajo
moving = false;
anim_t = 0;

// Caja de colisión en los PIES (10 x 6 px). Offsets desde x, y (el origen).
// Al ser la caja más chica que una casilla, comprobar las 4 esquinas basta.
hb_l = -5;  hb_r = 4;
hb_t = -6;  hb_b = -1;

image_index = dir * 3;
depth = -y; // ordenar correctamente desde el primer fotograma

// ¿Chocaría la caja si el jugador estuviera en (_x, _y)?
collides = function(_x, _y) {
    return solid_at(_x + hb_l, _y + hb_t) || solid_at(_x + hb_r, _y + hb_t)
        || solid_at(_x + hb_l, _y + hb_b) || solid_at(_x + hb_r, _y + hb_b);
};

// Movimiento por píxeles ENTEROS (evita que el pixel art "tiemble").
// La parte decimal de la velocidad se acumula en x_rem / y_rem.
move_x = function(_amount) {
    x_rem += _amount;
    var _m    = round(x_rem);
    x_rem    -= _m;
    var _sign = sign(_m);
    repeat (abs(_m)) {
        if (!collides(x + _sign, y)) { x += _sign; }
        else { x_rem = 0; break; }
    }
};

move_y = function(_amount) {
    y_rem += _amount;
    var _m    = round(y_rem);
    y_rem    -= _m;
    var _sign = sign(_m);
    repeat (abs(_m)) {
        if (!collides(x, y + _sign)) { y += _sign; }
        else { y_rem = 0; break; }
    }
};

face_dx = [1, 0, -1, 0];       // vector de cada dirección: derecha, arriba, izquierda, abajo
face_dy = [0, -1, 0, 1];

// ¿Está mirando hacia el punto (_tx, _ty)?
faces = function(_tx, _ty) {
    var _d = point_distance(x, y, _tx, _ty);
    if (_d == 0) return true;
    var _dot = ((_tx - x) * face_dx[dir] + (_ty - y) * face_dy[dir]) / _d;
    return _dot > 0.35;
};
