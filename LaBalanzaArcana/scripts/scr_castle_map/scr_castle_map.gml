// Mapa PROVISIONAL del castillo ruinoso (Nivel 3): 40 x 23 casillas de 16 px.
//
// LEYENDA
//   =  suelo de piedra    W  muro (sólido)      S  escombros (sólidos)
//   P  aparición del jugador
//   1  sombra hostil   2  guerrero no muerto   3  centinela de las ruinas
//   4  espectro fantasmal   5  esqueleto oscuro   (enemigos que vagan)
//   G  portón del Rey (esquina superior izquierda de un portón de 2 x 2 casillas)
// =====================================================================

function castle_map() {
    return [
        "WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW",
        "W===========W===========W===========WWWW",
        "W===========W==========SW=====S=S===WWWW",
        "W=S=========W===========W===========WWWW",
        "W=========S=W=====3=====W===========WWWW",
        "W=====1====SW===========W===========WWWW",
        "W===========W===========W=====5=====WWWW",
        "W===========W===========W===========WWWW",
        "W=====S=====W====SWW=======S========WWWW",
        "W====S======W=====SS===S============WWWW",
        "W============S======================WWWW",
        "==P=================================G=WW",
        "========================W=============WW",
        "W============S==========W===========WWWW",
        "W===========W===========W======S====WWWW",
        "W======S====W=====WW====W===========WWWW",
        "W===========W===========W===S=S=====WWWW",
        "W=S=======S=W==S========W=======S===WWWW",
        "W======2====W=====4=====W===========WWWW",
        "W===========W===========W===========WWWW",
        "W===S======SW===========W===========WWWW",
        "W===========W===========W===========WWWW",
        "WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW"
    ];
}

// Carácter del mapa -> nombre del marcador (coincide con el id del enemigo)
function castle_legend() {
    return [
        ["P", "spawn"],
        ["1", "sombra"],
        ["2", "guerrero"],
        ["3", "centinela"],
        ["4", "espectro"],
        ["5", "esqueleto"],
        ["G", "gate"]
    ];
}
