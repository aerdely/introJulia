"""
    que(x)

Muestra objeto `x` junto con su tipo y tamaño.

# Ejemplo
```julia-repl
julia> que('w')
w       Char    4 bytes
```
"""
function que(x) # qué es esto
    println("objeto:\t", x) # "\t", typeof(x), "\t", sizeof(x), " bytes")
    println("tipo:\t", typeof(x))
    println("tamaño:\t", sizeof(x), " bytes")
    return nothing
end

"""

    stipo(T::DataType)

Muestra tipo `T` seguido de su *supertipo* y *subtipos*

```julia-repl
julia> stipo(Real)
Tipo:           Real
supertipo:      Number
subtipos:       Any[AbstractFloat, AbstractIrrational, Integer, Rational]
```
"""
function stipo(T::DataType)
    println("tipo:\t\t", T)
    println("supertipo:\t", supertype(T))
    println("subtipos:\t", subtypes(T))
    return nothing
end
;