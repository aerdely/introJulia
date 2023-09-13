### Paquete `StatsBase`: Estadísticos muestrales 
### Dr. Arturo Erdely

### Basado en: https://juliastats.org/StatsBase.jl/stable/  

### Versión: 0.34.0


## Instalar paquete

import Pkg; Pkg.add("StatsBase")


## Usar el paquete

using StatsBase 

# importa además las funciones del paquete `Statistics` (biblioteca estándar de Julia)

@doc StatsBase



## Vectores ponderados

supertypes(AbstractWeights)
subtypes(AbstractWeights)

# AnalyticWeights  aweights  

typeof(AnalyticWeights)
supertypes(AnalyticWeights)
subtypes(AnalyticWeights)
isabstracttype(AnalyticWeights)
isconcretetype(AnalyticWeights)

w1 = AnalyticWeights([0.2,0.1,0.3])
w2 = aweights([0.2,0.1,0.3])
w1 == w2
typeof(w1)
typeof(w2)
isabstracttype(typeof(w1))
isconcretetype(typeof(w1))

propertynames(w1)
dump(w1)
w1.values
w1.sum

# FrequencyWeights  fweigths

supertypes(FrequencyWeights)
c1 = FrequencyWeights([2, 1, 3])
c2 = fweights([2, 1, 3])
c1 == c2
propertynames(c1)
dump(c1)
c2.values
c2.sum

# ProbabilityWeights  pweights

supertypes(ProbabilityWeights)
p1 = ProbabilityWeights([0.2, 0.1, 0.3])
p2 = pweights([0.2, 0.1, 0.3])
p1 == p2
propertynames(p1)
dump(p2)
p1.values
p2.sum

# Ponderaciones de no ponderación (para eficiencia de métodos con ponderación)
# UnitWeights  uweights

supertypes(UnitWeights)
u1 = UnitWeights{Float64}(5)
u2 = uweights(Float64, 5)
u1 == u2
u3 = uweights(7)
dump(u2)
typeof(u2)

# Ponderación genérica que no acepta los métodos de las ponderaciones anteriores
# Weights  weights  eweights

supertypes(Weights)
z1 = Weights([1., 2., 3.])
z2 = weights([1., 2., 3.])
z1 == z2
dump(z1)

λ = 0.3
n = 10
e1 = eweights(1:n, λ) # 0 < λ ≤ 1
typeof(e1)
dump(e1)
e1.sum
e1.values
y = λ .* (1-λ).^(1 .- collect(1:10))
e1.values == y
e1.sum == sum(y)
@time eweights(1:n, λ) # es más eficiente que:
@time begin
    y = λ .* (1-λ).^(1 .- collect(1:10))
    sum(y)
end;

# métodos de AbstractWeights: eltype  length  empty  isempty  values  sum

supertypes(AbstractWeights)
subtypes(AbstractWeights)
w1
eltype(w1)
length(w1)
isempty(w1)
values(w1)
sum(w1)

r = rand(10_000);
w3 = aweights(r);
Base.summarysize(r), Base.summarysize(w3)
@time sum(r); # ejecutar 2 veces
@time sum(w3); # ejecutar 2 veces
# lo anterior porque la suma ya está calculada en w3:
w3.sum == sum(r)



## Estadísticos escalares

# Suma y media ponderadas
# sum  sum!  wsum  wsum!  mean  mean!

w = aweights([0.1, 1.0, 10])
A = [1, 2, 3]
sum(A)
sum(A, w)
sum(A .* w)
R = [-1.0, -2.0, -3.0]
sum!(R, A, w, 1)
R
R = [-1.0, -2.0, -3.0]
sum!(R, A, w, 1, init = false)
R

A = [1 2 3; 4 5 6; 7 8 9]
sum(A, dims = 1)
sum(A, w, dims = 1)
wsum(A, w, 1)
sum(A, w, dims = 1) == wsum(A, w, 1)
sum(A, dims = 2)
sum(A, w, dims = 2)
wsum(A, w, 2)

A = randn(10_000) .^ 2;
w = aweights(rand(10_000));
using LinearAlgebra
# ejecutar 2 veces
@time s1 = sum(A .* w.values) # el más lento
@time s2 = dot(A, w.values) # `dot` más rápido que el anterior
@time s3 = sum(A, w) # un poco más rápido que `dot`
@time s4 = wsum(A, w) # un poco más rápido que `dot`
s1, s2, s3, s4

# para mejor precisión en la comparación de tiempo usar el paquete `BenchmarkTools`:
using BenchmarkTools
@btime s1 = sum(A .* w.values) # el más lento
@btime s2 = dot(A, w.values) # `dot` más rápido que el anterior
@btime s3 = sum(A, w) # un poco más rápido que `dot`
@btime s4 = wsum(A, w) # igual de rápido que sum(A, w)

mean(A, w) == s4 / w.sum



## Otros tipos de medias
#  geomean  harmean  genmean

begin # media geométrica = (a1 × a2 × ⋯ × an) ^ (1/n) 
    D = [1, 2, 3, 4, 5]
    res5 = geomean(D)
    # Que puede calcularse directamente de 2 formas:
    res6 = prod(D) ^ (1/length(D))
    # o usando: log{(a1 × a2 × ⋯ × an) ^ (1/n)} = ∑ log(ak) / n 
    res7 = exp(mean(log.(D)))
    println((res5, res6, res7))
end

begin # comparando medias geométricas
    M = Array{Any}(undef, 3, 3)
    M[:, 1] = ["==", "res5", "res6"]
    M[1, 2:3] = ["res6", "res7"]
    M[2, 2] = (res5 == res6)
    M[2, 3] = (res5 == res7)
    M[3, 3] = (res6 == res7)
    display(M)
end

begin # comparando medias geométricas con redondeo
    Mr = Array{Any}(undef, 3, 3)
    Mr[:, 1] = ["≈≈", "res5", "res6"] # \approx + [tab]
    Mr[1, 2:3] = ["res6", "res7"]
    r = round.([res5, res6, res7], digits = 8)
    Mr[2, 2] = (r[1] == r[2])
    Mr[2, 3] = (r[1] == r[3])
    Mr[3, 3] = (r[2] == r[3])
    display(Mr)
end

# ¿Qué forma de cálculo es más rápida y eficiente?
D = collect(1.1:0.1:100.0);
@time res8 = geomean(D) # ejecutar 2 veces
@time res9 = prod(D)^(1/length(D)) # problema numérico de overflow
@time res10 = exp(mean(log.(D))) # ejecutar 2 veces

A = [1, 2, 3, 4]
harmmean(A)
inv(mean(1 ./ A))

genmean(A, 1.5)
mean(A .^ 1.5) ^ (1/1.5)

genmean(A, 0.001)
genmean(A, 0.0)
geomean(A)



## Otros estadísticos muestrales

#  var  std  mean_and_var  mean_and_std  variation  sem 

A = [1, 2, 3, 4]
aw = aweights([100.0, 10.0, 1.0, 0.1])
fw = fweights([80, 40, 20, 10])
pw = pweights([0.4, 0.3, 0.1, 0.2])
aμ = mean(A, aw)
fμ = mean(A, fw) 
pμ = mean(A, pw)
var(A, aw)
sum(aw.values .* ((A .- aμ).^2)) / aw.sum
var(A, aw, corrected = true)
sum(aw.values .* ((A .- aμ).^2)) / (aw.sum - sum(aw.values .^ 2)/aw.sum)
var(A, fw)
sum(fw.values .* ((A .- fμ).^2)) / fw.sum
var(A, fw, corrected = true)
sum(fw.values .* ((A .- fμ).^2)) / (fw.sum - 1)
var(A, pw)
sum(pw.values .* ((A .- pμ).^2)) / pw.sum
var(A, pw, corrected = true)
n = count(!iszero, aw)
sum(pw.values .* ((A .- pμ).^2)) * n / ((n-1) * pw.sum)

sem(A)
sem(A, pw)

Z = randn(100) .^ 2;
μ = mean(Z); σ = std(Z);
variation(Z), σ / μ


#  skewness  kurtosis  moment  cumulant  

Z = randn(10_000);
(skewness(Z), kurtosis(Z)) # aprox (0.0, 0.0)
A = randn(7) .^ 2
aw = aweights(rand(7))
skewness(A), skewness(A, aw)
kurtosis(A), kurtosis(A, aw)
moment(A, 3), moment(A, 3, aw)


#  mode  modes

D = [1, 2, 1, 1, 3, 1, 1]
allunique(D)
mode(D)
modes(D)

E = [2, 2, 1, 1, 2, 1, 3]
allunique(E)
mode(E)
modes(E)

F = [1, 2, 3, 4, 5]
allunique(F)
mode(F)
modes(F)


# percentile  iqr  nquantile  quantile  median  mad
# quantilerank  percentilerank  

Z = randn(10_000) .^2 ;
percentile(Z, 50)
quantile(Z, 0.5)
median(Z)
mad(Z, normalize = false)
mad(Z, center = median(Z), normalize = false)
median(abs.(Z .- median(Z)))
mad(Z, center = mean(Z), normalize = false)
median(abs.(Z .- mean(Z)))
iqr(Z)
percentile(Z, 75) - percentile(Z, 25)
nquantile(Z, 5)
quantile(Z, collect(0:5) / 5)

A = randn(10);
w = aweights(rand(10));
quantile(A, 0.7)
quantile(A, w, 0.7)
median(A)
median(A, w)

B = [1, 2, 3, 4, 5];
n = length(B);
quantilerank(B, 2)
quantilerank(B, 2, method = :inc)
sum(B .< 2) / (n-1)
quantilerank(B, 0), quantilerank(B, 5)
quantilerank(B, 2, method = :weak)
sum(B .≤ 2) / n
quantilerank(B, 0, method = :weak), quantilerank(B, 5, method = :weak)

Z = randn(100_000);
using BenchmarkTools
@btime quantilerank(Z, -1.0, method = :weak) # un poco más lento pero poquísima memoria
@btime mean(Z .≤ -1.0) # un poco más rápido pero más memoria
@btime count(Z .≤ -1.0) / length(Z) # mucho más rápido pero todavía más memoria


# summarystats  describe

Z = randn(10_000);
resumen = summarystats(Z)
typeof(resumen)
println(resumen)
propertynames(resumen)
resumen.q25

d = describe(Z)
typeof(d)
propertynames(d)


#  ordinalrank  competerank  denserank
begin
    D = [0.3, 0.5, 0.2, 0.1, 0.4]
    or = ordinalrank(D)
    println(D)
    println(or)
end
begin
    D = [.1, .2, .2, .2, .3, .3]
    or = ordinalrank(D)
    cr = competerank(D)
    dr = denserank(D)
    tr = tiedrank(D)
end;
d = Dict([:or, :cr, :dr, :tr] .=> ["ordinal", "compete", "dense", "tied"])
for r ∈ [:or, :cr, :dr, :tr]
    println(d[r])
    display(hcat(D, eval(r)))
    println()
end


# control de valores atípicos (outliers)
# trim  trim!  winsor  winsor!

# Aviso: si cargaste el paquete `BenchmarkTools` hay conflicto con `trim`
# y en tal caso debes escribir `StatsBase.trim`

z = sort(rand(10))
trim(z, count = 2)
collect(trim(z, count = 2))
collect(trim(z, prop = 0.2))

z = sort(rand(9))
trim(z, count = 2)
collect(trim(z, count = 2))
collect(trim(z, prop = 0.2))

collect(trim(z)) == z

z
collect(winsor(z, count = 2))
collect(winsor(z, prop = 0.2))
