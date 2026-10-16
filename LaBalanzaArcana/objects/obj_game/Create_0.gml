// Evita duplicados si se volviera a pasar por rm_init
if (instance_number(obj_game) > 1) { instance_destroy(); exit; }

randomize();          // semilla aleatoria distinta en cada ejecución
config_init();
log_system_init();
options_load();
options_apply();
audio_init();
bank_init();
story_text_init();
progress_reset();
display_init();
window_set_caption(GAME_TITLE);

// Estado global de la partida
global.player_code = "";     // código pseudónimo del participante
global.debug       = DEBUG_MODE;

room_goto(rm_title);
