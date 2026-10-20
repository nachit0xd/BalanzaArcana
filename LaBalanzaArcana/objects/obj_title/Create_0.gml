// Objeto de controlador para el título
state       = (variable_global_exists("splash_done") && global.splash_done) ? TITLE_STATE.MENU : TITLE_STATE.SPLASH;
t           = 0;                // Frames en el estado actual
tt          = 0;                // Frames totales (para las animaciones)
sel         = 0;                // Opción del menú
confirm_sel = 0;                // 0 = "Sí, es correcto" | 1 = "Corregir"
code_text   = "";
code_error  = "";
starting    = false;            // true cuando ya se está pasando al juego
menu_items  = ["Jugar", "Cómo jugar", "Opciones", "Créditos", "Salir"];

stars = [];
repeat (80) array_push(stars, { x: irandom(GUI_W), y: irandom(GUI_H), ph: random(360), s: choose(2, 2, 3, 4) });
glyphs = [];
repeat (16) array_push(glyphs, new_glyph(true));

// Aviso de datos: se parte en renglones una sola vez
notice_wrapped = [];
draw_set_font(fnt_ui);
var _nt = title_notice();
for (var i = 0; i < array_length(_nt); i++) {
    array_push(notice_wrapped, text_wrap(_nt[i], 980));
}

set_state = function(_s) {
    state = _s;
    t = 0;
};

accept_pressed = function() {
    return keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space);
};
