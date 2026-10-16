if (closing) exit;

var _px = 96, _py = 40, _pw = GUI_W - 192, _ph = GUI_H - 80;
var _cx = GUI_W / 2;

draw_set_alpha(0.85);
draw_set_colour(c_black);
draw_rectangle(0, 0, GUI_W, GUI_H, false);
draw_set_alpha(1);
draw_panel(_px, _py, _pw, _ph);

draw_set_font(fnt_ui);
var _lh = string_height("M") + 10;
draw_set_font(fnt_math);
var _th = string_height("M");

draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_colour(COL_WARN);
draw_text(_cx, _py + 24, "¡Gracias por jugar!");

draw_set_font(fnt_ui);
var _y = _py + 24 + _th + 24;

draw_set_colour(COL_TEXT);
draw_text(_cx, _y, "Tu código: " + global.player_code + "     Puntaje: " + string(global.score)
                 + "     Insignias: " + string(array_length(global.badges)));
_y += _lh * 2;

draw_set_colour(COL_DIM);
draw_text_ext(_cx, _y, "Tus respuestas se guardaron en este archivo:", _lh, _pw - 100);
_y += _lh;
draw_set_colour(COL_TEXT);
draw_text_ext(_cx, _y, path_text, _lh - 4, _pw - 100);
_y += string_height_ext(path_text, _lh - 4, _pw - 100) + _lh;

draw_set_colour(COL_DIM);
draw_text(_cx, _y, log_upload_status());
_y += _lh * 2;

// Acciones
draw_set_colour(COL_WARN);
draw_text(_cx, _y, "C: copiar resumen      O: abrir carpeta de datos      Enter: volver al menú");
_y += _lh * 2;

draw_set_colour(COL_DIM);
draw_text_ext(_cx, _y, "Si te lo piden, copia el resumen y pégalo en el formulario del post-test junto con tu código.", _lh, _pw - 100);

// Mensajes de las acciones
draw_set_colour(COL_GOOD);
if (copied_t > 0) draw_text(_cx, _py + _ph - 80, "¡Resumen copiado!");
draw_set_colour(COL_BAD);
if (folder_msg != "") draw_text(_cx, _py + _ph - 44, folder_msg);

// Restaurar estado de dibujo
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_colour(c_white);
