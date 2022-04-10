### Introducción al lenguaje de programación Julia
### Por Arturo Erdely basado en https://docs.julialang.org/en/v1/

# Asignar valor numérico
a = 5 

# Mostrar valor asignado mediante
println(a)

# Agregar descripción de texto
println("a = ", a)

# Modificar valor asignado
a = 2.3
println("a = ", a)

# println versus print
println(1, 2) 
println(3, 4)
print(1, 2)
print(3, 4)
println()
println(1, " ", 2)
println(1, "\t", 2)
println(1, "\n", 2)

# Uso de caracteres especiales
# Por ejemplo: δ se obtiene mediante \delta y tecla TAB
δ = 0.001
println("δ = ", δ)

# Uso de colores y estilos

printstyled("Rojo", bold = true, color = :red)

printstyled("Azul", underline = true, color = :blue)

printstyled("Fondo amarillo", color = :yellow, reverse = true)

for i ∈ 1:255
    printstyled(i, bold = true, color = i)
end

# Para buscar ayuda de sintaxis, directo en la terminal escribe:
# ?println 

# Palabras reservadas para el lenguaje de programación Julia:
#
# baremodule, begin, break, catch, const, continue, do, else, 
# elseif, end, export, false, finally, for, function, global, 
# if, import, let, local, macro, module, quote, return, struct,
# true, try, using, while
#
# Así como los siguientes pares de palabras:
#
# abstract type, mutable struct, primitive type