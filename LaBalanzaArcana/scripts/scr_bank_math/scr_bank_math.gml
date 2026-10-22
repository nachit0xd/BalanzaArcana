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
    eq1("herrero_1",    "herrero",      5, 19,  14);
    eq1("herrero_2",    "herrero",      8, 25,  17);
    eq1("herrero_3",    "herrero",     11, 23,  12);

    eq1("molinera_1",   "molinera",     7, 22,  15);
    eq1("molinera_2",   "molinera",    13, 24,  11);
    eq1("molinera_3",   "molinera",    16, 35,  19);

    eq1("guardiana_1",  "guardiana",    6,  6,   0);
    eq1("guardiana_2",  "guardiana",   14,  5,  -9);
    eq1("guardiana_3",  "guardiana",   12,  4,  -8);

    eq1("duende_1",     "duende",       4, 10,   6);
    eq1("duende_2",     "duende",      10, 23,  13);
    eq1("duende_3",     "duende",      17, 10,  -7);

    eq1("hombrelobo_1", "hombrelobo",   3, 21,  18);
    eq1("hombrelobo_2", "hombrelobo",  16, 17,   1);
    eq1("hombrelobo_3", "hombrelobo",  19,  7, -12);

    // NIVEL 2:  a + b·x = c
    //  id                origen        a   b   c    x
    eq2("herbolaria_1", "herbolaria",   4, 3, 22,   6);
    eq2("herbolaria_2", "herbolaria",   8, 4, 44,   9);
    eq2("herbolaria_3", "herbolaria",   6, 5, 41,   7);

    eq2("apicultor_1",  "apicultor",    5, 4, 37,   8);
    eq2("apicultor_2",  "apicultor",    7, 6, 37,   5);
    eq2("apicultor_3",  "apicultor",    2, 5, 52,  10);

    eq2("cartografa_1", "cartografa",   9, 5, 29,   4);
    eq2("cartografa_2", "cartografa",  11, 3, 47,  12);
    eq2("cartografa_3", "cartografa",  12, 4, 24,   3);

    eq2("golem_1",      "golem",       15, 4, 15,   0);
    eq2("golem_2",      "golem",       18, 3,  3,  -5);
    eq2("golem_3",      "golem",       17, 4,  1,  -4);

    eq2("arana_1",      "arana",        3, 6, 15,   2);
    eq2("arana_2",      "arana",       20, 4,  8,  -3);
    eq2("arana_3",      "arana",        8, 3, 47,  13);

    // NIVEL 3:  a + b·x = c + d·x
    //  id                origen        a   b  c   d    x
    eq3("sombra_1",     "sombra",       6, 7, 21, 4,   5);
    eq3("sombra_2",     "sombra",       8, 9, 20, 7,   6);
    eq3("sombra_3",     "sombra",       5, 8, 26, 5,   7);

    eq3("guerrero_1",   "guerrero",     7, 6, 16, 3,   3);
    eq3("guerrero_2",   "guerrero",     9, 8, 25, 4,   4);
    eq3("guerrero_3",   "guerrero",    11, 7, 29, 5,   9);

    eq3("centinela_1",  "centinela",    4, 7, 20, 5,   8);
    eq3("centinela_2",  "centinela",    6, 9, 16, 4,   2);
    eq3("centinela_3",  "centinela",   20, 6,  8, 3,  -4);

    eq3("espectro_1",   "espectro",    15, 2,  4, 3,  11);
    eq3("espectro_2",   "espectro",     8, 9, 21, 8,  13);
    eq3("espectro_3",   "espectro",     7, 3, 23, 5,  -8);

    eq3("esqueleto_1",  "esqueleto",    5, 4, 23, 6,  -9);
    eq3("esqueleto_2",  "esqueleto",    8, 5, 32, 3,  12);
    eq3("esqueleto_3",  "esqueleto",    6, 7, 26, 5,  10);

    // NIVEL 4:  x² + b·x + c = 0   (2 ecuaciones por fase del jefe)
    //    id       origen             fase  b   c   r1  r2
    eq4p("rey_1", "rey_desequilibrio", 1, -11,  28,   4,  7);
    eq4p("rey_2", "rey_desequilibrio", 1,  -1, -30,  -5,  6);
    eq4p("rey_3", "rey_desequilibrio", 2,  10,  16,  -2, -8);
    eq4p("rey_4", "rey_desequilibrio", 2,   3, -18,   3, -6);
    eq4p("rey_5", "rey_desequilibrio", 3, -14,  45,   5,  9);
    eq4p("rey_6", "rey_desequilibrio", 3,   5,   4,  -1, -4);
}
