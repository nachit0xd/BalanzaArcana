// Resolución del juego
#macro BASE_W     320
#macro BASE_H     180
#macro VIEW_SCALE 4
#macro GUI_W      (BASE_W * VIEW_SCALE)   // 1280px
#macro GUI_H      (BASE_H * VIEW_SCALE)   // 720px

// Función que se llama solo al inicio del juego
function display_init() {
    global.cam = camera_create_view(0, 0, BASE_W, BASE_H);
    display_set_gui_size(GUI_W, GUI_H);
	window_apply_size();
}

// Función que se llama en cada room (desde Room Start de obj_game)
function display_apply_to_room() {
    view_enabled     = true;
    view_visible[0]  = true;
    view_camera[0]   = global.cam;
    view_wport[0]    = GUI_W;
    view_hport[0]    = GUI_H;
    surface_resize(application_surface, GUI_W, GUI_H);
	global.win_apply_t = 2;       // reaplica el tamaño de la ventana unos frames después de cambiar de room
}