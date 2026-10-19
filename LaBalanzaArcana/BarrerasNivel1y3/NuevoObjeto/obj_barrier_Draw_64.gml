if (barrier_kind != "gate" || !can_talk) exit;

var _txt = "[Espacio]  Examinar el portón";
draw_set_font(fnt_ui);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
var _w = string_width(_txt) + 48;
draw_set_alpha(0.7);
draw_set_colour(c_black);
draw_rectangle(GUI_W / 2 - _w / 2, GUI_H - 84, GUI_W / 2 + _w / 2, GUI_H - 36, false);
draw_set_alpha(1);
draw_set_colour(COL_TEXT);
draw_text(GUI_W / 2, GUI_H - 60, _txt);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_colour(c_white);
