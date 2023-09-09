### Arreglos
### Por Arturo Erdely basado en https://docs.julialang.org/en/v1/

# función auxiliar
function que(x)
    println("object: \t", x)
    println("typeof: \t", typeof(x))
    println("eltype: \t", eltype(x))    
    println("length: \t", length(x))
    println("ndims: \t", ndims(x))
    println("size: \t", size(x))
    println("memory: \t", Base.summarysize(x), " bytes")
    return nothing
end


## Construcción e inicialización
#  Array  undef  zeros  ones  trues  falses

typeof(Array)
supertypes(Array)
subtypes(Array)

ND = Array{Int}(undef, 2, 3, 4)
que(ND)
println(ND)
dump(ND)
summary(ND)
display(ND)

CEROint64 = zeros(Int64, (2, 3, 4))
que(CEROint64)

CEROint = zeros(Int, (2, 3, 4))
que(CEROint) 

UNOint16 = ones(Int16, (2, 3, 4))
que(UNOint16)

UNOfloat64 = ones(Float64, (2, 3, 4))
que(UNOfloat64)

CEROfloat32 = zeros(Float32, (2, 3, 4))
que(CEROfloat32)

T = trues(2, 3, 4)
que(T)

F = falses(2, 3, 4)
que(F)

# Vector 

Vector
Vector <: Array
supertypes(Vector)

V = zeros(Int, 4)
que(V)
isa(V, Array)
isa(V, Vector)

# Matrix

Matrix
Matrix <: Array
supertypes(Matrix)

M = zeros(ComplexF64, 2, 3)
que(M)
isa(M, Array)
isa(M, Matrix)
isa(M, Vector)


# reshape  copy  similar  transpose  vec  circshift

A = zeros(Int, (3, 4))
que(A)
B = A
C = copy(A)
D = similar(A) # crea una matriz similar pero no inicializada (valores basura)
tA = transpose(A)
R = reshape(A, (6, 2))
Rvec = vec(R)
A[2, 1] = 4
display(A)
display(B)
display(C)
display(tA)
display(R)
display(Rvec)
que(A)
que(B)
que(C)
que(tA)
que(R)
que(Rvec)

W = reshape(Vector(1:16), (4,4))
circshift(W, (0,2))
circshift(W, (1,2))
display(W)
circshift(W, (-1,0))


# rand  randn  range  fill  fill!

U = rand(Float64, (5, 3)) # rellenar con iid Unif[0,1)
que(U)

N = randn(Float64, (5, 3)) # rellenar con iid Normal(0,1)
que(N)

I = range(0, 10, length=101)
que(I)
collect(I)
collect(0.0:0.1:10.0)

I = range(0, 10, step = 0.3)
collect(I)

A = zeros(Int, 2, 3)
fill!(A, 4)
display(A)

B = fill('@', 2, 3)
que(B)


# eltype  typeof  length  ndims  size  sizeof  Base.summarysize
# axes  eachindex  strides

A = zeros(Int, 3, 5)
println(typeof(A), "\t", eltype(A))
println(length(A), "\t", ndims(A), "\t", size(A), "\t", "$(size(A,1))×$(size(A,2))")
println(sizeof(A), "\t", Base.summarysize(A))
println(axes(A), "\t", axes(A, 2))
@doc Base.OneTo

B = fill('x', 2, 3, 4)
display(B[2, :, :])
println(eachindex(B))
println(collect(eachindex(B)))
println(strides(B))


## Concatenación
#  cat  vcat  hcat  hvcat  stack

que([1 2 3])
que([1, 2, 3])
que([1; 2; 3])

A = zeros(Int, (2, 3))
B = ones(Int, (2, 3))
cat(A, B, dims=1)
cat(A, B, dims=2)
vcat(A, B)
hcat(A, B)
[A; B]
[A B]
[A, B]
[A B; B A]

vecs = (1:2, [30, 40], Float32[500, 600])
mat = stack(vecs)
stack(c -> (c, c-32), "julia")


## Arreglos de elementos con distintos tipos

f(x) = x^2 + 1
A = [3, "hola", f, zeros(2, 3)]
que(A)
A[3](8)


## Inicializadores de tipo de arreglo

B = Int8[[1 2]; [3 4]]
que(B)


## Definición de arreglos por comprensión

A = Int16[i^2 for i ∈ [2, 5, 9]]
que(A)

B = [i+j for i ∈ [2, 5, 8], j ∈ [-1, Inf]]
que(B)


## Expresiones generadoras

g(n::Int) = n*(n + 1)*(2n + 1)÷6
g(1_000)
sum(i^2 for i ∈ 1:1_000)
I = (i^2 for i ∈ 1:1_000)
typeof(I)

[(i,j) for i ∈ 1:6, j ∈ 20:22]
[(i,j) for i ∈ 1:6 for j ∈ 20:22]
[(i,j) for i ∈ 1:3 for j ∈ 1:i]

[(i,j) for i ∈ 1:6 for j ∈ 1:6 if i+j==7]


## Indexación

A = reshape(collect(1:16), (2, 2, 2, 2))
que(A)
A[:, 2, 2, :]

B = reshape(collect(1:24), (2,3,4))
que(B)
B[2, [1, 3], [2, 4]]


# asignación

A = reshape(collect(1:20), (5, 4))
A[3:5, [2, 4]]
A[3:5, [2, 4]] .= 999
display(A)
A[3:5, [2, 4]] = fill(1000, (3,2))
display(A)


# push!   pop!   pushfirst!  append!  prepend!  popfirst!   sort   sort!  
# deleteat!  keepat!  popat!  splice!  insert!  replace

fib = [1, 1, 2, 3, 5, 8, 13]
push!(fib, 21)
println(fib)
push!(fib, sum(fib[end-1:end]))
pop!(fib)
println(fib)
pushfirst!(fib, 0)
println(fib)
popfirst!(fib)
println(fib)

A = [1, 2, 3, 4]
append!(A, [5, 6])
println(A)
append!(A, [7, 8, 9], [10, 11])
println(A)
prepend!(A, [-2, -1, 0])
println(A) 

A = [3, 1, 9, 5, 6]
sort(A)
println(A)
sort!(A)
println(A)

deleteat!([6,5,4,3,2,1], 3)
deleteat!([6,5,4,3,2,1], 3:5)
deleteat!([6,5,4,3,2,1], [1, 3])
deleteat!([6,5,4,3,2,1], (1, 3))
deleteat!([6,5,4,3,2,1], [true, true, false, true, false, false])

keepat!([6,5,4,3,2,1], 2:4)
keepat!([6,5,4,3,2,1], [1,3,4])
keepat!([6,5,4,3,2,1], [true, true, false, true, false, false])

a = [4, 3, 2, 1]
popat!(a, 2)
a

A = [6, 5, 4, 3, 2, 1]
splice!(A, 5)
A 
splice!(A, 5, -1)
A
splice!(A, 1, [-1, -2, -3])
A

insert!([6, 5, 4, 2, 1], 4, 3)

replace([1, 2, 1, 3, 1, 1, 2, 2], 1=>0, 2=>4)
replace([1, 2, 1, 3, 1, 1, 2, 2], 1=>0, 2=>4, count=3)
replace(x -> isodd(x) ? 2x : x, [1, 2, 3, 4])

frase = "el hueso es el hueso, todos quieren su hueso"
replace(frase, "hueso" => "perro")
frase
replace(frase, "hueso" => "perro", count=2)
frase


## Tipos de indexación 

A = reshape(collect(1:2:18), (3, 3))
A[4]
A[[2, 5, 8]]
A[[1 4; 3 8]]
A[[]]
size(A[[]])

display(A)
println(collect(1:2:5))
display(A[1:2:5])
display(A[2, :])
display(A[:, 3])

# indexación cartesiana

A = reshape(1:32, 4, 4, 2)
A[3, 2, 1]
typeof(CartesianIndex(3, 2, 1))
display(CartesianIndex(3, 2, 1))
A[CartesianIndex(3, 2, 1)]

A = reshape(1:16, 4, 4)
CartesianIndices(A)
LinearIndices(A)
CartesianIndices(A)[5]
LinearIndices(A)[1, 2]

# indexación lógica
# findall   map   findmax   findmin

A = reshape(1:16, 4, 4)
A[[false, true, true, false], :]

filtro = map(ispow2, A)
display(A)
A[filtro]

filtro
findall(filtro)
findall(ispow2, A)


## Iteración
#  view  eachindex

A = rand(4, 3)
B = view(A, 1:3, 2:3)
C = A[1:3, 2:3]

A[2, 3] = 1
display(A)
display(B)
display(C)

display(A)
for a ∈ A
    @show a
end
eachindex(A)
for i ∈ eachindex(A)
    @show i
end

display(A)
for i ∈ CartesianIndices(A)
    @show i
end
for i ∈ CartesianIndices(A)
    @show Tuple(i)
end
iterador = CartesianIndices(A)
display(iterador[5])
display(iterador[1,2])
println(iterador.indices)


## Arreglos, operaciones vectorizadas y funciones

A = rand(4, 3)
U = ones(4, 3)

log.(A)
A .+= 1

A + U
A .+ U
using BenchmarkTools 
@btime A + U # más rápido
@btime A .+ U # más lento

display(A)
sum(A, dims = 1)
sum(A, dims = 2)

display(A)
h(x) = x - 100
h.(A)
H(X) = X .- 100
H(A) 
h.(A) == H(A)

@btime h.(A) # más lento
@btime H(A) # más rápido

display(A)
B = fill(1.5, size(A))
@btime min.(A, B)
@btime min.(A, 1.5)

display(A)
A .* B
A .* 1.5

display(A)
A .≤ 1.5


## Broadcasting
## repeat  broadcast  map  foreach

repeat("ha", 3)
repeat('A', 3)

repeat([1, 2, 3], 2)
repeat([1, 2, 3], 2, 3)

# Esto es ineficiente en dimensiones grandes:
a = [1, 2]
A = rand(2,3)
repeat(a, 1, 3) # estás creando una matriz a
repeat(a, 1, 3) + A

# mejor:
display(broadcast(+, a, A))
# porque realizas la operación sin crear una nueva matriz

b = [5, 9]
display(a)
display(broadcast(+, a, b))
display(a + b)

sec = 1:10
k(x) = x^2
k.(sec)
broadcast(k, sec) # es lo mismo que f.(sec)
map(k, sec) # hace lo mismo que broadcast, pero... (ver más abajo)
foreach(k, sec) # ejecuta la acción pero no conserva los valores f(n)

#=
Si `sec` es un objeto iterable broadcast(f, sec) o bien f.(sec) primero
aplican collect(sec) antes de aplicar la función f, mientras map no y puede
resultar un poco más rápido.
=#

using BenchmarkTools
sec = 1:1_000_000
@btime v = k.(sec);
@btime b = broadcast(k, sec);
@btime m = map(k, sec);

#=
En cambio si `sec` es un arreglo entonces broadcast o f.(sec)
es un poco más rápido que map:
=#

sec = collect(1:1_000_000)
@btime v = f.(sec);
@btime b = broadcast(f, sec);
@btime m = map(f, sec);


## Constructores de arreglos

undef # Para más info: ?undef
Array{Int}(undef, 1, 2)
Array{Int}(undef, 2, 1)
Array{Int}(undef, 2)
Array{Int, 2}(undef, (2, 3))
Array{Float64, 3}(undef, (3, 4, 2))

Matrix{Float64}(undef, 2, 3)
Matrix <: Array
Vector{Float64}(undef, 3)
Vector <: Array

struct Algo
    entero::Int64
    flotante::Float64
end
a = Algo(1, 1) # nótese la conversión de la segunda entrada
isbits(a)
A = Array{Algo}(undef, 2, 3)
isbits(A)

struct AlgoMás
    a::Algo
    b 
end
b = AlgoMás(Algo(1,1), 1)
isbits(b)
B = Array{AlgoMás}(undef, 2, 3)
isbits(B)
