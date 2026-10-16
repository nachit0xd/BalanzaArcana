// Narrativa del Mundo (no de cada ejercicio): introducción del maestro
// al inicio de cada nivel, consejos de los NPC y cierres de nivel. Los
// enunciados y diálogos de cada NPC siguen en scr_bank_text.
//
// Se llama desde obj_game (Create), después de bank_init().
//
// Las claves de los structs son el número de nivel como texto ("1", "2"...).
// Cada línea es un dlg(quien_habla, texto). Mantén cada línea en unos
// 3 renglones o menos (~200 caracteres); si es más larga, pártela en dos.
// Estado de cada texto:
//   [BORRADOR]   redacción de borrador
//   [DOCUMENTO]  origen del documento de diseño
//   [PENDIENTE]  falta definirlo
// =====================================================================

function story_text_init() {

    // Introducción del maestro al inicio de cada nivel
    // Se muestra solo una vez por nivel, apenas carga el nivel y antes de que
    // el jugador pueda moverse. Ya no depende del primer ejercicio.
    //  - Nivel 1: introducción completa (controles, interacción, balanza).
    //  - Niveles 2 a 4: breve, solo el tipo de ejercicio que viene.
    global.level_intro = {};

    // Nivel 1  [BORRADOR] salvo el ejemplo resuelto (5 + x = 12), que es [DOCUMENTO] (PDF 2.2)
    global.level_intro[$ "1"] = [
        dlg("Maestro", "¡Despierta, aprendiz! Hoy comienza tu entrenamiento con la Balanza Arcana."),
        dlg("Maestro", "Muévete con las flechas o con WASD. Acércate a un habitante, míralo de frente y pulsa Espacio, Enter o E para hablar."),
        dlg("Maestro", "Cada habitante tiene un problema. Para resolverlo, escribe el valor de x con el teclado y pulsa Enter."),
        dlg("Maestro", "La balanza funciona así: lo que haces de un lado, debes hacerlo del otro. Si no, se desequilibra."),
        dlg("Maestro", "Mira este problema: 5 + x = 12. Para que la balanza vuelva a estar equilibrada, quita 5 de ambos lados."),
        dlg("Maestro", "Lo que queda de un lado es tu respuesta: x = 7."),
        dlg("Maestro", "¡Ahora te toca a ti! Empieza por quien quieras. En el primer problema te daré una pista.")
    ];

    // Nivel 2  [BORRADOR]; el ejemplo 3 + 2x = 11 es [DOCUMENTO] (PDF 2.2)
    global.level_intro[$ "2"] = [
        dlg("Maestro", "Bienvenido al Bosque encantado. Aquí las ecuaciones tendrán un número multiplicando a x, como 3 + 2x = 11."),
        dlg("Maestro", "Primero quita 3 de ambos lados: queda 2x = 8. Luego divide ambos lados entre 2 y obtienes x = 4."),
		dlg("Maestro", "Ten cuidado, parece que hay más criaturas hóstiles aquí..."),
		dlg("Maestro", "Si llegas a toparte con uno de ellos, ¡asegúrate de equilibrar la balanza a tiempo!")
    ];

    // Nivel 3  [BORRADOR]; el ejemplo 5 + 4x = 9 + 3x es [DOCUMENTO] (PDF 2.2)
    global.level_intro[$ "3"] = [
        dlg("Maestro", "Este castillo esconde ecuaciones con x en ambos lados, como 5 + 4x = 9 + 3x."),
        dlg("Maestro", "Junta las x de un mismo lado restando 3x en ambos lados: queda 5 + x = 9. Luego resta 5 y obtienes x = 4.")
    ];

    // Nivel 4  [BORRADOR]; el ejemplo x² - 5x + 6 = 0 es [DOCUMENTO] (docx 1.5.4)
    global.level_intro[$ "4"] = [
        dlg("Maestro", "El Rey del Desequilibrio usa ecuaciones con x" + SYM_SQ + ", como x" + SYM_SQ + " - 5x + 6 = 0. Siempre tienen dos soluciones."),
        dlg("Maestro", "Se pueden factorizar: (x - 2)(x - 3) = 0. Las raíces son x = 2 y x = 3. ¡Debes escribir las dos!")
    ];

    // CIERRE DE NIVEL 1 (lo dice el maestro al completar el nivel)
    global.level_end_text = {};
    global.level_end_text[$ "1"] = [     // [BORRADOR]
        dlg("Maestro", "¡Lo lograste, aprendiz! La aldea vuelve a estar en equilibrio."),
        dlg("Maestro", "El Bosque encantado te espera al otro lado del puente.")
    ];
	
	// CIERRE DE NIVEL 4 (lo dice el maestro al completar el nivel)
	global.level_end_text[$ "4"] = [     // [BORRADOR]
        dlg("Maestro", "¡Lo lograste, aprendiz! El reino de Aequor recupera su equilibrio."),
        dlg("Maestro", "Gracias por jugar La Balanza Arcana.")
    ];
	

    // CONSEJOS Y FRASES DE REPETICIÓN de los NPC del Nivel 1
    // Se agregan al struct que ya creó bank_text_init()
    //   tip          -> el NPC lo dice al terminar su misión
    //   repeat_lines -> lo que dice si el jugador le habla de nuevo
    // Los consejos son los ejemplos del docx 1.5.1 [DOCUMENTO]; el docx
    // aclara que son solo ejemplos y pueden cambiar
    var _herrero = global.src_text[$ "herrero"];
    _herrero.tip = "Para despejar x, pasa lo que sobra al otro lado con la operación inversa. ¡Pero hazlo en ambos lados de la igualdad!";
    _herrero.repeat_lines = [ "Mi forja vuelve a funcionar gracias a ti. ¡Sigue practicando con la balanza!" ];   // [BORRADOR]

    var _molinera = global.src_text[$ "molinera"];
    _molinera.tip = "Recuerda que una ecuación de primer grado tiene una única solución.";
    _molinera.repeat_lines = [ "Con tu ayuda el molino no se detiene. ¡Gracias, jovencito!" ];                       // [BORRADOR]

    var _guardiana = global.src_text[$ "guardiana"];
    _guardiana.repeat_lines = [ "El registro está en orden. Cruza cuando quieras." ];                                  // [BORRADOR]
	
	var _herbolaria = global.src_text[$ "herbolaria"];
	_herbolaria.tip = "Primero aparta lo que ya tenías; después divide lo que falta entre lo que aporta cada grupo.";
	_herbolaria.repeat_lines = ["Ya no estoy perdida. Gracias a ti, mis remedios llegarán a quienes los necesitan."];

	var _apicultor = global.src_text[$ "apicultor"];
	_apicultor.tip = "La cantidad de colmenas se descubre después de quitar los panales que ya estaban en la cesta.";
	_apicultor.repeat_lines = ["Las colmenas están en calma y mis cuentas, en equilibrio."];

	var _cartografa = global.src_text[$ "cartografa"];
	_cartografa.tip = "En el mapa, separa las marcas iniciales de las que aporta cada ruta antes de contar rutas.";
	_cartografa.repeat_lines = ["Ahora el camino hacia el castillo está claro. No pierdas de vista las señales."];
}
