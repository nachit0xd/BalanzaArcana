// Función que centra la cámara en un objetivo, sin salirse de los bordes del room
function camera_follow(_target) {
    if (!instance_exists(_target)) exit;
    var _x = clamp(_target.x - BASE_W / 2, 0, max(0, room_width  - BASE_W));
    var _y = clamp(_target.y - BASE_H / 2, 0, max(0, room_height - BASE_H));
    camera_set_view_pos(global.cam, floor(_x), floor(_y));     // floor() evita posiciones con decimales, que hacen "temblar" el pixel art
}