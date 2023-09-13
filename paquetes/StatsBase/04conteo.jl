### Paquete `StatsBase`: Conteo 
### Dr. Arturo Erdely

### Basado en: https://juliastats.org/StatsBase.jl/stable/  

using StatsBase


##  counts  proportions (solo de números enteros)

D = [5, 5, 5, 5, 2, 2, 2, -3, -3, 0]
counts(D) # solo enteros
e = extrema(D)
rango = collect(e[1]:e[2])
[rango counts(D)]

[rango proportions(D)]
M = Matrix{Any}(undef, length(rango), 2)
M[:, 1] = rango
M[:, 2] = proportions(D)
M 


##  countmap  proportionmap (sobre objetos arbitrarios)

D = [0.9, 0.25, 0.25, 0.6, 0.6, 0.6, 0.3, 0.3, 0.3, 0.3]
c = countmap(D)
p = proportionmap(D)
keys(c), values(c), values(p)


## Tabla de frecuencias absolutas y relativas:

begin
    m = length(keys(c))
    M = Matrix{Any}(undef, m + 1, 3)
    M[1, :] = ["valor", "frecuencia", "proporción"]
    valor = collect(keys(c))
    frec = collect(values(c))
    prop = collect(values(p))
    orden = sortperm(valor)
    # o bien en orden descendente de frecuencia: 
    # orden = sortperm(frec, rev = true)
    M[2:(m+1), 1] = valor[orden]
    M[2:(m+1), 2] = frec[orden]
    M[2:(m+1), 3] = prop[orden]
    display(M)
end

# o bien mediante el paquete `DataFrame` (previamente instalado: import Pkg; Pkg.add("DataFrames"))

using DataFrames 
tabla = DataFrame(valores = valor[orden], frecuencia = frec[orden], proporción = prop[orden])


## counteq  countne

a = [3, 5, 7, 9, 8, 7, 5];
b = [2, 5, 4, 6, 8, 6, 5];

counteq(a, b)
count(a .== b)
countne(a, b)
count(a .≠ b)

c = rand(collect(0:9), 10_000);
d = rand(collect(0:9), 10_000);

# ejecutar 2 veces
@time counteq(c, d) # el más eficiente
@time count(c .== d)
@time sum(c .== d)
