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
    if y ≠ 0
        return x / y
    elseif x ≠ 0
        return [x / y, " reales extendidos"]
    else
        return "0/0 no está definido"
    end
end
println(divide(2, 3))
println(divide(2, 0))
println(divide(0, 0))

g = function(x, y)
    return x + y # prevalece la primera vez que aparece return
    return x * y
end
println(g(2, 3))

# return type

function f(x, y)::Int8
    return x + y
end
println(f(2, 3), "\t typeof: ", typeof(f(2, 3)))

println("Int8 mín: ", typemin(Int8), "\t máx: ", typemax(Int8))
println(f(127, 2), "\t typeof: ", typeof(f(127, 2))) # InexactError
println(f(2.1, 3.6), "\t typeof: ", typeof(f(2.1, 3.6))) # InexactError

# return  nothing
function f(x, y)
    z = x + y
    println(z)
    return nothing
end
w = f(2, 3)
typeof(w)
println(w)


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
println(alumno("Pedro", "Historia", 21)) # error, falta `edad`


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
# es casi lo mismo que, salvo por el formato de salida
println(map(x -> 2x, 1:10))

map(1:10, 11:20) do x,y
    println(x + y)
end


## Vectorizar funciones con <.> (pero en Julia esto no es lo más rápido)
# broadcast

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


## Composición de funciones

δ(x) = (-x, x)
η = δ ∘ sqrt ∘ +
println(η(2, 3), "\t", √5)


## Changing names versus mutation

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
println(y) # it did not work! See next...

function setzero!(x)
    x[1] = 0
    return x
end
y = [1]
setzero!(y)
println(y) # It worked! Because arrays are mutable


## Pipes

(1, 2) |> sum |> sqrt |> x->x+2
√(1 + 2) + 2


## Definir operadores binarios

# Si A es un conjunto, un operador binario cerrado ⊕ en A es
# una función ⊕: A × A → A y se tiene la estructura algebraica (A,⊕)
# En Julia, como en cualquier otro lenguaje de programación, 
# se tienen predefinidos diversos operadores binarios sobre los
# distintos conjuntos (tipos) de números. Por ejemplo (Z,+) es
# el conjunto de los números enteros Z con la forma usual de
# de definir suma * de los mismos:

+(2, 3) 
# o bien:
2 + 3 

# Además de los operadores binarios predefinidos en Julia podemos
# definir nuevos, utilizando símbolos del siguiente catálogo:

# Con la misma precedencia que la suma usual +
# ⊕ ⊖ ⊞ ⊟ ∪ ∨ ⊔ ± ∓ ∔ ∸ ≏ ⊎ ⊻ ⊽ ⋎ ⋓ ⧺ ⧻ ⨈ ⨢ ⨣ ⨤ ⨥ ⨦ ⨧ ⨨ 
# ⨩ ⨪ ⨫ ⨬ ⨭ ⨮ ⨹ ⨺ ⩁ ⩂ ⩅ ⩊ ⩌ ⩏ ⩐ ⩒ ⩔ ⩖ ⩗ ⩛ ⩝ ⩡ ⩢ ⩣

# Con la misma precedencia que la multiplicación usual *
# % × ∩ ∧ ⊗ ⊘ ⊙ ⊚ ⊛ ⊠ ⊡ ⊓ ∗ · ∤ ⅋ ≀ ⊼ ⋄ ⋆ ⋇ ⋉ ⋊ ⋋ ⋌ ⋏ ⋒ ⟑ 
# ⦸ ⦼ ⦾ ⦿ ⧶ ⧷ ⨇ ⨰ ⨱ ⨲ ⨳ ⨴ ⨵ ⨶ ⨷ ⨸ ⨻ ⨼ ⨽ ⩀ ⩃ ⩄ ⩋ ⩍ ⩎ 
# ⩑ ⩓ ⩕ ⩘ ⩚ ⩜ ⩞ ⩟ ⩠ ⫛ ⊍ ▷ ⨝ ⟕ ⟖ ⟗

⊕(x, y) = x + y + 100
⊕(1, 2)
1 ⊕ 2

⊗(x, y) = x*y - 10
⊗(2, 3)

# Para ilustrar la precedencia de operadores:
4 + 7 * 9, (4 + 7)*9, 4 + (7 * 9)
4 ⊕ 7 ⊗ 9, (4 ⊕ 7) ⊗ 9, 4 ⊕ (7 ⊗ 9)

