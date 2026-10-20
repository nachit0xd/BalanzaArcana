// Objeto de control de transiciones entre rooms
persistent = true;
target = noone;        // Room de destino
phase  = 0;            // 0 = oscureciendo, 1 = aclarando
alpha  = 0;
spd    = 1 / 30;       // Medio segundo por fundido (a 60 fps)
wait   = 0;            // Frames de espera con la pantalla en negro
