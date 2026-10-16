// Puntaje:
// _attempt      : 1 o 2 = intento en que acertó | 0 = no acertó
// _ctx          : "npc" | "battle"   (el bono de tiempo solo existe en batalla)
// _time_left_pct: 0..1, fracción del tiempo que le quedaba al responder
function score_calc(_attempt, _ctx, _time_left_pct) {
    var _c = global.cfg;

    if (_attempt == 1) {
        var _p = _c.pts_first;                                   // 100
        if (_ctx == "battle") {
            _p += (_time_left_pct > _c.bonus_threshold) ? _c.bonus_fast    // +25 (más del 50 %)
                                                        : _c.bonus_slow;   // +10 (50 % o menos)
        }
        return _p;
    }
    if (_attempt == 2) return _c.pts_second;                     // 60
    return 0;
}

// Puntos base sin bono (para mostrar "incluye +N por rapidez")
function score_base(_attempt) {
    if (_attempt == 1) return global.cfg.pts_first;
    if (_attempt == 2) return global.cfg.pts_second;
    return 0;
}