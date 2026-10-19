// Con un ejercicio o diálogo abierto, el jugador se queda quieto
depth = -y; // actualizar también durante diálogos y transiciones
if (world_frozen()) {
    moving = false;
    anim_t = 0;
    image_index = dir * 3;
    exit;
}


// Entrada: flechas o WASD
var _dx = (keyboard_check(vk_right) || keyboard_check(ord("D"))) - (keyboard_check(vk_left) || keyboard_check(ord("A")));
var _dy = (keyboard_check(vk_down)  || keyboard_check(ord("S"))) - (keyboard_check(vk_up)   || keyboard_check(ord("W")));

// En diagonal no se debe ir más rápido
if (_dx != 0 && _dy != 0) {
    _dx *= 0.7071;
    _dy *= 0.7071;
}

moving = (_dx != 0 || _dy != 0);

// Dirección a la que mira (en diagonal conserva la que tenía)
if (_dx != 0 && _dy == 0) dir = (_dx > 0) ? 0 : 2;
else if (_dy != 0 && _dx == 0) dir = (_dy > 0) ? 3 : 1;

// Mover cada eje por separado: así "resbala" al rozar una pared
move_x(_dx * spd);
move_y(_dy * spd);

// Animación: fotograma 0 = reposo, 1 y 2 = pasos
var _frame = 0;
if (moving) {
    anim_t += 0.14;
    _frame = 1 + (floor(anim_t) mod 2);
} else {
    anim_t = 0;
}
image_index = dir * 3 + _frame;
