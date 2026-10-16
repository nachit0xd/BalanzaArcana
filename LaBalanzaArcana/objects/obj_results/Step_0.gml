if (closing || is_undefined(stats)) exit;
if (grace > 0) { grace--; exit; }

t++;

// Los puntajes suben contando durante la primera página
if (page == 1) {
    var _step = max(1, ceil(stats.points / 50));
    shown_pts   = min(stats.points, shown_pts + _step);
    shown_total = min(total_points, shown_total + _step);
}

// Tecla de acción: primero completa la animación; luego avanza de página o cierra
if (action_pressed()) {
    if (!page_ready()) {
        t = 9999;
        shown_pts   = stats.points;
        shown_total = total_points;
    } else if (page < pages) {
        page++;
        t = 0;
    } else {
        finish();
    }
}

// Un sonido por cada insignia que aparece
if (page == 2 && t >= 15 && ((t - 15) mod 20) == 0 && ((t - 15) div 20) < min(array_length(new_badges), 5)) sfx("snd_badge");