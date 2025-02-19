### Interfaces (para conjuntos iterables)
### Por Arturo Erdely basado en https://docs.julialang.org/en/v1/

# función auxiliar
function q(x) 
    println()
    println(x, "\t", typeof(x), "\t", sizeof(x), " bytes")
end


## Iteración
#  iterate  Base.iterate  zip  enumerate  collect  eachsplit  

arreglo = ['a', 'W', '@']
q(iterate(arreglo))
q(iterate(arreglo, 1))
q(iterate(arreglo, 2))
q(iterate(arreglo, 3))
q(iterate(arreglo, 4))

println(methods(iterate))

function f₁(B)
    for i ∈ B
        println(i)
    end
end

function f₂(B)
    siguiente = iterate(B)
    while siguiente !== nothing
        q(siguiente)
        (i, estado) = siguiente
        siguiente = iterate(B, estado)
    end
end

q(arreglo)
f₁(arreglo)
f₂(arreglo)

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

a = 1:5
b = ["e","d","b","c","a"]
c = ((i, 16 - i) for i ∈ 11:15)
d = zip(a, b, c)
typeof(d)
display(d)
display(collect(d))

collect(enumerate(b))

himno = "Mexicanos.al.grito.de.guerra"
split(himno, '.')
iterador = eachsplit(himno, '.')
collect(iterador)

#  Iterators.countfrom  Iterators.take  Iterators.takewhile
#  Iterators.drop  Iterators.dropwhile  Iterators.cycle
#  Iterators.repeated  Iterators.product  Iterators.partition  Iterators.reverse

iter = Iterators.countfrom(-3, 10)
for i ∈ iter
    i > 50 && break
    println(i)
end

Iterators.take(iter, 4)
collect(Iterators.take(iter, 4))

itercond(x) = x < 51
collect(Iterators.takewhile(itercond, iter))
# o bien:
collect(Iterators.takewhile(<(51), iter)) # es decir, mediante función anónima

collect(1:3:20)
collect(Iterators.drop(1:3:20, 4))
collect(Iterators.dropwhile(<(10), 1:3:20))

for (i, t) ∈ enumerate(Iterators.cycle("Julia"))
    print(t)
    i > 11 && break 
end

collect(Iterators.repeated([1,2], 5))

iterpro = Iterators.product(1:3, 'a':'e')
collect(iterpro)
# que es lo mismo que:
[(x,y) for x ∈ 1:3, y ∈ 'a':'e']

collect(Iterators.partition([1,2,3,4,5], 2))
collect(Iterators.partition(1:5, 2))
collect.(collect(Iterators.partition(1:5, 2)))
collect(Iterators.partition("Mexicanos", 4))

collect(Iterators.reverse(1:5))


# Ejemplo importante porque se usa mucho más adelante:

struct Cuadrados
    cuenta::Int
end
q(Cuadrados)
q(Cuadrados(4))

display(iterate) # iterate tiene muchos métodos
methods(iterate)
println(methods(iterate))

Base.iterate(S::Cuadrados, state=1) = state > S.cuenta ? nothing : (state*state, state+1)

display(iterate) # ahora iterate tiene más métodos
methods(iterate)
println(methods(iterate))

for i ∈ Cuadrados(10)
    println(i)
end
println(25 ∈ Cuadrados(10))
println(25 ∈ Cuadrados(4))

using Statistics
println(mean(Cuadrados(10)))
println(mean(i^2 for i ∈ 1:10))

mn = 1:10
q(mn)
println(mn)
q(collect(mn))
println(collect(mn))
display(collect(mn))
println(Cuadrados(4))

Base.eltype(::Type{Cuadrados}) = Int
Base.length(S::Cuadrados) = S.cuenta
println(length(Cuadrados(10)))

methods(sum)
Base.sum(S::Cuadrados) = (n = S.cuenta; return n*(n+1)*(2n+1)÷6)
methods(sum)
println(methods(sum)) 
println(sum(Cuadrados(1803)))
println(sum(i^2 for i ∈ 1:1803))


## Indexación
#  getindex  firstindex  lastindex  setindex!

arreglo = ['a', 'W', '@']
println(arreglo[2])
println(getindex(arreglo, 2))  # igual que `arreglo[2]`
println(firstindex(arreglo), "\t", lastindex(arreglo))
setindex!(arreglo, 'X', 2)  # igual que `arreglo[2] = 'X'`
println(arreglo)

methods(getindex)
function Base.getindex(S::Cuadrados, i::Int)
    1 ≤ i ≤ S.cuenta || throw(BoundsError(S, i))
    return i^2
end
methods(getindex) # más métodos, por el que acabamos de agregar

println(Cuadrados(10)[5])
println(Cuadrados(10)[10])
println(Cuadrados(10)[11]) # ERROR

println(arreglo[end])
println(Cuadrados(10)[end]) # ERROR porque no se ha definido método para el datatype Cuadrados

Base.firstindex(S::Cuadrados) = 1
Base.lastindex(S::Cuadrados) = length(S)
# Ahora sí va a funcionar:
println(Cuadrados(10)[end])


## Información / transformación de colecciones iterables
#=
eltype  indexin  unique  unique!  allunique  allequal
reduce  foldl  foldr  mapreduce  mapfoldl  mapfoldr  accumulate  accumulate!
cumsum  cumsum!  cumprod  cumprod! 
maximum  minimum  extrema argmax  argmin  findmax  findmin  findall
sum  prod  any  all  count  first  last  collect
filter  filter!  mapslice
=#

eltype([1, 2, 3])
eltype(["Hola", "perros", "malditos"])
eltype([1, "perro"])

A = ['a', 'e', 'z']
B = collect('a':'z')
indexin(A, B)

unique([2, 3, 3, 1, 5, 2, 2, 5])
A = [1, -1, 3, -3, 4]
unique(x -> x^2, A)
A
f(x) = x^2
unique!(f, A)
A
B = [2, 3, 3, 1, 5, 2, 2, 5]
allunique(B)
allunique(unique(B))
allunique(x -> x + rand(), B)


C = [-1, 1]
allequal(C)
allequal(C .^ 2)
allequal(x -> x^2, C)


reduce(*, 1:10)
prod(1:10)
✪(x, y) = √(x * y) # \circledstar + TAB = ✪
reduce(✪, 1:10)
r = 1
for x ∈ 2:10
    r = ✪(r, x) 
end
println(r)

reduce(-, [1, 2, 3, 4])
1 - 2 - 3 - 4
foldl(-, [1, 2, 3, 4])
((1 - 2) - 3) - 4
foldr(-, [1, 2, 3, 4])
1 - (2 - (3 - 4))

accumulate(-, [1, 2, 3, 4])
accumulate(+, [1, 2, 3, 4]) # igual que `cumsum([1, 2, 3, 4])`
accumulate(*, [1, 2, 3, 4]) # igual que `cumprod([1, 2, 3, 4])`
accumulate(*, 'a':'e')

AA = rand(1:9, 4, 4)
accumulate(+, AA, dims=1)
display(AA)
accumulate(+, AA, dims=2)
display(AA)
accumulate(+, accumulate(+, AA, dims=1), dims=2)

#=
mapreduce(f, op, itrs...; [init]) es equivalente a:
reduce(op, map(f, itr); init=init) pero más rápido
y lo análogo con `mapfoldl` y `mapfoldr`
=#

X = [-3, -2, -1, 0, 1, 2]
maximum(X)
maximum(X; init = 1.5)
maximum(X; init = 2.5)
f(z) = z^2
maximum(f, X)
maximum(f, X; init = 2.5)
A = [1 2; 3 4]
maximum(A, dims = 1)
maximum(A, dims = 2)
maximum(f, A, dims = 1)
maximum(f, A, dims = 2)
# y análogo para `minimum`

extrema(-3:8)
I = range(0, 10, step = 0.3)
extrema(I)
collect(I)
extrema([Inf, -π, 9])
X = [-3, -2, -1, 0, 1, 2]
f(z) = z^2
extrema(f, X)
A = [1 2 3; 4 5 6]
extrema(A, dims = 1)
extrema(A, dims = 2)
extrema(A, dims = (1, 2))
extrema(A)
extrema(f, A, dims = 2)

A = [-1, 0, 1, 2, 3, 1.5]
f(x) = x^2
argmax(f, A)
pushfirst!(A, -3)
argmax(f, A) # por empate te da el primero que encuentra
# análogamente `argmin`

A = [2, -100, 99, 4, 5, 99]
findmax(A) # (valor máximo y posición del primer valor máximo)
f(x) = x^2
findmax(f, A)
# y lo análogo con `findmin`

A = [1 2; 3 4]
sum(A)
sum(1:4)
sum(A, dims = 1)
sum(A, dims = 2)
f(x) = x^2
display(A)
sum(f, A)
sum(f, A, dims = 2)
# y lo análogo para `prod` 

# any ≡ ¿existe al menos un verdadero?
any([false, false, true, false])
any([false, false, false, false])
any(x -> (x < 3), [3, 4, 5, 6])
any(x -> (x < 3), [1, 3, 4, 5, 6])
# y lo análogo para: all ≡ ¿son todos verdaderos?

count([false, true, false, false, true])
count(x -> (x < 4), [1, 3, 4, 5, 6])

A = 'a':'z'
first(A)
first(A, 5)  # ERROR
B = collect(A)
first(B)
first(B, 5)
frase = "Hola perros del mal"
first(frase)
first(frase, 4)
# y lo análogo con `last`

g(x::Int64)::Bool = (2 ≤ x ≤ 5)
g(1), g(4)
A = collect(0:10)
filter(g, A)
A
filter!(g, A)
A 

filter(!isempty, ["foo", "", "bar", ""])


## Colecciones indexables
#  getindex  setindex!

A = [1 2 3; 4 5 6]
A[5]
getindex(A, 5)
A[1, 3]
getindex(A, 1, 3)
D = Dict("a" => 1, "b" => 2) # ver Diccionarios más adelante
D["b"]
getindex(D, "b")

B = [1 2 3; 4 5 6]
A == B 
A[5] = 100
A 
setindex!(B, 100, 5)
A[2, 3] = 999
setindex!(B, 999, 2, 3) 
A == B


## Diccionarios
#  Dict  keys  values  haskey  get  get!  delete  merge  IdDict

D = Dict(1 => "a", 2 => "b", 3 => "a")
D[2]
keys(D)
collect(keys(D))
values(D)
collect(values(D))
haskey(D, 2)
haskey(D, 4)

Dvector = [("Alicia", 10), ("Bertha", 8), ("Cecilia", 10)]
calif = Dict(Dvector)
calif["Bertha"]

lista = Dict([1, 2, 3, 4] .=> ["Arnulfo", "Benito", "Carmelo", "David"])
lista[3]
lista[3] = "Caritino"
lista
lista[5] # error porque no existe
get(lista, 2, "intruso")
get(lista, 5, "intruso")
lista
get!(lista, 2, "intruso")
lista 
get!(lista, 5, "intruso")
lista

delete!(lista, 5)
lista 

D = Dict([1,1,2,3] .=> ["a", "b", "c", "d"])

D = Dict([1,2,3,4,5,6,7] .=> ["a", "a", "b", "a", "b", "a", "c"])
unique(values(D))

# imagen inversa

function imgInv(A::Array, D::Dict)
    I = []
    for a ∈ A
        for k ∈ keys(D)
            if D[k] == a
                push!(I, k)
            end
        end
    end
    return I
end

D
A = ["a", "c"]
imgInv(A, D)

# o bien programando así:

imgInv2(A::Array, D::Dict) =  filter(x -> D[x] ∈ A, keys(D))
imgInv2(A, D)
issetequal(imgInv(A, D), imgInv2(A, D))

# merge

D1 = Dict(['a', 'b', 'c'] .=> [1, 2, 3])
D2 = Dict(['c', 'd'] .=> [30, 40])
merge(D1, D2)
merge(D2, D1)

# IdDict

Dict(true => "sí", 1 => "no", 1.0 => "quizás") # simplifica tipos
IdDict(true => "sí", 1 => "no", 1.0 => "quizás") # respeta tipos



## Ordenamiento y funciones relacionadas 
#  sort  sort!  sortperm  invperm  issorted  reverse

A = [2, 3, 1]
sort(A)
sort(A, rev = true)
A
sort!(A)
A

v = randn(5)
p = sortperm(v)
v[p]
v[p] == sort(v)
ip = invperm(p)
v[p][ip]
v[p][ip] == v

f(x) = x^2
v
sort(v, by = f)
sort(v, by = f, rev = true)

v
issorted(v)
issorted(sort(v))

v
reverse(v)

v = [["aa", "10"], ["ba", "30"], ["ab", "2"], ["ba", "5"], ["aa", "2"]]
v2 = sort(v, by = x -> (x[1], parse(Int, x[2])))
println(v2)
