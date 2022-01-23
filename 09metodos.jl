### Métodos
### Por Arturo Erdely basado en https://docs.julialang.org/en/v1/

## 19.1 Definiendo Métodos
## methods

f(x::Float64, y::Float64) = 2x + y
println(f, "\t", typeof(f))
println(f(2.0, 3.0))
println(f(2.0, 3)) # ERROR

function t(tipo)
    if isa(tipo, DataType)
        println("\nTipo:\t\t", tipo)
        println("supertipo:\t", supertype(tipo))
        println("subtipos:\t", subtypes(tipo))
    else
        println("\n$tipo no es un DataType válido")
    end
    return nothing
end
t(Number)
t(Real)
f(x::Number, y::Number) = 2x - y
println(methods(f)) # Los métodos se presentan en orden, del más específico al más general
println(f(2.0, 3.0)) # Método 1
println(f(2.0, 3)) # Método 2
println(f(2.0, 'a')) # TypeError
println(f(2.0, 3), "\t", f(2, 3), "\t", f(true, true))
println(typeof.((f(2.0, 3), f(2, 3), f(true, true))))

println(methods(+))

g(x::Integer, y::Integer) = x + y + 10
g(x::AbstractFloat, y::AbstractFloat) = 2x - y
g(x::Real, y::Real) = x*y
g(x::String, y::String) = x * " " * y
g(x, y) = "¡No sé qué hacer en este caso!"
println(methods(g), "\n")
println("g(2, 3) = ", g(2, 3))
println("g(2.0, 3.0) = ", g(2.0, 3.0))
println("g(2, 3.0) = ", g(2, 3.0))
println("""g("Hola", "perros") = """, g("Hola", "perros"))
println("g(true, 'Ψ') = ", g(true, 'Ψ'))
println()


## Ambigüedades de Métodos

g(x::Float64, y) = 2x + y
println(methods(g))
println(g(2.0, 3)) # ERROR
println(g(2, 3))

f(x::Float64, y::Float64) = 2x + 2y
println(methods(f))
println(f(2.0, 3.0))
println(f(2.0, 3))
println(f(2, 3.0))
println(f(2, 3))


## Métodos paramétricos

mismo_tipo(x::T, y::T) where {T} = true
println(methods(mismo_tipo))
mismo_tipo(x, y) = false
println(methods(mismo_tipo))
println(mismo_tipo(2, 3))
println(mismo_tipo(2, 3.0))
println(mismo_tipo(2, '3'))
println(mismo_tipo(2, Int32(2)))

mismo_tipo_num(x::T, y::T) where {T<:Number} = true
println(methods(mismo_tipo_num))
mismo_tipo_num(x::Number, y::Number) = false
println(methods(mismo_tipo_num))
println(mismo_tipo_num(2, 3))
println(mismo_tipo_num(2, 3.0))
println(mismo_tipo_num(2, Int32(2)))
println(mismo_tipo_num(2, '2')) # ERROR


# Nota sobre argumentos opcionales y nombrados

h(a = 1, b = 2) = a + 2b
println(methods(h))
println(h())
println(h(5))
println(h(5, 6))

h(a::Int, b::Int) = a - 2b
println(methods(h))
println(h(5, 6.0))
println(h(5, 6))
println(h())
println(h(5))
println(h(5.0))
