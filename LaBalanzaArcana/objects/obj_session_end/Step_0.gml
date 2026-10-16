if (closing) exit;
if (grace > 0) { grace--; exit; }

if (copied_t > 0) copied_t--;

// C: copiar el resumen al portapapeles
if (keyboard_check_pressed(ord("C"))) {
    clipboard_set_text(summary);
    copied_t = 150;
}

// O: abrir la carpeta de datos
if (keyboard_check_pressed(ord("O"))) {
    folder_msg = open_data_folder() ? "" : "Esta función solo está disponible en Windows. La ruta aparece arriba.";
}

// Enter / Espacio: volver al menú
if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
    closing = true;
    ui_block(10);
    room_transition(rm_title);
}
