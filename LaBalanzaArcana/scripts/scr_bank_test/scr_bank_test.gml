// Script con narrativa de cada ejercicio, NPC y enemigo. Se edita sin tocar la matemática (scr_bank_math).

// Reglas de cada enunciado (en caso de querer modificar o añadir más):
//  1) Se escribe siempre los números con cifras (4, no "cuatro").
//  2) El enunciado debe contener todos los números de la ecuación:
//       nivel 1: a y c          nivel 2: a, b y c
//       nivel 3: a, b, c y d    nivel 4: b y c (o la ecuación misma)
//  3) La incógnita es lo que se pregunta al final, y la respuesta debe ser exactamente la solución del banco.
//  4) Si la solución es 0 o negativa, el enunciado debe permitirlo (ej: "si faltan monedas, el cambio es negativo").
//  5) Un ejercicio sin enunciado no rompe nada: se muestra un texto genérico (ver ex_story).

// Diálogos de un NPC:      intro, outro            (los dice en su misión)
// Diálogos de un enemigo:  intro, win              (antes y después del combate)
// Si faltan, se usan frases genéricas.

function bank_text_init() {
    global.bank_text = {};   // id de ejercicio -> enunciado
    global.src_text  = {};   // id de NPC/enemigo -> diálogos

    // Mensajes generales de retroalimentación:
    global.msgs = {
        ok      : [ "¡Correcto! ¡Sigue así!", "¡Equilibrio perfecto!", "¡La balanza no se equivoca!" ],
        wrong1  : "Todavía no está equilibrada. Revisa el procedimiento:",
        kcr     : "Esta vez te muestro cómo se resuelve:",
        timeout : "¡Se acabó el tiempo!"
    };

    // Nivel 1 - NPCs
    global.src_text[$ "herrero"] = {
        intro : [ "¡Ah, aprendiz! Justo a tiempo.",
                  "Mi balanza de la forja se desajustó y las cuentas del taller no cuadran.",
                  "Ayúdame a descubrir el valor que falta en cada una." ],
        outro : [ "¡La balanza vuelve a estar en equilibrio!",
                  "Tienes buena mano para esto, aprendiz. Pásate por la molinera, seguro necesitan tu ayuda." ]
    };
    txt("herrero_1", "Tenía 4 espadas colgadas en la pared y ahora cuento 15. ¿Cuántas espadas nuevas aparecieron en mi taller?");
    txt("herrero_2", "En el yunque había 7 herraduras terminadas y, tras una tarde de trabajo, ahora hay 20. ¿Cuántas herraduras forjé esta tarde?");
    txt("herrero_3", "Guardaba 9 escudos en el rincón y la guardia me trajo algunos más. Ahora tengo 18. ¿Cuántos escudos trajo la guardia?");

    global.src_text[$ "molinera"] = {
        intro : [ "¡Bienvenido al molino! Con tanto trabajo ya perdí la cuenta de mis sacos.",
                  "¿Me echas una mano con unos números?" ],
        outro : [ "¡Gracias! Ahora sí puedo seguir moliendo tranquila.",
                  "Dicen que hay un duende extraño al otro lado del puente, ¡pero la guardiana es muy testaruda y no deja pasar a nadie!",
				  "También ten cuidado por los prados del sur... ¡escuché que hay un lobo feroz suelto!"]
    };
    txt("molinera_1", "Tenía 6 sacos de harina en el granero y, después de la cosecha, ahora hay 14. ¿Cuántos sacos nuevos llegaron?");
    txt("molinera_2", "Mi molino ya había molido 12 costales de trigo y al terminar la jornada llevo 19. ¿Cuántos costales molí hoy?");
    txt("molinera_3", "En mi despensa había 15 jarras de leche y esta mañana llegaron más. Ahora cuento 23. ¿Cuántas jarras llegaron?");

    global.src_text[$ "guardiana"] = {
        intro : [ "Alto ahí. Nadie cruza el puente sin ayudar con el registro de la guardia.",
                  "Ojo: a veces el valor que falta es cero... o incluso negativo." ],
        outro : [ "Registro en orden. Has demostrado tener la cabeza en equilibrio.",
                  "El puente queda abierto para ti.",
                  "Ten cuidado con el lado sur de la aldea... ronda un hombre-lobo muy agresivo." ]
    };
    txt("guardiana_1", "Mi puesto tenía 5 antorchas encendidas. Después de la ronda de la noche sigo contando 5. ¿Cuántas antorchas nuevas se encendieron durante la ronda?");
    txt("guardiana_2", "En la caja del peaje había 10 monedas y ahora solo quedan 3. ¿Cuántas monedas cambió la caja? (Si faltan monedas, el cambio es negativo).");
    txt("guardiana_3", "Anoche el registro del puente marcaba 8 viajeros y al amanecer solo quedan 2 anotados. ¿Cuántos viajeros cambiaron en el registro? (Si salieron del registro, el cambio es negativo).");

    global.src_text[$ "duende"] = {
        intro : [ "¡Hola, hola, aprendiz! ¡Soy el duende más listo de la aldea!",
                  "A-Aunque me quedé atrapado en este lado del río y del miedo mis cuentas se enredaron. ¿Me ayudas a desenredarlas?" ],
        outro : [ "¡Cuentas claras y duende contento!",
                  "Si aún tienes ganas de ayudar, podrías visitar los prados del sur si aún no has ido. ¡Yo no iría!" ]
    };
    txt("duende_1", "Tenía 3 piedras brillantes en mi bolsillo y ahora tengo 11. ¿Cuántas piedras brillantes encontré?");
    txt("duende_2", "En mi cesta había 11 setas y ahora hay 16. ¿Cuántas setas recogí?");
    txt("duende_3", "Tenía 14 bellotas y un cuervo ladrón se llevó algunas. Ahora me quedan 9. ¿Cuántas bellotas cambiaron en mi bolsa? (Si se llevaron bellotas, el cambio es negativo).");

    // Nivel 1 — ENEMIGOS
    global.src_text[$ "hombrelobo"] = {
        intro : [ "¡Grrr! Este prado es mío, y nadie pasa sin resolver mis acertijos.",
                  "¡Prepárate, aprendiz! Tendrás poco tiempo para responder." ],
        win   : [ "¡Aúuu...! Está bien, está bien: la balanza tiene razón.",
                  "El prado vuelve a ser seguro." ]
    };
    txt("hombrelobo_1", "El hombre-lobo aúlla 2 veces y la manada responde. En total se oyen 10 aullidos. ¿Cuántos aullidos respondió la manada?");
    txt("hombrelobo_2", "La manada tenía 13 lobos y, tras tu primer golpe, sigue habiendo 13. ¿Cuántos lobos nuevos se unieron a la pelea?");
    txt("hombrelobo_3", "El hombre-lobo reunía 16 garras de fuerza, pero tu hechizo le quitó algunas y ahora le quedan 7. ¿Cuántas garras cambió? (Si perdió fuerza, el cambio es negativo).");

    // Nivel 2 — NPCs
	global.src_text[$ "herbolaria"] = {
		intro: [
			"Me alejé del sendero buscando plantas para curar al bosque y perdí la cuenta de mis mezclas.",
			"Mi cuaderno suma lo que ya tenía y lo que aporta cada planta nueva. ¿Me ayudas a encontrar lo que falta?"
		],
		outro: [
			"¡Mis cuentas vuelven a tener sentido! Ya puedo preparar el remedio y encontrar el camino de regreso.",
			"Si sigues el zumbido de las abejas, encontrarás a un apicultor que también necesita ayuda."
		]
	};
	txt("herbolaria_1", "Preparé 3 frascos de remedio. Cada planta nueva que encuentro permite preparar 2 frascos más, y necesito 11 en total. ¿Cuántas plantas nuevas debo encontrar?");
	txt("herbolaria_2", "Mi poción ya contiene 9 gotas de savia. Cada flor luminosa añade 3 gotas; la receta pide 30. ¿Cuántas flores luminosas necesito?");
	txt("herbolaria_3", "He recogido 7 hojas sanas. Por cada brote que rescato encuentro 2 hojas más, y debo reunir 17. ¿Cuántos brotes debo rescatar?");

	global.src_text[$ "apicultor"] = {
		intro: [
			"¡Con cuidado, aprendiz! Las abejas están inquietas y debo repartir sus panales antes de que anochezca.",
			"Sé cuántos panales tenía al principio y cuántos aporta cada colmena. Ayúdame a completar el registro."
		],
		outro: [
			"¡Ni un panal fuera de lugar! Las abejas y yo te lo agradecemos.",
			"Vi a una cartógrafa entre los árboles. Su mapa se ha llenado de marcas extrañas; quizá puedas orientarla."
		]
	};
	txt("apicultor_1", "Recogí 4 panales ya listos, y cada colmena nueva que revisé me dio 5 panales más. Al final tenía 24 panales. ¿Cuántas colmenas nuevas revisé?");
	txt("apicultor_2", "Guardé 6 panales antes del amanecer. Cada colmena que reviso después aporta 4 panales; al terminar cuento 26. ¿Cuántas colmenas revisé después del amanecer?");
	txt("apicultor_3", "En mi cesta había 3 panales. Cada colmena escondida produce 5 más, y ahora tengo 33. ¿Cuántas colmenas escondidas encontré?");

	global.src_text[$ "cartografa"] = {
		intro: [
			"El bosque cambia de aspecto cuando la magia se desequilibra. Marqué el camino, pero mis distancias ya no cuadran.",
			"Si reconstruimos el mapa tramo por tramo, sabremos por dónde salir."
		],
		outro: [
			"¡Ahí está el sendero! La salida del bosque conduce a las ruinas del castillo.",
			"Ten cuidado: los guardianes de piedra y cristal siguen defendiendo estas tierras."
		]
	};
	txt("cartografa_1", "Ya marqué 8 tramos seguros en el mapa. Cada jornada de exploración añade 3 tramos, y necesito señalar 20. ¿Cuántas jornadas más debo registrar?");
	txt("cartografa_2", "El mapa muestra 5 señales antiguas. En cada ruta nueva descubro 6 señales más; al final aparecen 23. ¿Cuántas rutas nuevas encontré?");
	txt("cartografa_3", "Tengo dibujados 10 cruces de senderos. Cada sector que exploro añade 2 cruces; el mapa completo debe mostrar 18. ¿Cuántos sectores faltan por explorar?");
	
	// Nivel 2 — ENEMIGOS
	global.src_text[$ "golem"] = {
		intro: [
			"La piedra recuerda cada cambio de energía. Ningún paso queda sin peso en la balanza.",
			"Lee mis runas: si mi energía disminuye, el cambio que buscas será negativo."
		],
		win: [
			"Mis runas... vuelven a su sitio. La piedra ya no obedece al Desequilibrio.",
			"Prosigue, aprendiz. El bosque necesita una balanza firme."
		]
	};
	txt("golem_1", "El núcleo del gólem tiene 10 runas encendidas. Cada pulso de cambio firmado x modificaría su energía en 3 runas; ahora sigue marcando 10. ¿Cuál fue el cambio x?");
	txt("golem_2", "La armadura del gólem parte con 12 marcas de energía. Su núcleo suma 2 veces un cambio firmado x y el registro termina en 4 marcas. ¿Cuál es x? Si perdió energía, escribe un valor negativo.");
	txt("golem_3", "El Golém absorbió 9 anillos de ira, y cada golpe tuyo libera 4 veces esa calma. Solo cuando le quede 1 anillo, se romperá el cristal, ¿cuánta calma liberas por golpe?");

	global.src_text[$ "arana"] = {
		intro: [
			"Tic, tic... Cada hebra que tejo atrapa un poco más de luz.",
			"Si descifras mis cuentas, tal vez logres romper la red antes de que se cierre."
		],
		win: [
			"Crac... Mi red ya no puede retener la luz.",
			"Llévala contigo hacia el castillo; allí la oscuridad es más densa."
		]
	};
	txt("arana_1", "La araña guardó 2 gotas de luz en su red. Cada hebra nueva retiene 3 gotas más; la red brilla con 14. ¿Cuántas hebras nuevas tejió?");
	txt("arana_2", "El cristal tenía 11 unidades de brillo. Una alteración firmada x modifica 5 unidades por pulso, y al final solo queda 1. ¿Cuál es x? Una pérdida de brillo se escribe en negativo.");
	txt("arana_3", "La red empieza con 7 destellos. Cada hilo encantado añade 4, hasta reunir 31. ¿Cuántos hilos encantados hay?");
	
	// NIVEL 3 — ENEMIGOS
	global.src_text[$ "sombra"] = {
		intro: [
			"En estas ruinas hasta tu sombra tiene otra medida.",
			"Dos corrientes sostienen mi forma. Encuentra el valor que las iguala o quedarás atrapado entre ellas."
		],
		win: [
			"Mi forma se disuelve... Has separado la luz del engaño.",
			"Tras el portón, mi jefe utiliza una x al cuadrado... una misma ecuación puede esconder dos soluciones."
		]
	};
	txt("sombra_1", "Antes de tomar forma completa, la sombra libera 5 chispas de caos y crece con 4 veces cierta fuerza oscura. Para contenerla, esa fuerza debe igualar las 9 chispas más 3 veces esa misma fuerza que ya la sostienen.");
	txt("sombra_2", "Una corriente de la sombra lleva 6 chispas y 5 veces una intensidad x. La corriente opuesta lleva 13 chispas y 4 veces esa misma intensidad. ¿Qué valor de x iguala ambas corrientes?");
	txt("sombra_3", "En un lado de la balanza oscura hay 3 chispas más 6 veces una fuerza x; en el otro, 8 chispas más 5 veces esa fuerza. ¿Qué valor de x las equilibra?");

	global.src_text[$ "guerrero"] = {
		intro: [
			"Mi espada sigue una orden antigua: defender el castillo de todo intruso.",
			"Si puedes igualar la fuerza de mi ataque con la de tu defensa, quizá pueda descansar para siempre..."
		],
		win: [
			"La orden se ha cumplido. Mi espada ya puede volver a su vaina.",
			"Los guardianes oímos los planes del jefe... x al cuadrado más un término con x y una constante, todo igual a 0.",
			"Las dos raíces suman el opuesto del coeficiente de x; su producto es la constante... será una batalla complicada para ti, mago."
		]
	};
	txt("guerrero_1", "La espada del guerrero marca 4 unidades de fuerza más 3 veces un poder x. Tu escudo marca 6 unidades más una vez ese mismo poder. ¿Qué valor de x los iguala?");
	txt("guerrero_2", "El ataque del guerrero suma 5 unidades iniciales y 4 veces una fuerza x. Tu defensa suma 13 unidades iniciales y 2 veces esa fuerza. ¿Qué valor de x las equilibra?");
	txt("guerrero_3", "El filo encantado reúne 4 unidades más 8 veces un poder x. La barrera del aprendiz reúne 19 unidades más 5 veces el mismo poder. ¿Qué valor de x deja ambos lados iguales?");

	global.src_text[$ "centinela"] = {
		intro: [
			"Alto. Mi deber es pesar toda fuerza que intenta cruzar este corredor.",
			"Ni la fuerza del castillo ni la tuya pueden romper la igualdad."
		],
		win: [
			"Medida correcta. Ya no debo cerrarte el paso.",
			"Cada sello del Rey pide dos soluciones. Escríbelas en casillas distintas... solo así podrás derribar sus escudos."
		]
	};
	txt("centinela_1", "El mecanismo del centinela registra 2 unidades de carga más 5 veces una potencia x. Tu amuleto registra 8 unidades más 2 veces esa potencia. ¿Qué valor de x equilibra ambos registros?");
	txt("centinela_2", "Una placa de la puerta sostiene 7 unidades más 4 veces una carga x; la otra sostiene 19 unidades más una vez esa carga. ¿Qué valor de x mantiene estable el paso?");
	txt("centinela_3", "El sello del centinela marca 9 unidades más 3 veces una variación firmada x. El sello opuesto marca 3 unidades más una vez x. ¿Qué valor de x los iguala? Si la carga disminuye, escribe un número negativo.");

	global.src_text[$ "espectro"] = {
		intro: [
			"Oigo dos ecos en esta sala. Uno recuerda lo que fui; el otro repite la voz del Rey.",
			"Si los haces coincidir, podré dejar de vagar entre ambos."
		],
		win: [
			"Por fin hay silencio. Ya puedo recordar mi propia voz.",
			"Escucha los signos... las raíces del Rey también pueden ser negativas. No descartes una por su sombra."
		]
	};
	txt("espectro_1", "El primer eco guarda 10 notas de memoria más 2 veces una intensidad x. El segundo guarda 4 notas más 3 veces esa intensidad. ¿Qué valor de x hace que suenen iguales?");
	txt("espectro_2", "La voz del espectro reúne 6 notas iniciales y 7 veces una resonancia x. La voz del castillo reúne 18 notas iniciales y 4 veces esa resonancia. ¿Qué valor de x iguala los ecos?");
	txt("espectro_3", "Un eco conserva 5 unidades más 3 veces una variación firmada x; el otro conserva 17 unidades más 5 veces x. ¿Qué valor de x los equilibra? Una disminución de la resonancia se escribe en negativo.");

	global.src_text[$ "esqueleto"] = {
		intro: [
	        "Mis huesos se mueven con una magia prestada. Cada fragmento tira de la balanza en una dirección distinta.",
			"Iguala los dos lados y mi hechizo se deshará."
		],
		win: [
			"Clac... Los huesos vuelven a descansar.",
			"Tres sellos de protección rodean al Rey. Rompe cada uno con dos raíces antes de poder alcanzarlo."
		]
	};
	txt("esqueleto_1", "Un grupo de huesos tiene 3 marcas de magia más 2 veces una variación firmada x. El otro tiene 9 marcas más 4 veces x. ¿Qué valor de x los iguala? Si la magia se debilita, escribe un número negativo.");
	txt("esqueleto_2", "La mano izquierda del esqueleto reúne 4 marcas más 5 veces una fuerza x. La derecha reúne 16 marcas más 2 veces la misma fuerza. ¿Qué valor de x las equilibra?");
	txt("esqueleto_3", "La armadura rota guarda 12 marcas más 3 veces una fuerza x. Los huesos bajo ella guardan 6 marcas más 5 veces esa fuerza. ¿Qué valor de x iguala ambas partes?");

	// NIVEL 4 — ENEMIGO FINAL: REY DEL DESEQUILIBRIO
	global.src_text[$ "rey_desequilibrio"] = {
		intro: [
			"Así que el aprendiz ha llegado hasta mi sala. Has equilibrado el bosque y liberado a mis guardianes.",
			"Pero hasta aquí llega tu camino... ¡yo, el Rey del Desequilibrio, acabaré contigo gracias a mi poder cuadrático!",
			"Tres sellos protegen mi escudo mágico... cada uno encierra una ecuación con dos soluciones posibles...",
			"Intenta romper mis sellos, ¡pero eso será imposible para un humano como tu!"
		],
		shield: [
			"¡¿C-Cómo es posible?! ¡Mis tres sellos... destruidos! Pero... ¡aún me queda fuerza para combatir!",
			"Puede que me dañes ahora, ¡pero no me rendiré hasta destruirte! Veamos cuánto resiste tu balanza, aprendiz."
		],
		win: [
			"I-Imposible... mi poder mágico... se desvanece...",
			"Puedo sentir... el equilibrio vuelve en mi interior...",
			"El Desequilibrio ya no me pertenece. El reino de Aequor... puede encontrar su equilibrio... una vez más..."
		]
	};
	txt("rey_1", "Una inscripción del Rey muestra x² - 5x + 6 = 0. La balanza solo se estabiliza cuando encuentras los dos valores de x que la cumplen. ¿Cuáles son las dos raíces?");
	txt("rey_2", "En otra inscripción aparece x² - 2x - 8 = 0. Un valor negativo puede ser una raíz: la balanza acepta ambos signos. ¿Cuáles son las dos raíces?");
	txt("rey_3", "Las runas del Rey forman x² + 7x + 6 = 0. Esta vez ambas raíces están del lado negativo de la balanza. ¿Cuáles son los dos valores de x?");
	txt("rey_4", "Sobre el suelo se enciende x² - 3x - 10 = 0. El hechizo combina una raíz positiva y otra negativa. ¿Cuáles son las dos raíces?");
	txt("rey_5", "La balanza del Rey revela x² - 7x + 12 = 0. Dos valores distintos devuelven el equilibrio a la inscripción. ¿Cuáles son las dos raíces?");
	txt("rey_6", "La última inscripción muestra x² + 7x + 12 = 0. Busca los dos valores negativos que apagan sus runas. ¿Cuáles son las dos raíces?");
}

// Atajo para registrar un enunciado
function txt(_id, _story) {
    global.bank_text[$ _id] = _story;
}
