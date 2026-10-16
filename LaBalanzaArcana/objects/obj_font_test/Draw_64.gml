draw_set_color(c_white);

draw_set_font(fnt_ui);
draw_text(32, 32, "Prueba: áéíóú ñ Ñ ¿Cuánto vale x? ¡Correcto!");

draw_set_font(fnt_math);
draw_text(32, 96,  "x² - 5x + 6 = 0");
draw_text(32, 160, "x₁ = 2     x₂ = 3");
draw_text(32, 224, "5 + 4x = 9 + 3x  →  x = 4");

// Prueba con códigos de caracter (descarta problemas de codificación del archivo)
draw_text(32, 288, "chr(): x" + chr(178) + "   x" + chr(8321) + "   x" + chr(8322));