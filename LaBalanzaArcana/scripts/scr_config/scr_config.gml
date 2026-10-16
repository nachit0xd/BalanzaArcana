// Constantes del juego
#macro GAME_TITLE   "La Balanza Arcana"
#macro GAME_VERSION "0.5.0"
#macro MAX_LEVEL    4
#macro DEBUG_MODE   (GM_build_type == "run")   // true al ejecutar desde el IDE

// Parámetros ajustables para los niveles/gamificación
function config_init() {
    global.cfg = {
        // Índice = nivel (la posición 0 no se utiliza)
        time_limit : [0, 20, 30, 40, 80],   // segundos por intento
		life_loss  : [0, 34, 34, 34, 50],   // % de vida que cuesta cada fallo: niveles 1-3 = 3 golpes, jefe = 2 golpes

        // Puntaje
        pts_first  : 100,
        pts_second : 60,
        bonus_fast : 25,    // primer intento con más del 50 % del tiempo
        bonus_slow : 10,    // primer intento con 50 % o menos
        bonus_threshold : 0.5,
		show_eq_npc : true   // true: enunciado + ecuación | false: solo enunciado
    };
}

function cfg_time(_level)      { return global.cfg.time_limit[_level]; }
function cfg_life_loss(_level) { return global.cfg.life_loss[_level]; }