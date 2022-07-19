### Constructores
### Por Arturo Erdely basado en https://docs.julialang.org/en/v1/

struct Mascota
    perro
    gato
    otra
end
println(typeof(Mascota))
println(methods(Mascota))

mi = Mascota("Fido", "Moyi", 0)
println(mi, "\t", typeof(mi))
println(mi.perro)

tu = Mascota(0, "Humberto", '∅')
println(tu, "\t", typeof(tu))
println(tu.otra)

ella = Mascota("Cuca") # ERROR


## Métodos de construcción exterior

Mascota(x) = Mascota(x, x, x)
println(typeof(Mascota))
println(methods(Mascota))
println(Mascota("Willy"))
println(Mascota("Nerón", "Misifús", 0))
println(Mascota("Nerón", "Misifús")) # ERROR

Mascota() = Mascota("Diablo")
println(typeof(Mascota))
println(methods(Mascota))
println(Mascota())

println(Mascota("Nerón", "Misifús", 0))
println(Mascota("Willy"))
println(Mascota())


## Métodos de construcción interior

struct ParOrdenado
    x::Integer
    y::Integer
    ParOrdenado(x, y) = x > y ? error("inaceptable") : new(x, y)
end

println(ParOrdenado)
println(typeof(ParOrdenado))
println(methods(ParOrdenado))

println(ParOrdenado(2, 3))
println(ParOrdenado(2, Int8(3)))
println(ParOrdenado(2, 3.0))
println(ParOrdenado(2, 3.1)) # ERROR (mensaje de Julia)
println(ParOrdenado(20, 3)) # ERROR (mensaje definido por el usuario)


## Constructores paramétricos

struct Punto{T <: Real}
    x::T
    y::T
end

println(typeof(Punto))
println(methods(Punto))

println(Punto(1, 2)) # tipo implícito
println(Punto(1.0, 2.0)) # tipo implícito
println(Punto(1//2, 2//3)) # tipo implícito
println(Punto(1, 2.0)) # ERROR
println(Punto{Int8}(1, 2)) # tipo explícito
println(Punto{Int64}(1.3, 2.1)) # ERROR
println(Punto{Float64}(1, 2)) # tipo explícito
println(Punto{Float64}(1//2, 2//3)) # tipo explícito
println(Punto('a', 'b')) # ERROR

println(methods(Punto))
Punto(x::Int64, y::Float64) = Punto(convert(Float64, x), y)
println(methods(Punto))
println(Punto(1, 2.0)) # ya no da error


## Ejemplo: Figuras geométricas

abstract type Figura end

struct Círculo <: Figura
    radio::Float64
    function Círculo(radio)
        if radio ≤ 0.0
            error("radio debe ser positivo")
        else
            return new(radio)
        end
    end
end

Círculo(3.2)
Círculo(-2.3) # ERROR (mensaje definido por el usuario)

struct Trapecio <: Figura
    altura::Float64
    base1::Float64
    base2::Float64
    function Trapecio(altura, base1, base2)
        if min(altura, base1, base2) > 0.0
            return new(altura, base1, base2)
        else
            error("valores deben ser positivos")
        end
    end
end

Trapecio(3, 2.1, 4) # con conversión automática de enteros a flotantes
Trapecio(1, 2, -3) # ERROR (mensaje definido por el usuario)

Trapecio(a, b) = Trapecio(a, b, b) # en realidad, un rectángulo
Trapecio(a) = Trapecio(a, a) # en realidad, un cuadrado
methods(Trapecio)

Trapecio(1, 2)
Trapecio(1)
Trapecio(1).base2

struct Rectángulo <: Figura
    altura::Float64
    base::Float64
    function Rectángulo(altura, base) 
        if min(altura, base) > 0.0
            return new(altura, base)
        else
            error("valores deben ser positivos")
        end
    end
end

struct Cuadrado <: Figura
    lado::Float64
    function Cuadrado(lado)
        if lado ≤ 0.0
            error("valor debe ser positivo")
        else
            return new(lado)
        end
    end
end

subtypes(Figura)

begin
    área(fig::Trapecio) = (fig.base1 + fig.base2) * fig.altura / 2
    área(fig::Rectángulo) = área(Trapecio(fig.altura, fig.base))
    área(fig::Cuadrado) = área(Trapecio(fig.lado))
    área(fig::Círculo) = π * fig.radio^2
    methods(área)
end


function información(fig::Figura)
    println("Tipo de figura: ", typeof(fig))
    println("Área = ", área(fig))
    return nothing
end

información(Trapecio(3, 4, 5))
información(Rectángulo(2, 3))
información(Cuadrado(6))
información(Círculo(2))

methods(información)
methodswith(Figura)


## Ejemplo: Sucesión de Fibonacci
## Autor: https://twitter.com/eliascarvdev/status/1531780420186030082?s=20&t=9R2JUs-Gnv57p2lW9OvBWw

struct FibSeq
    cache::Dict{Int, Int}
    function FibSeq()
        cache = Dict(0 => 1, 1 => 1)
        new(cache)
    end
end

function (fib::FibSeq)(n::Int)
    n ∈ keys(fib.cache) && return fib.cache[n]
    fib.cache[n] = fib(n-1) + fib(n-2)
    return fib.cache[n]
end

fib = FibSeq()

fib(50)

# pero no es tan rápido como:
function fibonacci(n)
    ant = 0; sig = 1; fibo = sig
    for i ∈ 1:n
        fibo = ant + sig
        ant, sig = sig, fibo
    end
    return fibo 
end

using BenchmarkTools

@btime fibonacci(50)

@btime fib(50)

@btime fib(50)

