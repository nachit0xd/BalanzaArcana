// Cinemática breve de apertura con una balanza animada
// que se desequilibra y vuelve a equilibrarse, con el texto de la
// historia. Se puede avanzar con Enter/Espacio y saltar con Esc
slides     = intro_slides();
idx        = 0;                 // lámina actual
st         = 0;                 // frames desde que empezó la lámina (anima la balanza)
ht         = 0;                 // frames con el texto ya escrito (tiempo de lectura)
total_t    = 0;                 // frames totales
chars      = 0;                 // letras visibles
text_full  = "";
typed_done = false;
ending     = false;

stars = [];
repeat (90) array_push(stars, { x: irandom(GUI_W), y: irandom(GUI_H), ph: random(360), s: choose(2, 2, 3, 4) });

show_slide = function() {
    draw_set_font(fnt_ui);
    text_full  = text_wrap(slides[idx].text, 960);
    chars      = 0;
    typed_done = false;
    st = 0;
    ht = 0;
};

next_slide = function() {
    idx++;
    if (idx >= array_length(slides)) finish();
    else show_slide();
};

finish = function() {
    if (ending) return;
    ending = true;
    room_transition(rm_village);
};

show_slide();
