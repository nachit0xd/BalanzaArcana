// Enemigo del mundo abierto. Vaga al azar cerca de su punto de origen
// (alterna pausas y caminatas cortas, sin alejarse más de "radius" píxeles) y, si toca al jugador, inicia el combate

sprite_index = spr_enemy;
image_speed  = 0;
image_index  = 0;

home_x   = x;              // punto de origen
home_y   = y;
spd      = 0.5;            // píxeles por frame (lento: 30 px/s)
x_rem    = 0;
y_rem    = 0;
state    = 0;              // 0 = quieto, 1 = caminando
timer    = irandom_range(30, 90);
dx       = 0;
dy       = 0;
blocked  = false;
walk_t   = 0;
armed_t  = 90;             // frames tras aparecer antes de poder iniciar un combate

// Caja de colisión en los pies (12 x 8 px)
hb_l = -6;  hb_r = 5;
hb_t = -7;  hb_b = 0;

dirs_x = [1, 0, -1, 0];
dirs_y = [0, -1, 0, 1];

depth = -y;

setup = function(_id) {
    enemy_id    = _id;
    image_index = enemy_look_frame(_id);
    home_x = x;
    home_y = y;
};

if (enemy_id != "") {
    if (!variable_struct_exists(global.bank_src, enemy_id)) {
        show_debug_message("Enemigo desconocido en la room: " + enemy_id);
        instance_destroy();
        exit;
    }
    var _source = global.bank_src[$ enemy_id];
    if (_source.kind != "enemy" || _source.level != global.level) {
        show_debug_message("Enemigo de otro nivel o tipo: " + enemy_id);
        instance_destroy();
        exit;
    }
    if (quest_get(enemy_id).done) {
        instance_destroy();
        exit;
    }
    setup(enemy_id);
}


collides = function(_x, _y) {
    return solid_at(_x + hb_l, _y + hb_t) || solid_at(_x + hb_r, _y + hb_t)
        || solid_at(_x + hb_l, _y + hb_b) || solid_at(_x + hb_r, _y + hb_b);
};

// Movimiento por píxeles enteros, igual que el jugador
move_x = function(_amount) {
    x_rem += _amount;
    var _m = round(x_rem);
    x_rem -= _m;
    var _sign = sign(_m);
    repeat (abs(_m)) {
        if (!collides(x + _sign, y)) { x += _sign; }
        else { x_rem = 0; blocked = true; break; }
    }
};

move_y = function(_amount) {
    y_rem += _amount;
    var _m = round(y_rem);
    y_rem -= _m;
    var _sign = sign(_m);
    repeat (abs(_m)) {
        if (!collides(x, y + _sign)) { y += _sign; }
        else { y_rem = 0; blocked = true; break; }
    }
};

// Elige hacia dónde caminar, al azar, pero si se alejó demasiado vuelve al origen
pick_dir = function() {
    if (point_distance(x, y, home_x, home_y) > radius) {
        var _a = point_direction(x, y, home_x, home_y);
        dx = (abs(lengthdir_x(1, _a)) > 0.35) ? sign(lengthdir_x(1, _a)) : 0;
        dy = (abs(lengthdir_y(1, _a)) > 0.35) ? sign(lengthdir_y(1, _a)) : 0;
    } else {
        var _c = irandom(3);
        dx = dirs_x[_c];
        dy = dirs_y[_c];
    }
};
