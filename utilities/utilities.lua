-- Script creado como librería para funciones generales

--- Chequea las coliciones con el sistema AABB
function check_collision(a, b)

    return -- devuelve true si un objeto está "dentro" de otro
        a.x < b.x + b.width and
        a.x + a.width > b.x and
        a.y < b.y + b.height and
        a.y + a.height > b.y

end