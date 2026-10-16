if (exercise_active()) exit;
if (keyboard_check_pressed(ord("V"))) room_goto(rm_village);   // ir a la aldea

if (keyboard_check_pressed(ord("1"))) start_test("herrero", "npc");               // Nivel 1, sin tiempo
if (keyboard_check_pressed(ord("2"))) start_test("golem", "battle");              // Nivel 2, 30 s
if (keyboard_check_pressed(ord("3"))) start_test("guerrero", "battle");           // Nivel 3, 40 s
if (keyboard_check_pressed(ord("4"))) start_test("rey_desequilibrio", "battle");  // Nivel 4, 2 campos, 80 s
if (keyboard_check_pressed(ord("R"))) { decks_reset(); last_result = undefined; } // reinicia las barajas