#### Paquete `Distributions`: Modelos multivariados 
#### Dr. Arturo Erdely

#### Basado en: https://juliastats.org/Distributions.jl/stable/ 


using Distributions


#= 
    Estadísticos usuales
    --------------------
    mean  var  cov  cor  entropy  minimum  maximum  extrema  median  mode

    Cálculo de probabilidades
    -------------------------
    insupport  pdf  cdf  params

    Muestreo
    --------
    rand  rand!
=#

### Distribuciones
### https://juliastats.org/Distributions.jl/stable/multivariate/#Distributions 

## Multinomial

@doc Multinomial

X = Multinomial(10, [0.2, 0.7, 0.1])
propertynames(X)
X.n
X.p
params(X)
dump(X)
insupport(X, [2,7,1])
pdf(X, [2,7,1])
insupport(X, [2,7,3])
pdf(X, [2,7,3])
mean(X)
var(X)
cov(X)
cor(X)
rX = rand(X, 10_000)
cor(transpose(rX))
mean(eachcol(rX))

Multinomial(10, 3)


## Normal multivariada

@doc MvNormal

μ = [-3.5, 1.2, 4.8] # vector de medias
ρ = [1.0 -0.3 -0.5; -0.3 1.0 0.4; -0.5 0.4 1.0 ] # matriz de correlaciones de Pearson
σ = [1.5, 0.7, 2.8] # vector de desviaciones estándar
Σ = (σ * transpose(σ)) .* ρ # matriz de varianza-covarianza
N = MvNormal(μ, Σ)
params(N)
propertynames(N)
N.μ
N.Σ
dump(N)
mean(N)
mode(N)
modes(N)
minimum(N), maximum(N)
extrema(N)
var(N)
cov(N)
cor(N)
pdf(N, μ)
pdf(N, μ + 0.1 * rand(3))
rN = rand(N, 10_000)
cor(transpose(rN))
mean(eachcol(rN))


## LogNormal multivariada

@doc MvLogNormal

L = MvLogNormal(MvNormal(μ, Σ))
propertynames(L)
L.normal
params(L)
mean(L)
var(L)
cov(L)
cor(L)
rL = rand(L, 10_000)
cor(transpose(rL))
mean(eachcol(rL))


## Dirichlet

@doc Dirichlet

α = [1.3, 0.8, 2.4, 5.7]
D = Dirichlet(α)
params(D)
propertynames(D)
D.alpha 
D.alpha0
sum(α)
D.lmnB
log(prod(Distributions.gamma.(α)) / Distributions.gamma(sum(α)))
mean(D)
var(D)
cov(D)
cor(D)
rD = rand(D, 10_000)
cor(transpose(rD))
mean(eachcol(rD))
pdf(D, mean(D))


### Modelos multivariados mezclados
### https://juliastats.org/Distributions.jl/stable/mixture/

M = MixtureModel([N, L], [0.2, 0.8])
mean(M), 0.2.*mean(N) + 0.8.*mean(L)
rand(M, 10)
