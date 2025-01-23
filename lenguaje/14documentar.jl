### Documentar objetos
### Por Arturo Erdely basado en https://docs.julialang.org/en/v1/

#=
Una vez definido cada objeto documentado busca ayuda
sobre ellos en la terminal de Julia entrando al modo ayuda:

julia> ?
help?> función_ociosa

o bien directamente mediante:

julia> @doc función_ociosa

o bien:

julia> Docs.doc(función_ociosa)

=#

"""
    función_ociosa(x, nombre::String)

Aplica la función `^` al *par* ordenado `(x, 2)` siempre y cuando exista un **método**
definido para el tipo de objeto que sea `x`, y entrega el resultado de
```math
x ^ 2
```
acompañado de un saludo personalizado.

# Ejemplos
```julia
a = función_ociosa(3, "Arturo");
a
b = función_ociosa("Arturo", "perro");
b
c = función_ociosa([1 2; 3 4], "Sandy");
c
```
"""
function función_ociosa(x, nombre::String)
    println("Hola $nombre")
    r = x ^ 2
    println("$x ^ 2 = $r")
    return r
end

@doc función_ociosa

Docs.doc(función_ociosa)

función_ociosa(3, "Arturo")


# También es posible documentar otro tipo de objetos (arreglos, tipos, módulos)

"""
`M` es una matriz aleatoria de 2 x 3
"""
M = rand(2, 3)

@doc M 


# Averiguar si un objeto está documentado en un determinado módulo:

N = rand(2, 3)
Docs.hasdoc(Main, :M)
Docs.hasdoc(Main, :N)

Docs.undocumented_names(Main)
Docs.undocumented_names(Main; private = true)

