### Estadística 
### Dr. Arturo Erdely


# Requiere haber instalado previamente los paquetes: 
# Plots, Distributions, CSV, DataFrames, StatsPlots y StatsBase

# Los paquetes `Random` y `Statistics` no requieren instalación
# porque forman parte de la biblioteca estándar de Julia

begin
    using Distributions, StatsBase, StatsPlots
    using Random, Statistics
end


## Análisis exploratorio-numérico de datos ##

## Paquete `Statistics`
#  mean  median  middle  std  var  quantile  cor  cov

begin
    X = Normal(1, 2)
    simX = rand(X, 10_000)
    res1 = (media = mean(simX), mediana = median(simX),
            desv = std(simX), varianza = var(simX))
    println("Tupla de resultados: ", res1)
    println("Elemento de tupla: ", res1.mediana)
end

begin
    res2 = (cuantil50 = quantile(simX, 0.5), puntomedio = middle(simX))
    println("Tupla de cuantil 0.5 y punto medio: ", res2)
    println("Punto medio de valores mínimo y máximo:\n", extrema(simX), "  ", mean(extrema(simX)))
end

begin
    XY = MvNormal([-2, 4], [2^2 -0.5*2*3; -0.5*2*3 3^2])
    simXY = rand(XY, 10_000)
    println("Resultado de simulación:")
    display(simXY)
end

begin
    res3 = (covarianza = cov(simXY[1, :], simXY[2, :]),
            corrPearson = cor(simXY[1, :], simXY[2, :]))
    println("Tupla de covarianza y correlación de Pearson:\n", res3)
    println("Solo la correlación de Pearson: ", res3.corrPearson)
end

begin
    colsXY = transpose(simXY)
    println("Transpuesta de simulación:")
    display(colsXY)
    res4 = (covarianza = cov(colsXY), corrPearson = cor(colsXY))
    println("\nTupla de matrices de covarianza y correlación:\n", res4)
    println("Solo la matriz de correlación: ", res4.corrPearson)
    println("\nUsando `display` en lugar de `println`:\n")
    display(res4.corrPearson)
end


## Paquete `StatsBase`
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
D = collect(1.1:0.1:100.0)
@time res8 = geomean(D)
@time res9 = prod(D)^(1/length(D)) # problema numérico de overflow
@time res10 = exp(mean(log.(D)))

# skewness  kurtosis  mode  modes  summarystats

Z = randn(10_000)
(skewness(Z), kurtosis(Z))

resumen = summarystats(Z)
typeof(resumen)
println(resumen)

D = [1, 2, 1, 1, 3, 1, 1]
mode(D)
modes(D)

E = [2, 2, 1, 1, 2, 1, 3]
mode(E)
modes(E)

F = [1, 2, 3, 4, 5]
mode(F)
modes(F)
allunique(F)

# counts  proportions (solo de números enteros)

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

# countmap  proportionmap (sobre objetos arbitrarios)

D = [0.9, 0.25, 0.25, 0.6, 0.6, 0.6, 0.3, 0.3, 0.3, 0.3]
c = countmap(D)
p = proportionmap(D)
keys(c), values(c), values(p)

# tabla de frecuencias absolutas y relativas:
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

# o bien mediante el paquete `DataFrame` (previamente instalado)
using DataFrames 
tabla = DataFrame(valores = valor[orden], frecuencia = frec[orden], proporción = prop[orden])

# ordinalrank  competerank  denserank
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
end;
hcat(D, or)
hcat(D, cr)
hcat(D, dr)

# corspearman  corkendall
X = rand(1_000)
Y = X .^ 10
(corspearman(X, Y), corkendall(X, Y), cor(X, Y))
(corspearman(log.(X), log.(Y)), corkendall(log.(X), log.(Y)), cor(log.(X), log.(Y)))
corspearman(rand(10, 2))

# ver manual de `StatsBase` --> https://juliastats.org/StatsBase.jl/stable/ 


## Paquete `StatsPlots`

# bar
B = [10, 2, 5, 1, 3]
bar(B)

bar(B, color = :yellow, legend = false)

E = collect('A':'Z')[1:length(B)]
bar(E, B, color = :yellow, legend = false, yticks = 0:10, title = "Barritas")

gh = bar(E, B, color = :yellow, legend = false, xticks = 0:10, title = "Barritas",
         orientation = :horizontal)

bar(E, B, color = :yellow, legend = false, yticks = 0:10, title = "Barritas",
    fillcolor = [:yellow, :green, :red, :blue, :gray])

bar(E, B, color = :yellow, legend = false, yticks = 0:10, title = "Barritas",
    fillcolor = [:yellow, :green, :red, :blue, :gray], 
    fillalpha = [0.2, 0.4, 0.6, 0.8, 1.0])

gh


# histogram  density 
x = randn(1_000) # simulación de una distribución Normal(0,1)
histogram(x)

histogram(x, bins = collect(-5.0:0.5:5.0), color = :pink, legend = false)

histogram!(title = "histograma", xlabel = "x", ylabel = "frecuencia")

# re-escalar para que el área total de las barras sume 1
begin
    histogram(x, bins = collect(-5.0:0.5:5.0), color = :pink, label = "observado",
              normalize = true, xlabel = "x", ylabel = "densidad de probabilidades")
    ϕ(z) = exp(-z^2 / 2) / √(2π) # función de densidad de una Normal(0,1)
    density!(x, lw = 3, color = :red, label = "densidad estimada")
    y = range(-5.0, 5.0, length = 1_000)
    plot!(y, ϕ.(y), lw = 2, color = :blue, label = "densidad teórica")
end


# histogram2d 
begin
    μ = [-2.0, 3.0]
    ρ = -0.5
    Σ = [1.0 ρ; ρ 1.0]
    XY = MvNormal(μ, Σ)
    simXY = rand(XY, 30_000)
    histogram2d(simXY[1, :], simXY[2, :], legend = false)
end

histogram2d!(size = (500, 500), xlabel = "X", ylabel = "Y", title = "Histograma 2D")


# marginalhist
marginalhist(simXY[1, :], simXY[2, :], legend = false, size = (500, 500))


# marginalscatter
marginalscatter(simXY[1, 1:500], simXY[2, 1:500], legend = false, size = (500, 500))


# marginalkde
marginalkde(simXY[1, :], simXY[2, :], legend = false, size = (500, 500))

marginalkde(simXY[1, :], simXY[2, :], legend = false, size = (500, 500), levels = 20)


# corrplot  cornerplot
begin
    μ = [-3.0, 1.0, 7.0]
    σ = [1.0, 2.0, 3.0]
    ρ12 = -0.5
    ρ13 = 0.0
    ρ23 = 0.8
    Σ = [   σ[1]^2      σ[1]*σ[2]*ρ12 σ[1]*σ[3]*ρ13;
          σ[1]*σ[2]*ρ12      σ[2]^2    σ[2]*σ[3]*ρ23;
          σ[1]*σ[3]*ρ13  σ[2]*σ[3]*ρ23     σ[3]^2   ]
    XYZ = MvNormal(μ, Σ)
    simXYZ = rand(XYZ, 1_000)
    corrplot(transpose(simXYZ), size = (600, 500), label = ["X", "Y", "Z"])
end

cornerplot(transpose(simXYZ), size = (600, 500), label = ["X", "Y", "Z"])

cornerplot(transpose(simXYZ), size = (600, 500), label = ["X", "Y", "Z"], compact = true)


# violin  boxplot  dotplot
begin
    X = simXYZ[1, 1:100]
    Y = simXYZ[2, 1:100]
    Z = simXYZ[3, 1:100]
    violin(["X"], X, legend = false)
    violin!(["Y"], Y)
    violin!(["Z"], Z)
end

begin
    boxplot(["X"], X, legend = false)
    boxplot!(["Y"], Y)
    boxplot!(["Z"], Z)
end

begin
    dotplot(["X"], X, legend = false)
    dotplot!(["Y"], Y)
    dotplot!(["Z"], Z)
end
