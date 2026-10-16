sprite_index = spr_npc;
image_speed  = 0;
image_index  = 0;

npc_id     = "";            // id del banco ("herrero", ...); lo asigna setup()
talk_range = 24;            // distancia máxima para hablar (px)
can_talk   = false;         // true cuando el jugador puede hablarle ahora mismo

// Caja de colisión en los pies (12 x 8 px): bloquea al jugador
hb_l = -6;  hb_r = 5;
hb_t = -7;  hb_b = 0;

depth = -y;                 // ordenar por altura: quien está más abajo se dibuja encima

setup = function(_id) {
    npc_id      = _id;
    image_index = npc_look_frame(_id);
};
