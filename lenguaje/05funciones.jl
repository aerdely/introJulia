### Funciones
### Por Arturo Erdely basado en https://docs.julialang.org/en/v1/

function f₁(x, y)  
    x + y
end

# o bien

f₂(x, y) = x + y

println(f₁(2, 3), "\t", f₂(2, 3))

Σ = f₂
println(Σ(3, 4))

# o bien

f₃ = (x, y) -> x + y
println(f₃(5, 9))

# o como función anónima

((x, y)->x+y)(5, 9)


## Uso de `return`

function f(x, y)
    x + y
    x * y
end
println(f(2, 3))

function f(x, y)
    return x + y
    x * y
end
println(f(2, 3))

function f(x, y)
    x + y
    return x * y
end
println(f(2, 3))

function divide(x, y)
    if y == 0.0 && x ≠ 0.0
        println("Aviso: Operación en el sistema extendido de numeros reales")
    end
    if y == 0.0 && x == 0.0
        println("Aviso: 0/0 no está definido")
    end
    return x / y
end
println(divide(2, 3))
println(divide(2, 0))
println(divide(0, 0))

g = function(x, y)
    return x + y # prevalece la primera vez que aparece return
    return x * y
end
println(g(2, 3))

# Especificar tipo de dato que entrega una función 

function f(x, y)::Int8
    return x + y
end
println(f(2, 3), "\t typeof: ", typeof(f(2, 3)))

println("Int8 mín: ", typemin(Int8), "\t máx: ", typemax(Int8))
println(f(127, 2), "\t typeof: ", typeof(f(127, 2))) # InexactError
println(f(2.1, 3.6), "\t typeof: ", typeof(f(2.1, 3.6))) # InexactError

# return  nothing  isnothing  Base.notnothing  something 
function f(x, y)
    z = x + y
    println(z)
    return nothing
end
w = f(2, 3)
typeof(w)
println(w)
isnothing(w)
Base.notnothing(5)
Base.notnothing(w)
something(nothing, nothing, 3, nothing, Inf)


## Los operadores son funciones

println(+(1, 2, 3))
println(*(2, 3, 4))


## Operadores implícitos

# [A B C ...]       hcat
# [A; B; C; ...]    vcat
# [A B; C D; ...]   hvcat
# A'                adjoint
# A[i]              getindex
# A[i] = x          setindex!
# A.n               getproperty
# A.n = x           setproperty!

[1 2 3]
hcat(1, 2, 3)

[1; 2; 3]
[1, 2, 3]
vcat(1, 2, 3)


## Funciones anónimas
# map

println(map(round, [1.2, 3.5, 1.7]))

println(map(x -> x^2 + 2x - 1, [1, 3, -1]))


## Tuplas
# Las tuplas son n-adas (ordenadas) que una vez definidas no pueden modificarse parcialmente,
# a diferencia de los vectores (pero tienen la ventaja de facilitar cálculos más rápidos)

function que(x)
    println("object: \t", x)
    println("typeof: \t", typeof(x))
    println("sizeof: \t", sizeof(x))
    println("length: \t", length(x))
    return nothing
end
que("ó")

x = (1, 1+1)
que(x)

x = (1,)
que(x)

x = (1)
que(x)

x = (0.0, "hello", 6*7)
que(x)
println(x[2])

x = ()
que(x)

x = (3, 9.1, 5//9, 3 - 2im)
x[3]
x[[2, 4]]
x[1:3]
x[1] = 4 # error: no se permite modificar entradas de una tupla
x

# Tuplas con nombres

x = (a = 1, b = 1 + 1)
que(x)
que(x.b)

t = (nombre = "Alicia", edad = 28, covid = false)
t.edad
getproperty(t, :edad) # igual que `t.edad`
t[2]
getindex(t, 2) # igual que `t[2]`
keys(t)
propertynames(t) # igual que `keys(t)`
values(t)
typeof(keys(t))
collect(keys(t))
typeof(values(t))
collect(values(t))

# fusionar tuplas con nombre

x = (a = 1, b = 2, c = 3)
y = (d = 4, e = 5)
merge(x, y)
merge(y, x)

z = (c = 30, d = 40)
merge(x, z)
merge(z, x)

# Respuesta múltiple

function foo(a, b)
    return (a + b, a * b)
end
x = foo(2, 3)
que(x)
y, z = foo(2, 3)
que(z)
(u, v) = foo(2, 3)
que(u)

# intecambiar valores

x = 10
y = 1000
x, y = y, x
(x, y)

# uso de ...

a, b... = [1,2,3,4]
a, b
c, d... = "¡Hola!"
c, d

# Descomposición de argumento múltiple

fminmax(x, y) = (y < x) ? (y, x) : (x, y)
rango((minimo, maximo)) = maximo - minimo
que(rango(fminmax(10, 2)))
# aunque ya existen las funciones minmax y range

# Número variable de argumentos

bar(a, b, x...) = (a, b, x)
que(bar(1, 2))
que(bar(1, 2, 3))
que(bar(1, 2, 3, 4, 5))
que(bar((1,2), 3, 4, (5,6)))

x = (2, 3, 4)
que(bar(1, x))
que(bar(1, x...))
que(bar(x...))
que(bar(x)) # InexactError

x = [1, 2, 3, 4]
que(bar(x...))

baz(a, b) = a + b
args = [1, 2]
que(baz(args...))

# tuple  ntuple

tuple(1, π, 'a')
tuple([], [1,2,3])

fun(x) = x^2 + 1
ntuple(fun, 5)


## Argumentos opcionales

function paciente(name::String = "sin info", age::Int64 = -1, smoker::String = "sin respuesta")
    ficha = (nombre = name, edad = age, fumador = smoker)
    println("nombre: \t", ficha.nombre)
    println("edad: \t\t", ficha.edad)
    println("fumador? \t", ficha.fumador)
    return ficha
end

x = paciente("Juan", 21)
println(typeof(x))
println(x)
println(x.fumador)

y = paciente("Pedro")
println(typeof(y))
println(y)
println(y.nombre)

z = paciente()
println(typeof(z))
println(z)
println(z.nombre)


## Argumentos por nombre

function fichar(nombre::String, edad::Int64; sexo::String = "ND", fuma::Bool = false)
    ficha = (nom = nombre, ed = edad, sex = sexo, fum = fuma)
    println(ficha.nom, " capturado OK")
    return(ficha)
end

x = fichar("Ana", 34, fuma = true)
println(typeof(x))
println(x)
println(x.sex)

# argumentos opcionales por nombre

function alumno(nombre::String, carrera::String; edad = 0)
    return (nombre, carrera, edad)
end
println(alumno("Juan", "Actuaría"))
println(alumno("María", "MAC", edad = 19))
println(alumno("Pedro", "Historia", 21)) # error, falta especificar `edad`


## Alcance de los valores por defecto

b = 3
function f(x, a = b, b = 1)
    return (x, a, b)
end
println(f(2))
function h(x, b = 1, a = b)
    return(x, a, b)
end
println(h(2))


## Bloques de código con <do>

map(1:10) do x
    println(2x)
end
# es casi lo mismo que lo siguiente, salvo por el formato de salida
println(map(x -> 2x, 1:10))

map(1:10, 11:20) do x,y
    println(x + y)
end


## Vectorizar funciones con <.> (pero en Julia esto no es lo más rápido)
#  broadcast

function ∠(θ)
    for k ∈ 1:length(θ)
        θ[k] = sin(θ[k])
    end
    θ
end

θ = rand(100_000_000)

println("lista comprensiva:")
@time 😰 = [sin(β) for β ∈ θ]

println("vectorizado:")
@time 😁 = sin.(θ)

println("con ciclo <for> puro:")
@time 😂 = ∠(θ)

println(sqrt.([2, 4, 16])) # es lo mismo que:
println(broadcast(sqrt, [2, 4, 16]))

v = [1, 3, 5]
log.(v) .^ 2 .- 1/2 # es lo mismo que:
@. log(v)^2 - 1/2


## Composición de funciones

δ(x) = (-x, x)
η = δ ∘ sqrt ∘ +
typeof(η)
println(η(2, 3), "\t", √5)


## Cambiar nombres versus mutación

v = [3, 5, 2]
println(sort(v))
println(v)
sort!(v)
println(v)

function setzero!(x)
    x = 0
    return x
end
y = 1
setzero!(y)
println(y) # No funcionó, pero revisa lo que sigue:

function setzero!(x)
    x[1] = 0
    return x
end
y = [1]
setzero!(y)
println(y) # Funcionó porque los arreglos son mutables


## Pipes

(1, 2) |> sum |> sqrt |> x->x+2
√(1 + 2) + 2


## Definir operadores binarios

#=
Si A es un conjunto, un operador binario cerrado ⊕ en A es
una función ⊕: A × A → A y se tiene la estructura algebraica (A,⊕)
En Julia, como en cualquier otro lenguaje de programación, 
se tienen predefinidos diversos operadores binarios sobre los
distintos conjuntos (tipos) de números. Por ejemplo (Z,+) es
el conjunto de los números enteros Z con la forma usual de
de definir suma * de los mismos:
=#

+(2, 3) 
# o bien:
2 + 3 

#=
Además de los operadores binarios predefinidos en Julia podemos
definir nuevos, utilizando símbolos del siguiente catálogo:

Con la misma precedencia que la suma usual +
⊕ ⊖ ⊞ ⊟ ∪ ∨ ⊔ ± ∓ ∔ ∸ ≏ ⊎ ⊻ ⊽ ⋎ ⋓ ⧺ ⧻ ⨈ ⨢ ⨣ ⨤ ⨥ ⨦ ⨧ ⨨ 
⨩ ⨪ ⨫ ⨬ ⨭ ⨮ ⨹ ⨺ ⩁ ⩂ ⩅ ⩊ ⩌ ⩏ ⩐ ⩒ ⩔ ⩖ ⩗ ⩛ ⩝ ⩡ ⩢ ⩣

Con la misma precedencia que la multiplicación usual *
% × ∩ ∧ ⊗ ⊘ ⊙ ⊚ ⊛ ⊠ ⊡ ⊓ ∗ · ∤ ⅋ ≀ ⊼ ⋄ ⋆ ⋇ ⋉ ⋊ ⋋ ⋌ ⋏ ⋒ ⟑ 
⦸ ⦼ ⦾ ⦿ ⧶ ⧷ ⨇ ⨰ ⨱ ⨲ ⨳ ⨴ ⨵ ⨶ ⨷ ⨸ ⨻ ⨼ ⨽ ⩀ ⩃ ⩄ ⩋ ⩍ ⩎ 
⩑ ⩓ ⩕ ⩘ ⩚ ⩜ ⩞ ⩟ ⩠ ⫛ ⊍ ▷ ⨝ ⟕ ⟖ ⟗
=#

⊕(x, y) = x + y + 100
⊕(1, 2)
1 ⊕ 2

⊗(x, y) = x*y - 10
⊗(2, 3)

# Para ilustrar la precedencia de operadores:
4 + 7 * 9, (4 + 7)*9, 4 + (7 * 9)
4 ⊕ 7 ⊗ 9, (4 ⊕ 7) ⊗ 9, 4 ⊕ (7 ⊗ 9)


## Otras formas de definir funciones
#  Fuente: https://levelup.gitconnected.com/functional-one-liners-in-julia-e0ed35d4ff7b

# Esto:
3 < 4
# es lo mismo que:
<(3, 4)
# pero si no damos uno de los argumentos:
<(4)
# se crea una función. Por ejemplo:
ff = <(4) 
ff(3)
ff(4)
# que sería lo mismo que:
gg(x) = (x < 4)
gg(3)
gg(4)
# se puede utilizar para funciones anónimas:
filter(<(5), 1:10)
filter(>(5), 1:10)
findall(==(4), [4, 8, 4, 2, 1, 5])
findfirst(==(4), [4, 8, 4, 2, 1, 5])
findlast(==("foo"), ["bar", "foo", "qux", "foo"])

# Negación de funciones booleanas
filter(!isempty, ["foo", "", "bar", ""])

# `broadcast` versus `map`

map(sqrt, [9, 16, 25]) 
# es lo mismo que:
broadcast(sqrt, [9, 16, 25])

parse(Int, "42")
map(s -> parse(Int, s), ["7", "42", "1331"])
broadcast(parse, Int, ["7", "42", "1331"])
parse.(Int, ["7", "42", "1331"])
sqrt.(parse.(Int, ["9", "16", "25"])) 

# nesting versus Pipes

string(sqrt(16))
16 |> sqrt |> string

[16, 4, 9] .|> sqrt .|> string
