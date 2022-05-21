### Tipos
### Por Arturo Erdely basado en https://docs.julialang.org/en/v1/

## Declaración de tipo (solo en entornos locales)
## typeof  a::b  typeassert

entero = 3
println(typeof(entero))
println(entero::Int)
println(typeassert(entero, Int))
println(entero::Int32) # TypeError
println(typeassert(entero, Int32)) # TypeError

x::Int8 = 100 # ERROR

function f()
    x::Int8 = 100
    return x
end
z = f()
println(z, "\t", typeof(z))

# Incertidumbre sobre el tipo que arrojará la función
# Esto disminuye eficiencia de la compilación
function senolim(θ)
    if θ == 0
        return 1
    else
        return sin(θ)/θ
    end
end
z = senolim(-0.0)
println(z, "\t", typeof(z))
z = senolim(π/2)
println(z, "\t", typeof(z))

# Se elimina la incertidumbre sobre el tipo que arrojará
function senolimtipo(θ)::Float64
    if θ == 0
        return 1
    else
        return sin(θ)/θ
    end
end
z = senolimtipo(-0.0)
println(z, "\t", typeof(z))
z = senolimtipo(π/2)
println(z, "\t", typeof(z))

# La suma de enteros es más veloz que en punto flotante
function suma₁(n)
    i₀ = Σ = 0
    for i ∈ i₀:n
        Σ += i # typeof(Σ) = Int64
    end
    Σ
end

function suma₂(n)
    i₀ = Σ = 0.0
    for i ∈ i₀:n
        Σ += i # typeof(Σ) = Float64
    end
    Σ
end

println(suma₁(100), "\t", typeof(suma₁(100)))
println(suma₂(100), "\t", typeof(suma₂(100)))

@time suma₁(1_000_000)
@time suma₂(1_000_000)

# Pkg.add("BenchmarkTools")
using BenchmarkTools

@btime suma₁(100)
@btime suma₂(100)


## Tipos abstractos --> ver: https://github.com/aerdely/introJulia/blob/main/lenguaje/complementos/ArbolTipos.png
## supertype   subtypes

println(Real <: Number)
println(AbstractFloat <: Real)
println(Integer <: Real)
println(Integer <: Number)
println(Integer <: AbstractFloat)

println(supertype(Real))
println(subtypes(Number))

abstract type otronum <: Number end
println(subtypes(Number))
println(supertype(otronum))

todossubtipos = subtypes(Any)
println(todossubtipos)
println(typeof(todossubtipos))
println(Number ∈ todossubtipos)
println(otronum ∈ todossubtipos)

abstract type otro end
println(supertype(otro))
println(subtypes(otro))
todossubtipos = subtypes(Any)
println(otro ∈ todossubtipos)


## Tipos compuestos (inmutables)
## struct  fieldnames

struct Paciente
    nombre::String
    sexo::Char
    fumador::Bool
    edad::Int8
    peso::Float16
    estatura::Float16
    observaciones # cualquier tipo, es decir observaciones::Any
end
println(Paciente, "\t", typeof(Paciente))
println(supertype(Paciente))
println(subtypes(Paciente))

ficha = Paciente("Pedro", 'M', true, 47, 85.5, 1.72, 666)
println(fieldnames(Paciente), "\t", typeof(fieldnames(Paciente)))
println(ficha, "\n", typeof(ficha))
println(ficha.peso)
display(ficha)
ficha.peso = Float16(91.3) # ERROR porque `struct` genera objetos inmutables

struct Nada
end
println(Nada, "\t", typeof(Nada))
nadita = Nada()
println(nadita, "\t", typeof(nadita))


## Tipos compuestos mutables

mutable struct Paciente2
    nombre::String
    sexo::Char
    fumador::Bool
    edad::Int8
    peso::Float16
    estatura::Float16
    observaciones # cualquier tipo, es decir osbervaciones::Any
end
println(Paciente2, "\t", typeof(Paciente2))

ficha2 = Paciente2("Pedro", 'M', true, 47, 85.5, 1.72, "perro maldito")
println(fieldnames(Paciente2), "\t", typeof(fieldnames(Paciente2)))
println(ficha2, "\n", typeof(ficha2))
println(ficha2.peso)
ficha2.peso = 91.3 # mutable struct sí es modificable (mutable)
println(ficha2, "\n", typeof(ficha))


## Unión de Tipos (caso especial de tipo abstracto) 

EnteroTexto = Union{Int, AbstractString}
println(EnteroTexto, "\t", typeof(EnteroTexto))
x = 3::EnteroTexto
println(x, "\t", typeof(x))
y = "perro"::EnteroTexto
println(y, "\t", typeof(y))
z = 3.4::EnteroTexto # TypeError

AlgoNada = Union{Float64, Nothing}
println(AlgoNada, "\t", typeof(AlgoNada))
x = 3.4::AlgoNada
println(x, "\t", typeof(x))
y = nothing::AlgoNada
println(y, "\t", typeof(y)) 
z = "perro"::AlgoNada # TypeError


## Tipos paramétricos

# Tipos paramétricos compuestos

struct Punto{T}
    x::T
    y::T
end
println(Punto, "\t", typeof(Punto))
println(fieldnames(Punto))

println(Punto{Float64}, "\t", typeof(Punto{Float64}))
println(Punto{AbstractString}, "\t", typeof(Punto{AbstractString}))

function norma(p::Punto{Float64})
    √(p.x^2 + p.y^2)
end
p = Punto{Float64}(3, 4)
display(p)
η = norma(p)
println(η, "\t", typeof(η))
q = Punto{Int64}(3, 4)
display(q)
η = norma(q) # ERROR

function frase(p::Punto{String})
    p.x * " " * p.y
end
p = Punto{String}("perro", "maldito")
display(p)
ω = frase(p)
println(ω, "\t", typeof(ω))

println(Punto(2, 3))
println(Punto('α', 'ω'))
println(Punto(2, 3.0)) # ERROR

println(Punto{Float64} <: Punto)
println(Punto{AbstractString} <: Punto)
println(Float64 <: Punto)
println(AbstractString <: Punto)

println(Float64 <: AbstractFloat)
println(Punto{Float64} <: Punto{AbstractFloat})
println(Punto{Float64} <: Punto{<:AbstractFloat})

# Tipos de tuplas

println(typeof((1, "perro", 2.5, π)))
τ = (a = 1, b = "hello")
println(τ, "\t", typeof(τ))
println(τ.a, "\t", τ.b)

# Vararg Tuple Types

mytupletype = Tuple{AbstractString,Vararg{Int}}
println(mytupletype, "\t", typeof(mytupletype))
isa(("1",), mytupletype)
isa(("1", 1), mytupletype)
isa(("1", 1, 2), mytupletype)
isa(("1", 1, 2, 3.0), mytupletype)
isa(("A", (1, 2)), mytupletype)

# Named Tuple Types

τ = (a = 1, b = "hello")
println(τ, "\t", typeof(τ))
println(τ.a, "\t", τ.b)

Mitupla = Tuple{Integer, AbstractFloat, Char, String}
println(Mitupla, "\t", typeof(Mitupla))
tupla = Mitupla((3, 1.6, '@', "perro"))
println(tupla, "\t", typeof(tupla))

Mitupla2 = NamedTuple{(:edad, :peso, :símbolo, :mensaje), Mitupla}
println(Mitupla2, "\t", typeof(Mitupla2))
tupla2 = Mitupla2((19, 58.3, 'a', "amorcita"))
println(tupla2, "\t", typeof(tupla2))
println(tupla2.mensaje, "\t", tupla2.símbolo)

v1 = Vector{Union{Missing, String}}(missing, 3)
println(v1, "\t", typeof(v1))
v1[2] = "perro"
println(v1, "\t", typeof(v1))

v2 = Vector{Union{Nothing, Float64}}(nothing, 3)
println(v2, "\t", typeof(v2))
v2[2] = 3.6
println(v2, "\t", typeof(v2))


## Operaciones sobre Tipos
# isa  supertype  supertypes  subtypes

println(typeof(2))
println(isa(2, Int8), "\t", isa(2, Int64), "\t", isa(2, Int))
println(isa(2, Real), "\t", isa(2, Float64), "\t", isa(2, AbstractFloat))

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

t(Complex)
t(ComplexF64)
t(Complex{Float64})

t(Real)
t(Integer)
t(BigInt)
t(Rational)
t(Rational{Int64})
t(AbstractFloat)
t(AbstractIrrational)
t(Irrational{Float64})
t(Irrational{BigFloat})

t(Integer)
t(Bool)
t(Signed)
t(Unsigned)
t(UInt8)

t(Rational{Int64})
t(Rational{Int8})
t(Rational{UInt8})

t(AbstractString)
t(String)
t(SubString{String})

t(AbstractChar)
t(Char)

t(Any) # Larga lista de subtipos

supertype(Int)
supertypes(Int)


## Ejemplo

abstract type Figura end

struct Trapecio <: Figura
    altura::Float64 
    base1::Float64
    base2::Float64
end

struct Círculo <: Figura
    radio::Float64
end

typeof(Figura), typeof(Trapecio), typeof(Círculo)
subtypes(Figura)
supertype(Trapecio)
supertype(Círculo)

t = Trapecio(2.3, 5.0, 4.2)
typeof(t)
t.base2

c = Círculo(2.4)
typeof(c)
c.radio

Círculo(2) # conversión automática de entero 2 a flotante 2.0

Círculo(2 + 3im) # error porque no puede convertir complejo a flotante

# ==> Este ejemplo continuará al final de 09metodos.jl
