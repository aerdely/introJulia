### Paquete `StatsBase`: Distancias entre arreglos
### Dr. Arturo Erdely

### Basado en: https://juliastats.org/StatsBase.jl/stable/  

using StatsBase


a = sort(randn(100));
b = sort(randn(100));


## Distancia L1

# ejecutar 2 veces
@time L1dist(a, b) # más eficiente en velocidad y memoria
@time sum(abs, a - b)
@time sum(abs.(a - b)) # el más ineficiente


## Distancia L2

L2dist(a, b)
sqrt(sum(abs2, a - b))


## Distancia L2 al cuadrado

sqL2dist(a, b)
sum(abs2, a - b)


## Distancia L-infinito

Linfdist(a, b)
maximum(abs.(a - b))


## Medidas de desviación
#  meanad  maxad  msd  rmsd

meanad(a, b)
mean(abs, a - b)

maxad(a, b)
maximum(abs.(a - b))

msd(a, b)
mean(abs2, a - b)

rmsd(a, b)
sqrt(msd(a, b))
