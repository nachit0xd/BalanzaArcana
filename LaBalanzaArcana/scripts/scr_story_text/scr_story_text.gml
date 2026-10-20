// Script con narrativa del Mundo: introducción del maestro al inicio de cada nivel, consejos de los NPC y cierres de nivel.
// Los enunciados y diálogos de cada NPC siguen en scr_bank_text

// Se llama desde obj_game (Create), después de bank_init()

function story_text_init() {

    // Introducción del maestro al inicio de cada nivel

    global.level_intro = {};

    // Nivel 1 - intro
    global.level_intro[$ "1"] = [
        dlg("Maestro", "¡Despierta, mi aprendiz! Hoy comienza tu entrenamiento con la Balanza Arcana."),
        dlg("Maestro", "Muévete con las flechas o con WASD. Acércate a un habitante, míralo de frente y pulsa Espacio, Enter o E para hablar."),
        dlg("Maestro", "Cada habitante tiene un problema. Para resolverlo, escribe el valor de x con el teclado y pulsa Enter."),
        dlg("Maestro", "La balanza funciona así: lo que haces de un lado, debes hacerlo del otro. Si no, se desequilibra."),
        dlg("Maestro", "Mira este problema: 5 + x = 12. Para que la balanza vuelva a estar equilibrada, quita 5 de ambos lados."),
        dlg("Maestro", "Lo que queda de un lado es tu respuesta: x = 7."),
        dlg("Maestro", "¡Ahora te toca a ti! Empieza por quien quieras. En el primer problema te daré una pista.")
    ];

    // Nivel 2 - intro
    global.level_intro[$ "2"] = [
        dlg("Maestro", "Bienvenido al Bosque Encantado. Aquí las ecuaciones tendrán un número multiplicando a x, como 3 + 2x = 11."),
        dlg("Maestro", "Primero quita 3 de ambos lados: queda 2x = 8. Luego divide ambos lados entre 2 y obtienes x = 4."),
		dlg("Maestro", "Ten cuidado, parece que hay más criaturas hóstiles aquí..."),
		dlg("Maestro", "Si llegas a toparte con uno de ellos, ¡asegúrate de equilibrar la balanza a tiempo!")
    ];

    // Nivel 3 - intro
    global.level_intro[$ "3"] = [
        dlg("Maestro", "Has llegado al castillo de El Rey del Desequilibrio, tu objetivo no está muy lejos, muchacho."),
		dlg("Maestro", "Aquí se esconden ecuaciones con x en ambos lados, como 5 + 4x = 9 + 3x."),
        dlg("Maestro", "Junta las x de un mismo lado restando 3x en ambos lados: queda 5 + x = 9. Luego resta 5 y obtienes x = 4."),
		dlg("Maestro", "Asegúrate de derrotar a todos los enemigos que encuentres, puede que te den pistas sobre la batalla contra el Rey.")
    ];

    // Nivel 4 - intro
    global.level_intro[$ "4"] = [
		dlg("Maestro", "Parece que estás entrando en la habitación final...puedo sentir una presencia maligna cerca de ti."),
        dlg("Maestro", "El Rey del Desequilibrio usa ecuaciones con x" + SYM_SQ + ", como x" + SYM_SQ + " - 5x + 6 = 0. Siempre tienen dos soluciones."),
        dlg("Maestro", "Se pueden factorizar: (x - 2)(x - 3) = 0. Las raíces son x = 2 y x = 3. ¡Debes escribir las dos!"),
		dlg("Maestro", "Ve con cuidado, mi aprendiz... ¡es hora de derrotar a ese malvado rey!")
    ];

    // Cierre del Nivel 1
    global.level_end_text = {};
    global.level_end_text[$ "1"] = [ 
        dlg("Maestro", "¡Lo lograste, mi aprendiz! La aldea vuelve a estar en equilibrio."),
        dlg("Maestro", "Parece que el camino a una nueva zona se ha desbloqueado... ¡sigamos equilibrando esos problemas!")
    ];
	
	// Cierre del Nivel 2
    global.level_end_text = {};
    global.level_end_text[$ "2"] = [ 
        dlg("Maestro", "¡Bien hecho! El Bosque Encantado ha encontrado su equilibrio."),
        dlg("Maestro", "Nos acercamos al castillo de El Rey del Desequilibrio... prepárate para más problemas, mi aprendiz.")
    ];
	
	// Cierre del Nivel 3
    global.level_end_text = {};
    global.level_end_text[$ "3"] = [ 
        dlg("Maestro", "¡Excelente! Todos los enemigos han caído..."),
        dlg("Maestro", "El Rey del Desequilibrio no debe estar lejos... ten mucho cuidado.")
    ];
	
	// Cierre del Nivel 4
	global.level_end_text[$ "4"] = [  
        dlg("Maestro", "¡Lo lograste, mi aprendiz! El reino de Arcane recupera su equilibrio."),
		dlg("Maestro", "El mundo entero podrá vivir en armonía y equilibrio, ¡eres todo un héroe!"),
        dlg("Maestro", "Gracias por jugar La Balanza Arcana.")
    ];
	

    // Consejos y frases de repetición de los NPC
    var _herrero = global.src_text[$ "herrero"];
    _herrero.tip = "Para despejar x, pasa lo que sobra al otro lado con la operación inversa. ¡Pero hazlo en ambos lados de la igualdad!";
    _herrero.repeat_lines = [ "Mi forja vuelve a funcionar gracias a ti. ¡Sigue practicando con la balanza!" ];

    var _molinera = global.src_text[$ "molinera"];
    _molinera.tip = "Recuerda que una ecuación de primer grado tiene una única solución.";
    _molinera.repeat_lines = [ "Con tu ayuda el molino no se detiene. ¡Gracias, jovencito!" ];                

    var _guardiana = global.src_text[$ "guardiana"];
    _guardiana.repeat_lines = [ "El registro está en orden. Cruza cuando quieras." ];                          
	
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
