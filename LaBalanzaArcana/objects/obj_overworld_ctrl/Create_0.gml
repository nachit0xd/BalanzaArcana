world_setup();                  // enlaza o construye el mapa y crea al jugador
camera_follow(obj_player);      // alinea la cámara antes del primer dibujo
intro_delay = 20;        // frames de espera antes de la introducción del maestro
instance_create_depth(0, 0, -100, obj_hud);
bridge_msg_cd = 0;       // espera entre avisos del puente cerrado
