last_result = undefined;

// Lanza el siguiente ejercicio de la baraja de un NPC/enemigo
start_test = function(_src_id, _ctx) {
    var _deck  = deck_get(_src_id);
    var _first = (variable_struct_names_count(_deck.given) == 0);   // primero de esa baraja
    var _ex    = deck_next(_deck);
    exercise_launch(_ex, _ctx, _first, function(_r) {
        last_result = _r;
    });
};