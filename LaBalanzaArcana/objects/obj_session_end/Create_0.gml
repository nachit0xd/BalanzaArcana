// Pantalla de fin de sesión que agradece, muestra el código del participante,
// dónde quedó el archivo de datos y permite copiar un resumen de una línea
// y abrir la carpeta (Windows). Al cerrarla vuelve al menú principal.

closing    = false;
grace      = 10;                 // frames iniciales en que se ignoran las teclas
copied_t   = 0;                  // frames que se muestra "¡Copiado!"
folder_msg = "";
summary    = session_summary_text();
path_text  = log_file_path();

log_event("sesion_resumen", summary);      // el resumen también queda en el archivo
