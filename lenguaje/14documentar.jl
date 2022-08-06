### Documentar objetos
### Por Arturo Erdely basado en https://docs.julialang.org/en/v1/

# Ejemplos: una vez definido cada objeto documentado busca ayuda
# sobre ellos en la terminal de Julia entrando al modo ayuda:

# julia> ?
# help?> función_ociosa

# o bien directamente mediante:

# julia> @doc función_ociosa

"""
    función_ociosa(x, nombre::String)

Aplica la función `^` al par ordenado `(x, 2)` siempre y cuando exista un método
definido para el tipo de objeto que sea `x`, y entrega el resultado de
```math
x ^ 2
```
acompañado de un saludo personalizado.

## Ejemplos
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

# También es posible documentar otro tipo de objetos

"""
`M` es una matriz aleatoria de 2 x 3
"""
M = rand(2, 3)
