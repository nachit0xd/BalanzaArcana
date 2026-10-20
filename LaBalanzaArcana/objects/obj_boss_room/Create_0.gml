// Objeto que actúa como controlador de la sala del jefe
// Crea el HUD, deja que el maestro dé la introducción del nivel y, cuando termina, inicia la batalla final

instance_create_depth(0, 0, -100, obj_hud);    // Vida, puntaje y nivel
stage       = 0;                               // 0 = esperando, 1 = introducción, 2 = batalla iniciada
intro_delay = 30;                              // Frames de espera antes de la introducción
