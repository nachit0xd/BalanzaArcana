// ¿Se perdió un segmento? Ese segmento parpadea unos instantes
var _left = hud_left();
if (_left < last_left) {
    blink_idx = _left;
    blink_t   = 45;
    sfx("snd_life_lost");
}
last_left = _left;
if (blink_t > 0) blink_t--;

// El puntaje sube contando; si baja (p. ej. un combate perdido) se ajusta de golpe
if (global.score > last_score) {
    array_push(popups, { txt: "+" + string(global.score - last_score), t: 0 });
    sfx("snd_score");
}
last_score = global.score;
if (shown_score < global.score) {
    shown_score = min(global.score, shown_score + max(1, ceil((global.score - shown_score) * 0.12)));
} else {
    shown_score = global.score;
}

// Los "+N" suben y desaparecen
for (var i = array_length(popups) - 1; i >= 0; i--) {
    popups[i].t++;
    if (popups[i].t > 55) array_delete(popups, i, 1);
}
