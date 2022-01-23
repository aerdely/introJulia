### Documentar funciones
### Por Arturo Erdely basado en https://docs.julialang.org/en/v1/

# Ejemplos: ejecuta todo el código y luego busca ayuda
# sobre estas funciones en la terminal mediante ?que y ?stipo 

"""
    que(x)

Muestra objeto `x` junto con su tipo y tamaño.

# Ejemplo
```
julia> que('w')
w       Char    4 bytes
```
"""
function que(x) # qué es esto
    println()
    println(x, "\t", typeof(x), "\t", sizeof(x), " bytes")
end

"""

    stipo(T::DataType)

Muestra tipo `T` seguido de su *supertipo* y **subtipos**

## Ejemplo 
```
julia> stipo(Real)
Tipo:           Real
supertipo:      Number
subtipos:       Any[AbstractFloat, AbstractIrrational, Integer, Rational]
```
"""
function stipo(T::DataType)
    println("\nTipo:\t\t", T)
    println("supertipo:\t", supertype(T))
    println("subtipos:\t", subtypes(T))
    return nothing
end
