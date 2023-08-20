module MiModulo

export que, tipejo, adios

using InteractiveUtils # para acceder a `subtypes` en `stipo`
include("MisFunciones.jl")

saludo() = "Hola perro"
adios() = "Adiós perro maldito"
tipejo(x) = stipo(x)

end # module
