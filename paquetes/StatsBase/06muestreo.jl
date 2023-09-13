### Paquete `StatsBase`: Muestreo 
### Dr. Arturo Erdely

### Basado en: https://juliastats.org/StatsBase.jl/stable/  

using StatsBase


##  Muestreo con reemplazo
##  sample  sample!  wsample  wsample!

# distribución uniforme

a = [5, 3, 1, 4, 2]
s = sample(a, 100_000)
hcat(sort(a), proportions(s))

# distribución no uniforme

p = pweights([0.1, 0.5, 0.1, 0.1, 0.2])
s = sample(a, p, 100_000)
hcat(sort(a), proportions(s))

s = wsample(a, p, 100_00)
hcat(sort(a), proportions(s))

# observaciones muestrales en el orden del conjunto muestreado

println(a)
println(sample(a, 100, ordered = true))
s = wsample(a, p, 10_000, ordered = true)
hcat(sort(a), proportions(s))

@time wsample(a, p, 10_000, ordered = true); # el ordenamiento tiene un costo en tiempo
@time wsample(a, p, 10_000);

# comparando velocidad de `sample` y `wsample`

@time sample(a, p, 100_000);
@time wsample(a, p, 100_00); # más rápido `wsample` para muestreo no uniforme

w = repeat([1/length(a)], length(a))
@time wsample(a, w, 100_000);
@time sample(a, 100_000); # más rápido `sample` para muestreo uniforme

# comparando versus `rand` y `Distributions`

using Random, Distributions, BenchmarkTools

@btime rand(a, 100_000);
@btime sample(a, 100_000); # igual

d = DiscreteNonParametric(a, p)
@btime rand(d, 100_000);
@btime wsample(a, p, 100_000); # poquito más rápido y eficiente


## Muestreo sin reemplazo

a = collect(1:10);
sample(a, 7, replace = false)
sample(a, 10, replace = false) # permutación aleatoria
sample(a, 11, replace = false) # ERROR

a = collect(1:100);
@btime randperm(100);
@btime sample(a, 100, replace = false); # más rápido pero más memoria
@btime randperm(100)[1:20];
@btime sample(a, 20, replace = false); # más rápido

b = rand(100);
@btime shuffle(b)[1:20];
@btime sample(b, 20, replace = false); # más rápido

samplepair(100)
c = [1.1, 2.2, 3.3, 4.4, 5.5];
samplepair(c)
