// Script con banco fijo de ejercicios matemáticos

//   Nivel 1: 4 NPC + 1 enemigo     Nivel 2: 3 NPC + 2 enemigos
//   Nivel 3: 5 enemigos            Nivel 4: jefe con 3 fases (2 ecuaciones por fase)

// Constructores (ver scr_bank_core):
//   eq1(id, origen, a, c, x)            a + x = c
//   eq2(id, origen, a, b, c, x)         a + b·x = c
//   eq3(id, origen, a, b, c, d, x)      a + b·x = c + d·x
//   eq4p(id, origen, fase, b, c, r1, r2)  x² + b·x + c = 0   (nivel 4, con fase del jefe)


// Nivel 4, igual que eq4, pero guarda la fase (1 a 3) del jefe
function eq4p(_id, _src, _phase, _b, _c, _r1, _r2) {
    var _e = eq4(_id, _src, _b, _c, _r1, _r2);
    _e.phase = _phase;
    return _e;
}

function bank_load_math() {

    // Orígenes: NPC, enemigos y jefe
    //      id                    nombre                       tipo    nivel  vida/sellos
    src_add("herrero",           "Herrero del pueblo",         "npc",   1, 0);
    src_add("molinera",          "Molinera alegre",            "npc",   1, 0);
    src_add("guardiana",         "Guardiana del puente",       "npc",   1, 0);
    src_add("duende",            "Duende amistoso",            "npc",   1, 0);
    src_add("hombrelobo",        "Hombre-lobo",                "enemy", 1, 2);

    src_add("herbolaria",        "Herbolaria perdida",         "npc",   2, 0);
    src_add("apicultor",         "Apicultor del bosque",       "npc",   2, 0);
    src_add("cartografa",        "Cartógrafa extraviada",      "npc",   2, 0);
    src_add("golem",             "Gólem de piedra",            "enemy", 2, 3);
    src_add("arana",             "Araña de cristal",           "enemy", 2, 3);

    src_add("sombra",            "Sombra hostil",              "enemy", 3, 3);
    src_add("guerrero",          "Guerrero no muerto",         "enemy", 3, 3);
    src_add("centinela",         "Centinela de las ruinas",    "enemy", 3, 3);
    src_add("espectro",          "Espectro fantasmal",         "enemy", 3, 3);
    src_add("esqueleto",         "Esqueleto oscuro",           "enemy", 3, 3);

    src_add("rey_desequilibrio", "Rey del Desequilibrio",   "boss",  4, 3);   // 3 sellos

    // NIVEL 1:  a + x = c
    //  id                origen       a    c    x
    eq1("herrero_1",    "herrero",      4, 15,  11);
    eq1("herrero_2",    "herrero",      7, 20,  13);
    eq1("herrero_3",    "herrero",      9, 18,   9);

    eq1("molinera_1",   "molinera",     6, 14,   8);
    eq1("molinera_2",   "molinera",    12, 19,   7);
    eq1("molinera_3",   "molinera",    15, 23,   8);

    eq1("guardiana_1",  "guardiana",    5,  5,   0);
    eq1("guardiana_2",  "guardiana",   10,  3,  -7);
    eq1("guardiana_3",  "guardiana",    8,  2,  -6);

    eq1("duende_1",     "duende",       3, 11,   8);
    eq1("duende_2",     "duende",      11, 16,   5);
    eq1("duende_3",     "duende",      14,  9,  -5);

    eq1("hombrelobo_1", "hombrelobo",   2, 10,   8);
    eq1("hombrelobo_2", "hombrelobo",  13, 13,   0);
    eq1("hombrelobo_3", "hombrelobo",  16,  7,  -9);

    // NIVEL 2:  a + b·x = c
    //  id                origen        a   b   c    x
    eq2("herbolaria_1", "herbolaria",   3, 2, 11,   4);
    eq2("herbolaria_2", "herbolaria",   9, 3, 30,   7);
    eq2("herbolaria_3", "herbolaria",   7, 2, 17,   5);

    eq2("apicultor_1",  "apicultor",    4, 5, 24,   4);
    eq2("apicultor_2",  "apicultor",    6, 4, 26,   5);
    eq2("apicultor_3",  "apicultor",    3, 5, 33,   6);

    eq2("cartografa_1", "cartografa",   8, 3, 20,   4);
    eq2("cartografa_2", "cartografa",   5, 6, 23,   3);
    eq2("cartografa_3", "cartografa",  10, 2, 18,   4);

    eq2("golem_1",      "golem",       10, 3, 10,   0);
    eq2("golem_2",      "golem",       12, 2,  4,  -4);
    eq2("golem_3",      "golem",        9, 4,  1,  -2);

    eq2("arana_1",      "arana",        2, 3, 14,   4);
    eq2("arana_2",      "arana",       11, 5,  1,  -2);
    eq2("arana_3",      "arana",        7, 4, 31,   6);

    // NIVEL 3:  a + b·x = c + d·x
    //  id                origen        a   b  c   d    x
    eq3("sombra_1",     "sombra",       5, 4,  9, 3,   4);
    eq3("sombra_2",     "sombra",       6, 5, 13, 4,   7);
    eq3("sombra_3",     "sombra",       3, 6,  8, 5,   5);

    eq3("guerrero_1",   "guerrero",     4, 3,  6, 1,   1);
    eq3("guerrero_2",   "guerrero",     5, 4, 13, 2,   4);
    eq3("guerrero_3",   "guerrero",     4, 8, 19, 5,   5);

    eq3("centinela_1",  "centinela",    2, 5,  8, 2,   2);
    eq3("centinela_2",  "centinela",    7, 4, 19, 1,   4);
    eq3("centinela_3",  "centinela",    9, 3,  3, 1,  -3);

    eq3("espectro_1",   "espectro",    10, 2,  4, 3,   6);
    eq3("espectro_2",   "espectro",     6, 7, 18, 4,   4);
    eq3("espectro_3",   "espectro",     5, 3, 17, 5,  -6);

    eq3("esqueleto_1",  "esqueleto",    3, 2,  9, 4,  -3);
    eq3("esqueleto_2",  "esqueleto",    4, 5, 16, 2,   4);
    eq3("esqueleto_3",  "esqueleto",   12, 3,  6, 5,   3);

    // NIVEL 4:  x² + b·x + c = 0   (2 ecuaciones por fase del jefe)
    //    id       origen             fase  b   c   r1  r2
    eq4p("rey_1", "rey_desequilibrio", 1, -5,   6,   2,  3);
    eq4p("rey_2", "rey_desequilibrio", 1, -2,  -8,  -2,  4);
    eq4p("rey_3", "rey_desequilibrio", 2,  7,   6,  -1, -6);
    eq4p("rey_4", "rey_desequilibrio", 2, -3, -10,   5, -2);
    eq4p("rey_5", "rey_desequilibrio", 3, -7,  12,   3,  4);
    eq4p("rey_6", "rey_desequilibrio", 3,  7,  12,  -3, -4);
}
