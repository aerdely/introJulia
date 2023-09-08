#### Paquete `Distributions`: Modelos univariados 
#### Dr. Arturo Erdely

#### Basado en: https://juliastats.org/Distributions.jl/stable/ 


using Distributions


#= 
    Modelos univariados
    ===================

    Parámetros
    ----------
    params  scale  location  shape  rate  ncategories  ntrials  dof  succprob  failprob
    
    Estadísticos usuales
    --------------------
    maximum  minimum  extrema  mean  var  std  median  modes  mode  skewness  kurtosis
    isplatykurtic  isleptokurtic  ismesokurtic  entropy  mgf  cgf  cf  pdfsquaredL2norm

    Cálculo de probabilidades
    -------------------------
    insupport  pdf  logpdf  cdf  logcdf  logdiffcdf  ccdf  logccdf  quantile  cquantile
    invlogcdf  invlogccdf

    Muestreo
    --------
    rand  rand!
=#

### Modelos univariados continuos
### https://juliastats.org/Distributions.jl/stable/univariate/#Continuous-Distributions 

Distribution{Univariate, Continuous}
typeof(Distribution{Univariate, Continuous})
isabstracttype(Distribution{Univariate, Continuous})
subtypes(Distribution{Univariate, Continuous})
println(subtypes(Distribution{Univariate, Continuous}))

## Ejemplo

@doc Normal

X = Normal(2.0, 3.0)
params(X)
location(X)
scale(X)
minimum(X), maximum(X)
extrema(X)
mean(X)
median(X)
std(X)
var(X)
mode(X)
modes(X)
skewness(X)
kurtosis(X)
pdf.(X, [1.9, 2.0, 2.1])
cdf(X, 2.0)
quantile(X, 0.5)
cdf(X, 0.1), ccdf(X, 0.1)
cdf(X, 0.1) + ccdf(X, 0.1)
rX = rand(X, 10_000);
mean(rX), var(rX), skewness(rX), kurtosis(rX)


### Modelos univariados discretos
### https://juliastats.org/Distributions.jl/stable/univariate/#Discrete-Distributions 

Distribution{Univariate, Discrete}
typeof(Distribution{Univariate, Discrete})
isabstracttype(Distribution{Univariate, Discrete})
subtypes(Distribution{Univariate, Discrete})
println(subtypes(Distribution{Univariate, Discrete}))

## Ejemplo

@doc Binomial

n, p = 11, 0.5
B = Binomial(n, p)
mean(B), n*p
var(B), n*p*(1-p)
extrema(B)
insupport(B, [3, 7, 15])
b = collect(0:n)
hcat(b, pdf.(B, b), cdf.(B, b))
pdf(B, 5), pdf(B, 6), pdf(B, 5) == pdf(B, 6), pdf(B, 6) - pdf(B, 5)
succprob(B)
rB = rand(B, 10_000);
mean(rB)

## Aviso: inconsistencias de `mode` y `modes`
## Ya lo reporté: https://github.com/JuliaStats/Distributions.jl/issues/1772 

## Ejemplo 1
B = Binomial(3, 0.5)
v = collect(0:3);
hcat(v, pdf.(B, v)) # las modas teóricas son 1 y 2
pdf(B, 1) == pdf(B, 2) # verdadero, como era de esperarse
modes(B) # debería generar con vector [1,2] no solamente [2]
mode(B) # debería dar la primera moda que es 1 no 2
# pero sorprendentemente:
D = DiscreteNonParametric(v, pdf.(B, v))
pdf(D, 1) == pdf(D, 2) # verdadero, como era de esperarse
modes(D) # 1 y 2, como era de esperarse
mode(D) # 1, como era de esperarse

## Ejemplo 2
P = Poisson(2.0)
x = collect(0:4);
hcat(x, pdf.(P, x)) # las modas teóricas son 1 y 2
pdf(P, 1) == pdf(P, 2) # verdadero, como era de esperarse
modes(P) # 1 y 2, como era de esperarse
mode(P) # debería dar la primera moda que es 1 no 2

## Ejemplo 3
N = NegativeBinomial(3, 0.5)
y = collect(0:3);
hcat(y, pdf.(N, y)) # las modas teóricas son 1 y 2
pdf(N, 1) == pdf(N, 2) # debería ser verdadero
pdf(N, 1) - pdf(N, 2) # diferencia positiva muy pequeña
pdf(N, 1) > pdf(N, 2) # pero entonces numéricamente la moda debiera ser 1 y no 2
mode(N) # ¡Ay caray! 2 e lugar de 1
modes(N) # debería ser un vector [1,2] no solamente [2]



### Modelos univariados truncados
### https://juliastats.org/Distributions.jl/stable/truncate/ 

# `truncated`

@doc truncated

Z = Normal()

Z1 = truncated(Z, -1, 1)
pdf(Z1, 0.0) > pdf(Z, 0.0) # true, como era de esperarse
cdf(Z, -1.0), cdf(Z1, -1.0)
cdf(Z, 0.0), cdf(Z1, 0.0)
cdf(Z, 1.0), cdf(Z1, 1.0)
minimum(Z1), maximum(Z1)
extrema(Z1)
insupport(Z1, [-2.1, -0.3, 1.4])
rZ1 = rand(Z1, 10_000);
extrema(rZ1)
quantile(Z1, 0.75), quantile(rZ1, 0.75)

# Algunas funciones pudieran no estar implementadas para funciones truncadas
# como: mean, mode, var, std y entropy

Z2 = truncated(Z, lower = 1.0)
extrema(Z2)

Z3 = truncated(Z, upper = 0.0)
extrema(Z3)

Z4 = truncated(Z, 0, Inf)
extrema(Z4)



### Modelos univariados censurados
### https://juliastats.org/Distributions.jl/stable/censored/ 

# `censored`

@doc censored

P = Poisson(4.0)
extrema(P)
insupport(P, [1, 3, 7])
pdf.(P, collect(0:7))
P1 = censored(P, 2, 6)
minimum(P1)
maximum(P1)
typeof(minimum(P1))
extrema(P1)
insupport(P1, [1, 3, 7])
pdf.(P1, collect(0:7))
cdf(P, 2) == cdf(P1, 2) == pdf(P1, 2) # true, como era de esperarse
cdf(P, 5) == cdf(P1, 5) # true, como era de esperarse
cdf(P, 6) < cdf(P1, 6) == 1.0 # true, como era de esperarse
pdf(P1, 6) - ccdf(P, 5) # casi iguales, aunque teóricamente son iguales


### Modelos univariados mezclados
### https://juliastats.org/Distributions.jl/stable/mixture/ 

@doc MixtureModel

w = [0.2, 0.5, 0.3]
M1 = Normal(2,1)
M2 = Gamma(3, 5)
M3 = Pareto(4, 1)
M = MixtureModel([M1, M2, M3], w)
propertynames(M)
M.components
components(M)
M.prior
probs(M)
params(M)
dump(M)
Distributions.component_type(M)
pdf(M, -1.0) == w[1]*pdf(M1, -1.0) # true
pdf(M, 2.0) == sum(w .* [pdf(M1, 2.0), pdf(M2, 2.0), pdf(M3, 2.0)]) # true
mean(M) == sum(w .* mean.([M1, M2, M3])) # true 
var(M)
extrema(M)
median(M)
cdf(M, median(M))
quantile(M, 0.5)
rM = rand(M, 10_000);
median(rM)
mean(rM), mean(M)

Q = MixtureModel([Poisson(100.5), Bernoulli(0.2)])
rand(Q, 100)


### Estadísticos de orden
### https://juliastats.org/Distributions.jl/stable/order_statistics/ 

## `OrderStatistic`: Un solo estadístico de orde a la vez

@doc OrderStatistic

G = Gamma(2,3)
k = 2
n = 10
rG = zeros(100_000);
for m ∈ 1:length(rG)
    rG[m] = sort(rand(G, n))[k]
end
median(rG), quantile(rG,0.75) - quantile(rG,0.25)
O1 = OrderStatistic(G, n, k)
median(O1), quantile(O1,0.75) - quantile(O1,0.25)

NB = NegativeBinomial(15, 0.6)
k = 8
n = 10
rNB = zeros(100_000);
for m ∈ 1:length(rNB)
    rNB[m] = sort(rand(NB, n))[k]
end
median(rNB), quantile(rNB,0.75) - quantile(rNB,0.25)
O2 = OrderStatistic(NB, n, k)
median(O2), quantile(O2,0.75) - quantile(O2,0.25)

## `JointOrderStatistics`: Distribución conjunta de estadísticos de orden

O3 = JointOrderStatistics(Cauchy(1,2), 10, [3,5,8])
supertype(typeof(O3))
rand(O3, 10)
