// Objeto controlador de la pantalla de Resultados

level_id     = 1;
preview      = false;        // true = vista previa de prueba (no guarda insignias)
stats        = undefined;
rows         = [];           // Aciertos/fallos por NPC o enemigo
new_badges   = [];           // Insignias obtenidas en este cierre de nivel
owned_total  = 0;            // Insignias que tiene el jugador en total
page         = 1;
pages        = 1;
t            = 0;            // Frames en la página actual (anima la aparición)
grace        = 8;            // Frames iniciales en que se ignora la tecla
closing      = false;
shown_pts    = 0;            // Contadores que suben "contando"
shown_total  = 0;
total_points = 0;

start = function(_level, _preview) {
    level_id     = _level;
    preview      = _preview;
    stats        = level_stats(_level);
    rows         = source_stats(_level);
    new_badges   = badges_evaluate(_level, !_preview);     // En vista previa no se guardan
	if (!_preview) log_level_summary(_level, stats, new_badges);   // Queda en el archivo de datos
    owned_total  = array_length(global.badges) + (_preview ? array_length(new_badges) : 0);
    total_points = global.score;
    shown_total  = global.score - stats.points;
    pages        = 1 + ceil(array_length(new_badges) / 2);
	jingle("mus_results");
};

// Check de ¿la animación de la página actual ya terminó?
page_ready = function() {
    if (page == 1) return (t >= 90);
    var _visible = min(2, array_length(new_badges) - (page - 2) * 2);
    return (t >= 20 + 20 * _visible);
};

finish = function() {
    closing = true;
    var _lv = level_id;
    ui_block(10);            // La misma pulsación no debe activar otra cosa
    instance_destroy();
    if (!preview) on_results_closed(_lv);      // La vista previa (con tecla F11) no debe terminar la sesión
};
