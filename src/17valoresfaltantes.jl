### Valores faltantes (missing)
### Por Arturo Erdely basado en https://docs.julialang.org/en/v1/

include("varios.jl")

## Propagación

que(missing)
stipo(Missing)

println(missing + 1)
println("texto" * missing)
a = missing/2
que(a)


## Igualdad y comparación

println(missing == 1) # missing
println(missing > 2) # missing
println(missing == missing) # missing
println(missing === missing) # true
println(isequal(missing, missing))

println(isless(1, missing)) # true
println(isless(Inf, missing)) # true
println(isless(missing, missing)) # false


## Operaciones lógicas

println(true | missing)
println(missing | true)
println(missing | missing)
println(false | missing)
println(missing | false)

println(true & missing)
println(false & missing)
println(missing & false)

println(!missing)
println(true ⊻ missing) # \xor+TAB = ⊻


## Control de flujo y operadores de corto circuito

println(true || missing)
println(missing || true) # ERROR
println(false || missing)
println(missing || false) # ERROR

println(true && missing)
println(missing && true) # ERROR
println(false && missing)
println(missing && false) # ERROR


## Arreglos con valores faltantes

A = fill(missing, 2, 3)
que(A)
display(A)
A[1, 2] = 99 # ERROR

A = ones(2, 3)
display(A)
A[1, 2] = missing # ERROR

v = [1, missing]
que(v)
display(v)
v[1] = missing
v[2] = 99
display(v)

A = Array{Union{Missing, Float64}}(missing, 2, 3)
que(A)
display(A)
A[1, 2] = 3.0
display(A)


## Ignorar valores faltantes en operaciones

X = [2.0, missing, 1.0, 3.0, missing, Inf]
que(X)
display(X)
Y = skipmissing(X)
que(Y)
display(Y)
display(collect(Y))

println(sum(X))
println(minimum(X))
println(sum(Y))
println(minimum(Y))

X[5] = 0.5
display(X)
display(collect(Y))
println(minimum(Y))


## Operaciones lógicas en arreglos

println([1, missing] == [2, missing])
println([1, missing] == [1, missing])
println([1, 2, missing] == [1, missing, 2])

println([1, missing] === [1, missing])
# es lo mismo que:
println([1, missing] ≡ [1, missing])

println(isequal([1, missing], [1, missing]))
println(isequal([1, 2, missing], [1, missing, 2]))

println(all([true, missing]))
println(all([false, missing]))
println(any([true, missing]))
println(any([false, missing]))
