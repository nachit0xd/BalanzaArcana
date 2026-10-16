level_id     = 1;
preview      = false;        // true = vista previa de prueba (no guarda insignias)
stats        = undefined;
rows         = [];           // aciertos/fallos por NPC o enemigo
new_badges   = [];           // insignias obtenidas en ESTE cierre de nivel
owned_total  = 0;            // insignias que tiene el jugador en total
page         = 1;
pages        = 1;
t            = 0;            // frames en la página actual (anima la aparición)
grace        = 8;            // frames iniciales en que se ignora la tecla
closing      = false;
shown_pts    = 0;            // contadores que suben "contando"
shown_total  = 0;
total_points = 0;

start = function(_level, _preview) {
    level_id     = _level;
    preview      = _preview;
    stats        = level_stats(_level);
    rows         = source_stats(_level);
    new_badges   = badges_evaluate(_level, !_preview);     // en vista previa no se guardan
	if (!_preview) log_level_summary(_level, stats, new_badges);   // queda en el archivo de datos
    owned_total  = array_length(global.badges) + (_preview ? array_length(new_badges) : 0);
    total_points = global.score;
    shown_total  = global.score - stats.points;
    pages        = (array_length(new_badges) > 0) ? 2 : 1;
	jingle("mus_results");
};

// ¿La animación de la página actual ya terminó?
page_ready = function() {
    if (page == 1) return (t >= 90);
    return (t >= 20 + 20 * min(array_length(new_badges), 5));
};

finish = function() {
    closing = true;
    var _lv = level_id;
    ui_block(10);            // la misma pulsación no debe activar otra cosa
    instance_destroy();
    if (!preview) on_results_closed(_lv);      // la vista previa (F11) no debe terminar la sesión
};
