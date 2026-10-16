if (phase == 0) {
    alpha += spd;
    if (alpha >= 1) {
        alpha = 1;
        phase = 1;
        wait  = 6;                     // un instante en negro, ya dentro de la nueva room
        room_goto(target);
    }
} else {
    if (wait > 0) {
        wait--;
    } else {
        alpha -= spd;
        if (alpha <= 0) instance_destroy();
    }
}