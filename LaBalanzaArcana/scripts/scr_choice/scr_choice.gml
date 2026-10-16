// _prompt   : texto de la pregunta
// _options  : array de textos
// _on_choose: function(indice) que se ejecuta al elegir (0 = primera opción)
function choice_show(_prompt, _options, _on_choose) {
    if (choice_active() || dialogue_active()) return noone;
    var _c = instance_create_depth(0, 0, -920, obj_choice);
    _c.start(_prompt, _options, _on_choose);
    return _c;
}

// ¿Hay un menú de elección abierto? (se ignora uno que ya se está cerrando)
function choice_active() {
    var _active = false;
    with (obj_choice) {
        if (!closing) _active = true;
    }
    return _active;
}
