// Objeto controlador del menú de opciones. Se abre desde la pantalla de inicio y desde la pausa con la función options_show()

rows = [
    { id: "vol_master",   kind: "slider", label: "Volumen general",      desc: "Volumen de todos los sonidos del juego." },
    { id: "vol_music",    kind: "slider", label: "Música",               desc: "Volumen de la música de fondo." },
    { id: "vol_sfx",      kind: "slider", label: "Efectos de sonido",    desc: "Volumen de los efectos de sonido." },
    { id: "fullscreen",   kind: "toggle", label: "Pantalla completa",    desc: "Alterna entre ventana y pantalla completa." },
    { id: "win_size",     kind: "choice", label: "Tamaño de ventana",    desc: "Tamaño en modo ventana. Automática se ajusta a tu monitor. No aplica en pantalla completa.",
      values: ["Automática", "1280×720", "1600×900", "1920×1080", "2560×1440"] },
    { id: "text_speed",   kind: "choice", label: "Velocidad del texto",  desc: "Qué tan rápido aparece el texto de los diálogos.",
      values: ["Lenta", "Normal", "Rápida"] },
    { id: "hints_always", kind: "toggle", label: "Pistas permanentes",   desc: "Muestra el recordatorio de ayuda al empezar cada ejercicio." },
    { id: "back",         kind: "button", label: "Volver",               desc: "" }
];
sel       = 0;
grace     = 8;                    // Frames iniciales en que se ignora la tecla
closing   = false;
on_close  = undefined;
before    = "";                   // Resumen al abrir (para registrar si hubo cambios)

start = function(_on_close) {
    on_close = _on_close;
    before   = options_summary();
};

// Cambia el valor de la fila elegida (_d = -1 o +1)
change = function(_d) {
    var _r = rows[sel];
    switch (_r.kind) {
        case "slider":
            global.opt[$ _r.id] = clamp(global.opt[$ _r.id] + _d * 10, 0, 100);
            break;
        case "toggle":
            global.opt[$ _r.id] = !global.opt[$ _r.id];
            break;
        case "choice":
            var _n = array_length(_r.values);
            global.opt[$ _r.id] = (global.opt[$ _r.id] + _d + _n) mod _n;
            break;
    }
    options_apply();
};

finish = function() {
    closing = true;
    options_save();
    var _after = options_summary();
    if (_after != before) log_event("opciones", _after);      // Queda en el archivo de datos
    ui_block(10);
    var _cb = on_close;
    instance_destroy();
    if (!is_undefined(_cb)) _cb();
};
