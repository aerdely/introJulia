### Módulos
### Por Arturo Erdely basado en https://docs.julialang.org/en/v1/

include("./Analizar.jl")

display(que) # ERROR
display(Analizar.que)
Analizar.que(3.4)
# incluso disponible en
# help?> Analizar.que

println(typeof(Analizar))
println(supertype(typeof(Analizar)))
println(subtypes(typeof(Analizar)))

using .Analizar # importante colocar el punto antes si no es un paquete instalado

display(que) # Ahora no hay error porque Analizar lo exporta
que(3.4)
println(adios()) # también fue exportado
println(saludo()) # pero saludo() NO fue exportado
# Así que
println(Analizar.saludo())


## Example.jl

## `using Paquete` versus `import Paquete`

# Con `using` puedes utilizar las funciones que exporta el paquete
# por su nombre, digamos `nombrefunc` pero no puedes agregarles métodos nuevos

# Con `import` sí puedes agregar nuevos métodos a sus funciones
# pero debes llamarlas mediante `Paquete.nombrefunc`
