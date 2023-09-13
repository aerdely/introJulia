### Paquete `StatsBase`: Histograma y distribución empírica
### Dr. Arturo Erdely

### Basado en: https://juliastats.org/StatsBase.jl/stable/  

using StatsBase


## Histogramas

# El tipo `Histogram`

@doc Histogram

typeof(Histogram)
supertypes(Histogram)
fieldnames(Histogram)
propertynames(Histogram)
dump(Histogram)
methods(Histogram)

# Crear histogramas con `fit`

@doc fit

fit(Histogram, [2.0], 1:3, closed = :left)
fit(Histogram, [2.0], 1:3, closed = :right)

datos = [0.3, 1.0, 1.1, 1.2, 5.3]
h1 = fit(Histogram, datos)
typeof(h1)
propertynames(h1)
h1.edges # marcas de clase
h1.weights # conteos por clase
h1.closed # clase de intervalo: [a, b) cerrado por la izquierda
h1.isdensity # falso
dump(h1)

marcas = [0.0, 1.1, 6.0]
h2 = fit(Histogram, datos, marcas)
h2.weights
h2.isdensity

# convertir a densidades: `normalize`

using LinearAlgebra

h3 = normalize(h2, mode = :pdf)
h3.isdensity
diff(marcas) ⋅ h3.weights # = 1.0, como era de esperarse
sum(diff(marcas) .* h3.weights)

datos2 = randn(1_000);
summarystats(datos2)
fit(Histogram, datos2)
fit(Histogram, datos2, nbins = 5)
marcas = range(minimum(datos2), maximum(datos2), length = 11)
h4 = normalize(fit(Histogram, datos2, marcas), mode = :pdf)
length(h4.weights)
diff(marcas) ⋅ h4.weights # = 1.0, como era de esperarse

# Histograma ponderado

datos = [0.3, 1.0, 1.1, 1.2, 5.3];
marcas = [0.0, 1.1, 6.0];
pesos1 = weights(repeat([1], length(datos)))
pesos2 = weights([5, 1, 1, 1, 100])
h5 = fit(Histogram, datos, marcas, closed = :right)
# es lo mismo que:
h6 = fit(Histogram, datos, pesos1, marcas, closed = :right)
h5 == h6
# ahora con ponderación no uniforme:
h7 = fit(Histogram, datos, pesos2, marcas, closed = :right)

# Histogramas multivariados

x = randn(1_000);
y = rand(1_000);
h8 = fit(Histogram, (x, y))
h8.weights
sum(h8.weights) # igual al tamaño de muestra, como era de esperarse

h9 = fit(Histogram, (x, y), nbins = 5)
h9.weights
sum(h9.weights)

h9.edges
xmin, xmax = extrema(x)
ymin, ymax = extrema(y)
m = 31
marcas = (range(xmin - 0.01*abs(xmin), xmax + 0.01*abs(xmax), length = m),
          range(ymin - 0.01*abs(ymin), ymax + 0.01*abs(ymax), length = m)
)
h10 = fit(Histogram, (x, y), marcas, closed = :right)
h10.weights
sum(h10.weights)
h11 = normalize(h10, mode = :pdf)
h11.weights
propertynames(marcas[1])
dump(marcas[1])
sum(marcas[1].step.hi * marcas[2].step.hi * h11.weights) # aprox 1.0, como era de esperarse
