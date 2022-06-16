### Módulos
### Por Arturo Erdely basado en https://docs.julialang.org/en/v1/

include("complementos\\Analizar.jl")

display(que) # ERROR
display(Analizar.que)
Analizar.que(3.4)
# incluso disponible en
# help?> Analizar.que

typeof(Analizar)

using .Analizar # importante colocar el punto antes si no es un paquete instalado
# equivalente a: `using Main.Analizar`

display(que) # Ahora no hay error porque Analizar lo exporta
que(3.4)
println(adios()) # también fue exportado
println(saludo()) # ERROR porque saludo() NO fue exportado
# Así que:
println(Analizar.saludo())
tipejo(Number)


## `using Paquete` versus `import Paquete`

# Con `using` puedes utilizar las funciones que exporta el paquete
# por su nombre, digamos `nombrefunc` pero no puedes agregarles métodos nuevos

# Con `import` sí puedes agregar nuevos métodos a sus funciones
# pero debes llamarlas mediante `Paquete.nombrefunc`


parentmodule(que)
parentmodule(tipejo)
parentmodule(rand)

parentmodule(randexp)
using Random
parentmodule(randexp)

