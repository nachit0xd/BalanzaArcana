shown_score = global.score;     // valor que se dibuja (sube contando)
last_score  = global.score;
last_left   = 0;                // segmentos que quedaban el frame anterior
blink_idx   = -1;               // segmento recién perdido (parpadea)
blink_t     = 0;
popups      = [];               // textos "+N" que suben: { txt, t }

// Cuántos segmentos tiene la barra y cuántos quedan según la vida actual
hud_segments = function() {
    var _loss = max(1, cfg_life_loss(global.level));
    return max(1, ceil(100 / _loss));
};
hud_left = function() {
    var _loss = max(1, cfg_life_loss(global.level));
    if (global.life <= 0) return 0;
    return min(hud_segments(), ceil(global.life / _loss));
};
last_left = hud_left();
