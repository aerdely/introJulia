#### Paquete `Distributions`: Introducción a Distribuciones de Probabilidad en Julia
#### Dr. Arturo Erdely

#### Basado en: https://juliastats.org/Distributions.jl/stable/ 

### Instalar paquete

import Pkg; Pkg.add("Distributions")


### Usar el paquete

using Distributions

@doc Distributions



### Introducción

## Definir un modelo de probabilidad

typeof(Normal)
fieldnames(Normal)
dump(Normal)

Z = Normal()
typeof(Z)

X = Normal(-3, 5)
propertynames(X)
dump(X)
X.μ
X.σ 
p = params(X)
typeof(p)


## Operaciones con modelos de probabilidad (métodos)

begin
    media(x) = sum(x) / length(x)
    varianza(x) = sum((x .- media(x)) .^2) / (length(x) - 1)
end;

mean(X) # media teórica
# nótese que el paquete `Distributions` agrega métodos a la función `mean` del paquete `Statistics`
methods(mean)

rX = rand(X, 10_000) # simular a partir del modelo de probabilidad de X
# nótese que el paquete `Distributions` agrega métodos a la función `rand` del módulo `Base`
methods(rand)

media(rX) # media muestral calculada con la fórmula definida al inicio
mean(rX) # `mean` del paquete `Statistics` importado por `Distributions`
media(X) # error porque `media` no tiene definido un método para este tipo de argumento

var(X) # varianza teórica
var(rX) # varianza muestral del paquete `Statistics` importado por `Distributions`
varianza(rX) # varianza muestral calculada con la fórmula definida al inicio

std(X) # desviación estándar teórica
√(varianza(rX)) # desviación estándar muestral | \sqrt + [tab]

median(X) # mediana teórica
sum(sort(rX)[5_000:5001]) / 2 # mediana muestral calculada directamente
median(rX) # calculada con el paquete `Statistics` importado por `Distributions`

quantile(X, 0.90) # cuantil 0.9 teórico
sort(rX)[9_000] # cuantil 0.9 muestral 
quantile(rX, 0.9) # calculado con el paquete `Statistics` importado por `Distributions`

quantile.(X, [0.5, 0.9]) # varios cuantiles teóricos

maximum(X) # teórico
minimum(X) # teórico
extrema(X)
modes(X) # vector de todas las modas (teóricas)
mode(X) # la primera moda, de menor a mayor
skewness(X)
kurtosis(X)


## Función de densidad de probabilidades

X
pdf(X, -3.0)
pdf.(X, [-3.1, -3.0, -2.9])

## Función de distribución de probabilidades

X
cdf(X, X.μ)
cdf.(X, X.μ .+ X.σ.*[- 1.96, 1.96])
diff(cdf.(X, X.μ .+ X.σ.*[- 1.96, 1.96]))

## Función de cuantiles

quantile(X, 0.5)
q = quantile.(X, [0.025, 0.975])
cdf.(X, q)

## Ajuste de un modelo con base en datos (máxima verosimilitud)

G = Gamma(2, 3)
rG = rand(G, 10_000)
ajusteG = fit(Gamma, rG)
typeof(ajusteG)
params(ajusteG) 
rand(ajusteG, 10)



### Jerarquía de tipos

## `Sampleable` (tipo abstracto)

parentmodule(Sampleable)
Distributions.Sampleable === Sampleable
typeof(Sampleable)
isabstracttype(Sampleable)
supertype(Sampleable)
subtypes(Sampleable)
propertynames(Sampleable)
dump(Sampleable)

# `VariateForm`

parentmodule(VariateForm)
Distributions.VariateForm === VariateForm
typeof(VariateForm)
isabstracttype(VariateForm)
supertype(VariateForm)
subtypes(VariateForm)

isabstracttype(ArrayLikeVariate)
supertype(ArrayLikeVariate)
subtypes(ArrayLikeVariate)

isabstracttype(CholeskyVariate)
supertype(CholeskyVariate)
subtypes(CholeskyVariate)

# `ValueSupport`

typeof(ValueSupport)
isabstracttype(ValueSupport)
supertype(ValueSupport)
subtypes(ValueSupport)

typeof(Discrete)
isabstracttype(Discrete)
isconcretetype(Discrete)
supertype(Discrete)
subtypes(Discrete)

typeof(Continuous)
isabstracttype(Continuous)
isconcretetype(Continuous)
supertype(Continuous)
subtypes(Continuous)

#= Métodos
    Base.length  Base.size  Distributions.nsamples
    Base.eltype  Base.rand  Random.rand!
=# 


## `Distribution`

parentmodule(Distribution)
Distributions.Distribution === Distribution
typeof(Distribution)
isabstracttype(Distribution)
propertynames(Distribution)
dump(Distribution)
supertype(Distribution)

# todos los modelos probabilísticos

subtypes(Distribution) 
println(subtypes(Distribution))
