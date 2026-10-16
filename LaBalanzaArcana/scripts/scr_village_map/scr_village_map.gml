// Mapa PROVISIONAL de 40 x 23 casillas de 16 px (640 x 368). Cada carácter es
// una casilla. Cuando exista el mapa definitivo pintado en el editor (capas
// "Ground" y "Solid"), este script deja de usarse.

// LEYENDA:
//   .  césped        ,  césped con flores    =  camino
//   ~  agua (sólida) B  puente               D  puerta (se puede pisar)
//   T  árbol (sólido) W  pared (sólida)       R  techo (sólido)
//   F  valla (sólida) S  piedra (sólida)      P  aparición del jugador
//   1  herrero   2  molinera   3  guardiana   4  duende amistoso   (NPC)
//   5  hombre-lobo (enemigo que vaga por el prado del sur)
//   X  salida este (marcadores exit_east_<fila>)

function village_map() {
    return [
        "TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT",
        "T.....,..........,..........~~~........T",
        "T,TT........T.........T,....~~~...,....T",
        "T.T....,.......RRRRR...T....~~~...TT...T",
        "T.,..RRRRR...,.RRRRR..T.,...~~~....T...T",
        "T....RRRRR.....WWWWW........~~~........T",
        "T..,.WWWWW....,WWDWW.....,..~~~.....,..T",
        "T....WWDWW.......=..,.......~~~,.......T",
        "T...,..=.......,.=2.......,.~~~......,.T",
        "T......=1.,......=...,.....S~~~S,......T",
        "T....,.=........,=.........3~~~.......,T",
        "T.==========================BBB=======X=",
        "T.==========================BBB=======X=",
        "T,..........=..........,....~~~...,....T",
        "T......,....=.....,4.......S~~~S.......T",
        "T.,.FFFFFF..=,..........,...~~~....,...T",
        "T...F...,...=......,........~~~..T.T...T",
        "T..,F.......=.,.....T..5.,..~~~...T.,..T",
        "T...F....,..P.......,T......~~~,.......T",
        "T...,.........T,........T.,.~~~.....T,.T",
        "T.TT......,....T.....,......~~~.,T.....T",
        "T....,..........,..........,~~~.......,T",
        "TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT"
    ];
}

// Carácter del mapa -> nombre del marcador (coincide con el id del NPC o enemigo)
function village_legend() {
    return [
        ["P", "spawn"],
        ["1", "herrero"],
        ["2", "molinera"],
        ["3", "guardiana"],
        ["4", "duende"],
        ["5", "hombrelobo"]
    ];
}

