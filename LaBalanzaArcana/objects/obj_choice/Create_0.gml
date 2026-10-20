// Objeto de controlador para las elecciones de Opciones

prompt      = "";
prompt_wrap = "";
options     = [];
sel         = 0;
on_choose   = undefined;
grace       = 8;                 // Frames iniciales en que se ignora la tecla
closing     = false;

start = function(_prompt, _options, _on_choose) {
    options   = _options;
    on_choose = _on_choose;
    prompt    = _prompt;
    draw_set_font(fnt_ui);
    prompt_wrap = text_wrap(_prompt, 900);
};
