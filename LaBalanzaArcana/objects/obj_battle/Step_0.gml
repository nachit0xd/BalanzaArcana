if (closing) exit;

anim_in = min(1, anim_in + 0.06);
if (shake_e > 0) shake_e--;
if (shake_p > 0) shake_p--;

// Los textos flotantes suben y desaparecen
for (var i = array_length(pop) - 1; i >= 0; i--) {
    pop[i].t++;
    if (pop[i].t > 50) array_delete(pop, i, 1);
}

switch (state) {

    case "hit":
        t++;
        if (t > 55) {
            if (hp <= 0)               set_win();
            else if (global.life <= 0) set_lose();
            else { state = "fight"; next_round(); }
        }
        break;

    case "win_banner":
        t++;
        if (t > 80) {
            state = "win_dialogue";
            dialogue_start(battle_win_lines(src_id), src.name, finish_win);
        }
        break;

    case "lose_banner":
        t++;
        if (t > 90) {
            banner = "";
            state  = "lose_dialogue";
            dialogue_start([ "Te quedaste sin vida, pero la Balanza Arcana te da otra oportunidad.",
                             "Respira hondo: el combate empieza de nuevo." ], "", restart_fight);
        }
        break;
}
