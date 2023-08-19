### Tipos
### Por Arturo Erdely basado en https://docs.julialang.org/en/v1/

## Declaración de tipo
## typeof  a::b  typeassert

entero = 3
println(typeof(entero))
println(entero::Int)
println(typeassert(entero, Int))
println(entero::Int32) # TypeError
println(typeassert(entero, Int32)) # TypeError

x::Int8 = 100 
typeof(x)

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
##  <:  supertype   subtypes

println(Real <: Number)
println(AbstractFloat <: Real)
println(Integer <: Real)
println(Integer <: Number)
println(Integer <: AbstractFloat)

println(supertype(Real))
println(subtypes(Number))

println(supertype(Signed))
println(supertypes(Signed))
println(subtypes(Signed))

println(subtypes(Number))
abstract type otronum <: Number end
println(typeof(otronum))
println(subtypes(Number))
println(supertype(otronum))
println(supertypes(otronum))
println(subtypes(otronum))

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


## Tipos compuestos inmutables
## struct  fieldnames  propertynames  getproperty 

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
println(propertynames(Paciente)) # información interna del objeto 
println(ficha, "\n", typeof(ficha))
fieldnames(ficha) # ERROR
propertynames(ficha) # igual que `fieldnames(typeof(ficha))`
println(ficha.peso)
getproperty(ficha, :peso) # igual que `ficha.peso`
display(ficha)
ficha.peso = Float16(91.3) # ERROR porque `struct` genera objetos inmutables

# Pero los elementos de un objeto inmutable pudieran ser mutables
struct cosita
    v::Vector
    x::Char
end
ejemplo = cosita([1, 2.3, "Hola"], '@')
ejemplo.v[2] = 4//9
println(ejemplo)

struct Nada
end
println(Nada, "\t", typeof(Nada))
nadita = Nada()
println(nadita, "\t", typeof(nadita))


## Tipos compuestos mutables
## setproperty!

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
getproperty(ficha2, :peso) # igual que `ficha2.peso`
setproperty!(ficha2, :peso, 99.9) # igual que `ficha2.peso = 99.9`
getproperty(ficha2, :peso)
println(ficha2.peso)

## Tipos compuestos parcialmente mutables

mutable struct Parcial
    a::Int64 # mutable 
    const b::Float64 # inmutable por haber sido declarado como constante
end
p = Parcial(5, 2.3)
p.a = 99
println(p)
p.b = 9.9 # ERROR 


## Unión de Tipos (caso especial de tipo abstracto) 

EnteroTexto = Union{Int, AbstractString}
println(EnteroTexto, "\t", typeof(EnteroTexto))
m = 333::EnteroTexto
println(m, "\t", typeof(m))
y = "perro"::EnteroTexto
println(y, "\t", typeof(y))
z = 3.4::EnteroTexto # TypeError

AlgoNada = Union{Float64, Nothing}
println(AlgoNada, "\t", typeof(AlgoNada))
w = 3.4::AlgoNada
println(w, "\t", typeof(w))
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


# Tipos paramétricos abstractos

abstract type Punteado{T} end
println(Punteado, "\t", typeof(Punteado))
println(Punteado{Float64}, "\t", typeof(Punteado{Float64}))


# Tipos de tuplas

println(typeof((1, "perro", 2.5, π)))
τ = (a = 1, b = "hello")
println(τ, "\t", typeof(τ))
println(τ.a, "\t", τ.b)


# Tipos de tuplas con número variable de argumentos

mytupletype = Tuple{AbstractString,Vararg{Int}}
println(mytupletype, "\t", typeof(mytupletype))
isa(("1",), mytupletype)
isa(("1"), mytupletype)
isa(("1", 1), mytupletype)
isa(("1", 1, 2), mytupletype)
isa(("1", 1, 2, 3.0), mytupletype)
isa(("A", (1, 2)), mytupletype)


# Tipos de tuplas con número fijo de argumentos

otrotipo = Tuple{AbstractString, Vararg{Float64, 3}}
println(otrotipo, "\t", typeof(otrotipo))
isa(("Hola", 0.3, 0.4, 0.5), otrotipo)
isa(("Hola", 0.3, 0.4, 0.5, 0.6), otrotipo)
isa(("Hola", 0.3, 0.4), otrotipo)


# Tipos de tuplas con nombres

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

@NamedTuple{a::Int, b::String}
# es lo mismo que 
NamedTuple{(:a, :b), Tuple{Int, String}}
# y que
@NamedTuple begin
    a::Int
    b::String
end


# Tipos de vectores y arreglos

Vector{Float64}
Vector{Real}

a = Vector{Float64}(undef, 4)
a[1] = 0.1
a[2] = 2//3
println(a, "\t", typeof(a))

b = Vector{Real}(undef, 4)
b[1] = Float16(0.2)
b[2] = big(3)^500
b[3] = π
b[4] = 2//3
println(typeof(b))
println(b)

v1 = Vector{Union{Missing, String}}(missing, 3)
println(v1, "\t", typeof(v1))
v1[2] = "perro"
println(v1, "\t", typeof(v1))

v2 = Vector{Union{Nothing, Float64}}(nothing, 3)
println(v2, "\t", typeof(v2))
v2[2] = 3.6
println(v2, "\t", typeof(v2))

Array{Int8,3}

Array{Float64,2} # que es lo mismo que
Matrix{Float64}

Array{AbstractChar,1} # que es lo mismo que
Vector{AbstractChar}

Matrix{Int}(undef, 2, 3)
Array{AbstractString, 3}(undef,2,3,4)


## Tipos solitarios (singletons)
## Base.issingletontype

#  son tipos compuestos inmutables sin campos
struct Solitario
end

fieldnames(Solitario)
Base.issingletontype(Solitario)

struct NoSolitario
    nombre::String
    número::Int64
end
fieldnames(NoSolitario)
Base.issingletontype(NoSolitario)

Base.issingletontype(Number)
fieldnames(Number) # ERROR

s = Solitario()
println(s, "\t", typeof(s))
isa(s, Solitario)
s2 = Solitario()
s == s2, s === s2

# tipos solitarios paramétricos

struct SolitoP{T}
end
fieldnames(SolitoP)
Base.issingletontype(SolitoP)
typeof(SolitoP)
Base.issingletontype(SolitoP{Bool})
typeof(SolitoP{Bool})


## Tipos de funciones

g(x) = x + 1
typeof(g)
Base.issingletontype(typeof(g))
fieldnames(typeof(g))
supertype(typeof(g))
typeof(g) <: Function
isa(g, Function)

t = x -> x + 2
t(5)
typeof(t)
supertype(typeof(t))
Base.issingletontype(typeof(t))

addy(y) = x -> x + y
typeof(addy)
Base.issingletontype(addy)
addy(7)
Base.issingletontype(addy(7))
typeof(addy(7))
isa(addy(7), Function)
addy(7)(3)
addy(9)(3)


## Operaciones sobre Tipos
#  isa  supertype  supertypes  subtypes
#  isconcretetype  isabstracttype

println(typeof(2))
println(isa(2, Int8), "\t", isa(2, Int64), "\t", isa(2, Int))
println(isa(2, Real), "\t", isa(2, Float64), "\t", isa(2, AbstractFloat))
2 isa Real, 2 isa Float64

function ti(tipo)
    if isa(tipo, DataType)
        println("\nTipo:\t\t", tipo)
        println("supertipo:\t", supertype(tipo))
        println("subtipos:\t", subtypes(tipo))
    else
        println("\n$tipo no es un DataType válido")
    end
    return nothing
end

ti(Number)

ti(Complex)
ti(ComplexF64)
ti(Complex{Float64})

ti(Real)
ti(Integer)
ti(BigInt)
ti(Rational)
ti(Rational{Int64})
ti(AbstractFloat)
ti(AbstractIrrational)
ti(Irrational{Float64})
ti(Irrational{BigFloat})

ti(Integer)
ti(Bool)
ti(Signed)
ti(Unsigned)
ti(UInt8)

ti(Rational{Int64})
ti(Rational{Int8})
ti(Rational{UInt8})

ti(AbstractString)
ti(String)
ti(SubString)
ti(SubString{String})

ti(AbstractChar)
ti(Char)

ti(Any) # Larga lista de subtipos

supertype(Int64)
supertypes(Int64)

isconcretetype(Int)
isabstracttype(Int)
isconcretetype(Real)
isabstracttype(Real)


## Ejemplo final 

abstract type Figura end

isabstracttype(Figura)
isconcretetype(Figura)

struct Trapecio <: Figura
    altura::Float64 
    base1::Float64
    base2::Float64
end

isabstracttype(Trapecio)
isconcretetype(Trapecio)

struct Círculo <: Figura
    radio::Float64
end

typeof(Figura), typeof(Trapecio), typeof(Círculo)
subtypes(Figura)
supertype(Trapecio)
supertype(Círculo)

trap = Trapecio(2.3, 5.0, 4.2)
typeof(trap)
trap.base2

c = Círculo(2.4)
typeof(c)
c.radio

Círculo(2) # conversión automática de entero 2 a flotante 2.0

Círculo(2 + 3im) # error porque no puede convertir complejo a flotante

# ==> Este ejemplo continuará al final de 09metodos.jl
