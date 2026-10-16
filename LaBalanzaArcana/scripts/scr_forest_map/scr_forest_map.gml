// Mapa PROVISIONAL de 40 x 23 casillas de 16 px (640 x 368). Cada carácter es
// una casilla. Cuando exista el mapa definitivo pintado en el editor (capas
// "Ground" y "Solid"), este script deja de usarse.

// LEYENDA:
//   .  césped        ,  césped con flores    =  camino
//   ~  agua (sólida) B  puente               D  puerta (se puede pisar)
//   T  árbol (sólido) W  pared (sólida)       R  techo (sólido)
//   F  valla (sólida) S  piedra (sólida)      P  aparición del jugador
//   1  herbolaria   2  apicultor   3  cartógrafa   (NPC)
//   4  gólem de piedra   5  araña de cristal   (enemigos que vagan)
//   X  salida este (marcadores exit_east_<fila>)

function forest_map() {
    return [
        "TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT",
        "TT....TT.TT.....T,....T...T.,.........TT",
        "TTT.........,.....T....,~~~~~T...T,.T..T",
        "TT...T.T.......T.TT..TT.~~~~~,.........T",
        "T.,..T....T..T.......T..~~~~~....TT,.T.T",
        "T.......,.T...T....,.TT.~~~~~.T.....T..T",
        "T..TT.T..T....,..2..T....,...TT.....,T.T",
        "T........,..........,...TT...T.,....T.TT",
        "T...,......============...,....T....T,.T",
        "TT......1.,============......T..T......T",
        "T....,.....==...,....==...3,..........,T",
        "T============....TTT.==.......========X=",
        "T=P==========.TT.,T..=================X=",
        "T,..........,........===========..,....T",
        "T....T.T...TT.~~~~~~.........,.........T",
        "T.,..........T~~~~~~....4..T......5,...T",
        "T...T...,...T.~~~~~~TT......TTT......TTT",
        "T.T,.....T...T~~~~~~.....,.T...T....,TTT",
        "T.......T,...T~~~~~~,......TT..,..T.T..T",
        "TT..,.....TT..T,..T.......,......TT..,.T",
        "TTTTT...T.,..TT.....T,..T....T..T..T...T",
        "T....,.....T....,T..T..T.T.,.....TT...,T",
        "TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT"
    ];
}

// Carácter del mapa -> nombre del marcador (coincide con el id del NPC o enemigo)
function forest_legend() {
    return [
        ["P", "spawn"],
        ["1", "herbolaria"],
        ["2", "apicultor"],
        ["3", "cartografa"],
        ["4", "golem"],
        ["5", "arana"]
    ];
}