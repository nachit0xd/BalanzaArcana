// Con un ejercicio, diálogo o combate abierto, el enemigo se queda quieto
if (enemy_id == "" || world_frozen()) exit;

if (armed_t > 0) armed_t--;
blocked = false;
timer--;

if (state == 0) {
    // Quieto: espera y luego elige una dirección
    if (timer <= 0) {
        pick_dir();
        state = 1;
        timer = irandom_range(40, 100);
    }
} else {
    // Caminando
    move_x(dx * spd);
    move_y(dy * spd);
    walk_t += 0.12;
    if (timer <= 0 || blocked) {
        state = 0;
        timer = irandom_range(60, 150);
    }
}

depth = -y;

// Contacto con el jugador: las cajas de colisión se tocan -> combate
if (armed_t <= 0 && battle_grace_ok() && instance_exists(obj_player)) {
    var _p = obj_player;
    if (_p.x + _p.hb_r >= x + hb_l - 3 && _p.x + _p.hb_l <= x + hb_r + 3
     && _p.y + _p.hb_b >= y + hb_t - 3 && _p.y + _p.hb_t <= y + hb_b + 3) {
        battle_begin(enemy_id, id);
    }
}
