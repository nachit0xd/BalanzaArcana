if (is_undefined(ex) || closing) exit;

state_t++;

switch (state) {

    case EX_STATE.ASK1:
    case EX_STATE.ASK2:
        // delta_time en microsegundos; se limita a 0.1 s por frame para que un
        // Tirón del equipo no cause un tiempo agotado injusto
        // Si la ventana no tiene el foco, el cronómetro se detiene (no se pierde tiempo sin querer)
        if (window_has_focus()) t_elapsed += min(delta_time, 100000) / 1000000;

        // Cuenta atrás: un tic por segundo en los últimos 5 s (solo batalla)
        if (time_limit > 0) {
            var _ls = ceil(time_limit - t_elapsed);
            if (_ls <= 5 && _ls > 0 && _ls != last_tick) { last_tick = _ls; sfx("snd_tick"); }
        }

        // H: pedir la pista (recordatorio) del primer intento; queda registrada en el archivo de datos
        if (state == EX_STATE.ASK1 && !manual_hint && keyboard_check_pressed(ord("H"))) {
            manual_hint = true;
            sfx("snd_hint");
            log_event("pista_manual", ex.id);
        }

        // Si se envió una respuesta, se evalúa antes que el tiempo agotado
        if (box.submitted) {
            resolve_answer();
        } else if (time_limit > 0 && t_elapsed >= time_limit) {
            resolve_timeout();
        }
        break;

    case EX_STATE.WRONG1:
        if (state_t > EX_FEEDBACK_LOCK && continue_pressed()) set_state(EX_STATE.ASK2);
        break;

    case EX_STATE.KCR:
    case EX_STATE.OK:
        if (state_t > EX_FEEDBACK_LOCK && continue_pressed()) finish();
        break;
}
