### Arreglos multidimensionales
### Por Arturo Erdely basado en https://docs.julialang.org/en/v1/

include("varios.jl")

## Construcción e inicialización
#  Array  undef  zeros  ones  trues  falses

NA = Array{Int}(undef, 2, 3, 4)
que(NA)
display(NA)

CERO = zeros(Int, (2, 3, 4))
que(CERO)
display(CERO)

UNOS = ones(Float64, (2, 3, 4))
que(UNOS)
display(UNOS)

V = trues(2, 3, 4)
que(V)
display(V)

F = falses(2, 3, 4)
que(F)
display(F)

# reshape  copy  transpose  vec

A = zeros(Int, (3, 4))
que(A)
display(A)
B = A
C = copy(A)
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

# rand  randn  range  fill  fill!

U = rand(Float64, (5, 3)) # rellenar con iid Unif[0,1)
que(U)
display(U)

N = randn(Float64, (5, 3)) # rellenar con iid Normal(0,1)
que(N)
display(N)

I = range(0, 10, length=101)
que(I)
display(I)
println(collect(I))
display(collect(I))
display(collect(0.0:0.1:10.0))

I = range(0, 10, step = 0.3)
collect(I)

A = zeros(Int, 2, 3)
display(A)
fill!(A, 4)
display(A)

B = fill('@', 2, 3)
que(B)
display(B)

# eltype  typeof  length  ndims  size
# axes  eachindex  strides

A = zeros(Int, 2, 3)
display(A)
println(typeof(A), "\t", eltype(A))
println(length(A), "\t", ndims(A), "\t", size(A))
println(axes(A), "\t", axes(A, 2))

B = fill('x', 2, 3, 4)
display(B)
display(B[2, :, :])
println(eachindex(B))
println(collect(eachindex(B)))
println(strides(B))


## Concatenación
## cat  vcat  hcat  hvcat

que([1 2 3])
println(size([1 2 3]))
que([1, 2, 3])
println(size([1, 2, 3]))
que([1; 2; 3])
println(size([1; 2; 3]))

A = zeros(Int, (2, 3))
B = ones(Int, (2, 3))
display(A)
display(B)
display(cat(A, B, dims=1))
display(cat(A, B, dims=2))
display(vcat(A, B))
display(hcat(A, B))
display([A; B])
display([A B])
display([A, B])
display([A B; B A])


## Inicializadores de tipo de arreglo

f(x) = x^2 + 1
A = [3, "hola", f, zeros(2, 3)]
que(A)
println(eltype(A))
println(A[3](8))

B = Int8[[1 2]; [3 4]]
que(B)
display(B)


## Definición de arreglos por comprensión

A = [i^2 for i ∈ [2, 5, 9]]
que(A)
display(A)

B = [i+j for i ∈ [2, 5, 8], j ∈ [-1, Inf]]
que(B)
display(B)


## Expresiones generadoras

f(n::Int) = n*(n + 1)*(2n + 1)÷6
methods(f)
println(f(1_000))
println(sum(i^2 for i ∈ 1:1_000))

display([(i,j) for i ∈ 1:6, j ∈ 20:22])
display([(i,j) for i ∈ 1:6 for j ∈ 20:22])
display([(i,j) for i ∈ 1:3 for j ∈ 1:i])

display([(i,j) for i ∈ 1:6 for j ∈ 1:6 if i+j==7])


## Indexación

A = reshape(collect(1:16), (2, 2, 2, 2))
que(A)
display(A)
display(A[:, 2, 2, :])

B = reshape(collect(1:24), (2,3,4))
que(B)
display(B)
display(B[2, [1, 3], [2, 4]])


## Asignación indexada

A = reshape(collect(1:20), (5, 4))
que(A)
display(A)
display(A[3:5, [2, 4]])
A[3:5, [2, 4]] .= 999
display(A)
A[3:5, [2, 4]] = fill(1000, (3,2))
display(A)

# push!   pop!   pushfirst!  append!  prepend!  popfirst!   sort   sort!  

fib = [1, 1, 2, 3, 5, 8, 13]
push!(fib, 21)
println(fib)
push!(fib, sum(fib[end-1:end]))
println(fib)
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
B = sort(A)
println(B)
println(A)
sort!(A)
println(A)


## Tipos de indexación 

A = reshape(collect(1:2:18), (3, 3))
que(A)
display(A)

display(A[4])
que([2, 5, 8])
display(A[[2, 5, 8]])
display(A[[1 4; 3 8]])
display(A[[]])
println(size(A[[]]))

display(A)
println(collect(1:2:5))
display(A[1:2:5])
display(A[2, :])
display(A[:, 3])

# indexación cartesiana

A = reshape(1:32, 4, 4, 2)
que(A)
display(A)
display(A[3, 2, 1])
que(CartesianIndex(3, 2, 1))
display(CartesianIndex(3, 2, 1))
display(A[CartesianIndex(3, 2, 1)])

A = reshape(1:16, 4, 4)
que(A)
display(A)

display(CartesianIndices(A))
display(LinearIndices(A))
display(CartesianIndices(A)[5])
display(LinearIndices(A)[1, 2])

# indexación lógica
# findall   map   findmax   findmin

A = reshape(1:16, 4, 4)
que(A)
display(A)
display(A[[false, true, true, false], :])

filtro = map(ispow2, A)
que(filtro)
display(A)
display(filtro)
display(A[filtro])
que(A[filtro])

que(findall(filtro))
display(findall(filtro))
display(findall(ispow2, A))

display(CartesianIndices(A))
display(LinearIndices(A))
display(CartesianIndices(A)[5])
display(LinearIndices(A)[1, 2])


## Iteración
#  view  eachindex

A = rand(4, 3)
display(A)
B = view(A, 1:3, 2:3)
display(B)
C = A[1:3, 2:3]
display(C)

A[2, 3] = 1
display(A)
display(B)
display(C)

display(A)
for a ∈ A
    @show a
end
que(eachindex(A))
for i ∈ eachindex(A)
    @show i
end

for i ∈ CartesianIndices(A)
    @show i
end
for i ∈ CartesianIndices(A)
    @show Tuple(i)
end
iterador = CartesianIndices(A)
que(iterador)
display(iterador)
stipo(typeof(iterador))
display(iterador[5])
display(iterador[1,2])
println(iterador.indices)


## Arreglos, operaciones vectorizadas y funciones

A = rand(4, 3)
U = ones(4, 3)
display(A)
display(U)

display(log.(A))
display(A .+= 1)
display(A + U)

display(A)
f(x) = x - 100
display(f.(A))

display(A)
B = fill(1.5, size(A))
display(B)
display(min.(A, B))
display(min.(A, 1.5))

display(A)
display(A .* U)
display(A .* 2)

display(A)
display(A .≤ 1.5)


## Broadcasting
## repeat  broadcast  map  foreach

que(repeat("ha", 3))
que(repeat('A', 3))

display(repeat([1, 2, 3], 2))
display(repeat([1, 2, 3], 2, 3))

# Esto es ineficiente en dimensiones grandes:
a = [1, 2]
A = rand(2,3)
display(a)
display(A)
display(repeat(a, 1, 3)) # estás creando una matriz a
display(repeat(a, 1, 3) + A)

# mejor:
display(broadcast(+, a, A))
# porque realizas la operación sin crear una nueva matriz

b = [5, 9]
display(a)
display(b)
display(broadcast(+, a, b))
display(a + b)

sec = 1:10
f(x) = x^2
f.(sec)
broadcast(f, sec) # es lo mismo que f.(sec)
map(f, sec) # hace lo mismo que broadcast, pero... (ver más abajo)
foreach(f, sec) # ejecuta la acción pero no conserva los valores f(n)

# Si `sec` es un objeto iterable broadcast(f, sec) o bien f.(sec) primero
# aplican collect(sec) antes de aplicar la función f, mientras map no y puede
# resultar un poco más rápido.

using BenchmarkTools
sec = 1:1_000_000
f(x) = x^2
@btime v = f.(sec);
@btime b = broadcast(f, sec);
@btime m = map(f, sec);

# En cambio si `sec` es un arreglo entonces broadcast o f.(sec) es un poco
# rápido que map:

sec = collect(1:1_000_000)
@btime v = f.(sec);
@btime b = broadcast(f, sec);
@btime m = map(f, sec);


