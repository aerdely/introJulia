module Analizar

using InteractiveUtils # para acceder a `subtypes` en `stipo`
include("varios.jl")

export que, tipejo, adios

saludo() = "Hola perro"
adios() = "Adiós perro maldito"
tipejo(x) = stipo(x)

end # module
