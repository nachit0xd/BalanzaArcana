sprite_index = spr_npc;
image_speed  = 0;
image_index  = 0;

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

if (npc_id != "") {
    if (!variable_struct_exists(global.bank_src, npc_id)) {
        show_debug_message("NPC desconocido en la room: " + npc_id);
        instance_destroy();
        exit;
    }
    var _source = global.bank_src[$ npc_id];
    if (_source.kind != "npc" || _source.level != global.level) {
        show_debug_message("NPC de otro nivel o tipo: " + npc_id);
        instance_destroy();
        exit;
    }
    setup(npc_id);
}
