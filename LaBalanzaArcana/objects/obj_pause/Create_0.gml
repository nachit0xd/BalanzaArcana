// Objeto controlador de Pause

items   = ["Continuar", "Opciones", "Cómo jugar", "Volver al menú principal"];
sel     = 0;
mode    = "main";            // "main" | "howto"
grace   = 8;                 // Frames iniciales en que se ignora la tecla
closing = false;

resume = function() {
    log_event("pausa_fin", "");
    pause_close();
};
