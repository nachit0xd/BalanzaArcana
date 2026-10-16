if (closing) exit;

anim_in = min(1, anim_in + 0.06);
if (shake_e > 0) shake_e--;
if (shake_p > 0) shake_p--;
if (crack_t > 0) crack_t--;

// ¿El jugador acertó una sola raíz? -> el escudo se agrieta un momento
if (instance_exists(ex_inst) && !ex_inst.closing) {
    if (ex_inst.partial_hit > partial_seen) {
        partial_seen = ex_inst.partial_hit;
        if (stage == 1) { crack_t = 50; sfx("snd_shield_crack"); }
    }
}

// El escudo se rompe al romperse un sello y se recarga para la fase siguiente
if (shatter_t > 0) {
    shatter_t--;
    shield_a = 0;
    if (shatter_t == 0 && broken < seals_max) shield_a = 0.01;
} else if (shield_a > 0 && shield_a < 1) {
    shield_a = min(1, shield_a + 0.03);
}

// Los textos flotantes suben y desaparecen
for (var i = array_length(pop) - 1; i >= 0; i--) {
    pop[i].t++;
    if (pop[i].t > 50) array_delete(pop, i, 1);
}

switch (state) {

    case "hit":
        t++;
        if (t > 80) {
            if (stage == 1) {
                if (last_ok && broken >= seals_max) set_shield_down();     // tres sellos: cae el escudo
                else if (global.life <= 0)          set_lose();
                else {
                    if (last_ok) phase = min(seals_max, broken + 1);       // fase siguiente
                    state = "fight";
                    next_round();
                }
            } else {
                if (hp <= 0)               set_win();
                else if (global.life <= 0) set_lose();
                else { state = "fight"; next_round(); }
            }
        }
        break;

    case "shield_banner":
        t++;
        if (t > 80) {
            state = "shield_dialogue";
            dialogue_start(boss_shield_lines(), src.name, begin_stage2);
        }
        break;

    case "win_banner":
        t++;
        if (t > 80) {
            state = "win_dialogue";
            dialogue_start(boss_win_lines(), src.name, finish_win);
        }
        break;

    case "lose_banner":
        t++;
        if (t > 90) {
            banner = "";
            state  = "lose_dialogue";
            dialogue_start([ "Te quedaste sin vida, y El Desequilibrio recuperó sus tres sellos.",
                             "Respira hondo: el combate empieza otra vez desde la primera fase." ], "", restart_fight);
        }
        break;
}
