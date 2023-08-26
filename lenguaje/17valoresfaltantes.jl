### Valores faltantes (missing)
### Por Arturo Erdely basado en https://docs.julialang.org/en/v1/

# función auxiliar
function que(x)
    println("object: \t", x)
    T = typeof(x)
    println("tipo:\t\t", T)
    println("supertipo:\t", supertype(T))
    println("subtipos:\t", subtypes(T))
    println("memory: \t", Base.summarysize(x), " bytes")
    return nothing
end


## Propagación

que(missing)
que(Missing)

println(missing + 1)
println("texto" * missing)
a = missing/2
que(a)
ismissing(a)
ismissing([])


## Igualdad y comparación

println(missing == 1) # missing
println(missing > 2) # missing
println(missing == missing) # missing
println(missing === missing) # true
println(isequal(missing, missing)) # true porque es lo mismo que missing === missing

#=
Se considera a `missing` como el valor más grande para que la función
`sort` los deje hasta el final:
=#

println(isless(1, missing)) # true
println(isless(Inf, missing)) # true
println(isless(missing, missing)) # false
sort([2, missing, -1, missing, 0, -Inf, Inf, NaN])


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
println(true | missing)


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
A[1, 2] = 99 # ERROR

A = ones(2, 3)
A[1, 2] = missing # ERROR

v = [1, missing]
que(v)
v[1] = missing
v[2] = 99
display(v)

A = Array{Union{Missing, Float64}}(missing, 2, 3)
que(A)
A[1, 2] = 3.0
display(A)


## Ignorar valores faltantes en operaciones: `skipmissing`

X = [2.0, missing, 1.0, 3.0, missing, Inf]
que(X)
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
