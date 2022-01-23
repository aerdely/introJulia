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

println(ParOrdenado(2, 3))
println(ParOrdenado(2, Int8(3)))
println(ParOrdenado(2, 3.0))
println(ParOrdenado(2, 3.1)) # ERROR
println(ParOrdenado(20, 3))


## Constructores paramétricos

struct Punto{T <: Real}
    x::T
    y::T
end

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
