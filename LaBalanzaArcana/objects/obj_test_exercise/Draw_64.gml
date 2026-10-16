if (exercise_active()) exit;

draw_set_font(fnt_ui);
draw_set_colour(COL_TEXT);
draw_text(32, 120, "PRUEBA DE EJERCICIOS (Fase 2)\n"
    + "1: Herrero (Nivel 1, misión de NPC, sin tiempo)\n"
    + "2: Golem (Nivel 2, batalla, 30 s)\n"
    + "3: Guerrero no-muerto (Nivel 3, batalla, 40 s)\n"
    + "4: Rey del Desequilibrio (Nivel 4, 2 campos, 80 s)\n"
    + "R: reiniciar barajas");

if (!is_undefined(last_result)) {
    var _r = last_result;
    draw_set_colour(COL_WARN);
    draw_text(32, 420, "Último resultado: " + _r.id
        + "\ncorrecta: " + string(_r.correct)
        + "  |  intento: " + string(_r.attempt)
        + "  |  puntos: " + string(_r.points)
        + "\ntiempo agotado: " + string(_r.timed_out)
        + "  |  tiempo restante: " + string(round(_r.time_left_pct * 100)) + " %");
}
draw_set_colour(c_white);