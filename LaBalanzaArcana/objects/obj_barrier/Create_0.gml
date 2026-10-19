// Cada instancia puede sobreescribir barrier_kind y su sprite en la sala
image_speed = 0;
notice_cd = 0;
can_talk = false;

if (barrier_kind == "bridge") {
    hb_l = 0; hb_r = 3;
    hb_t = 0; hb_b = span_px - 1;
    depth = -y;
} else {
    hb_l = -8; hb_r = 23;
    hb_t = -15; hb_b = 16;
    depth = -y + 40;
}

image_index = barrier_open(barrier_kind) ? 1 : 0;