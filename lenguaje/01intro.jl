### Introducción al lenguaje de programación Julia
### Por Arturo Erdely basado en https://docs.julialang.org/en/v1/

### Versión: 1.10.0

# Asignar valor numérico
a = 5 

# Mostrar valor asignado mediante
println(a)

# También
display(a) # después se verá la diferencia respecto a `println`

# Agregar descripción de texto
println("a = ", a)

# Otra forma de mostrarlo

@show a

@show a + 1

@show a+1 a/2

z = @show a
println(z)

# Modificar valor asignado
a = 2.3
println("a = ", a)

# verificar si un objeto ya fue definido

@isdefined a 

@isdefined w 

# println versus print
println(1, 2) 
println(3, 4)
print(1, 2)
print(3, 4)
println()
println(1, " ", 2)
println(1, "\t", 2)
println(1, "\n", 2)

# Silenciar resultado de asignación
c = 99 # se asigna y muestra en la línea de comandos
d = 101; # se asigna pero no se muestra en la línea de comandos
println("d = ", d)

# Asignación anidada
a = (b = 1 + 2) + 100
println("a = ", a)
println("b = ", b)

# Lista de objetos definidos hasta el momento

varinfo()

# Uso de caracteres especiales
# Por ejemplo: δ se obtiene mediante \delta y tecla TAB
δ = 0.001
println("δ = ", δ)

# Uso de colores y estilos

printstyled("Rojo", bold = true, color = :red)
printstyled("Verde", italic = true, color = :green)
printstyled("Amarillo", bold = true, italic = true, color = :yellow)
printstyled("Azul", underline = true, color = :blue)
printstyled("Fondo amarillo", color = :yellow, reverse = true)


for i ∈ 1:255
    printstyled(i, bold = true, color = i)
end


#=
Para buscar ayuda de sintaxis, directo en la terminal escribe
primero el símbolo ? y ya activado el modo help?> escribe
Para buscar ayuda de sintaxis, directo en la terminal escribe
primero el símbolo ? y ya activado el modo help?> escribe
el nombre de la instrucción seguido de la tecla intro. 
Si no recuerdas el nombre completo de la instrucción escribe
la parte que recuerdes y luego presiona la tecla de tabulación:
en caso de que exista una sola instrucción con esas letras
se autocopletará, si nada sucedió entonces nuevamente
presiona la recla de tabulación y aparecerá una lista de todas las opciones.
Por ejemplo primero intenta: ?fals
y luego intenta con: ?sum 
=#

#=
Palabras reservadas para el lenguaje de programación Julia:
baremodule, begin, break, catch, const, continue, do, else, 
elseif, end, export, false, finally, for, function, global, 
if, import, let, local, macro, module, quote, return, struct,
true, try, using, while
Así como los siguientes pares de palabras:
abstract type, mutable struct, primitive type
=#
