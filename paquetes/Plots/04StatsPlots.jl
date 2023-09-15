### Introducción al paquete `StatsPlots` por medio de ejemplos
### Dr. Arturo Erdely

### Basado en: https://docs.juliaplots.org/stable/generated/statsplots/ 

### Versión: 0.15.6

using StatsPlots # tarda unos segundos en cargar porque carga además `Plots`


## Densidad univariada

# re-escalar para que el área total de las barras sume 1
begin
    x = randn(1_000) # simulación de una distribución Normal(0,1)
    histogram(x, bins = collect(-5.0:0.5:5.0), color = :pink, label = "observado",
              normalize = true, xlabel = "x", ylabel = "densidad de probabilidades")
    ϕ(z) = exp(-z^2 / 2) / √(2π) # función de densidad de una Normal(0,1)    
    y = range(-5.0, 5.0, length = 1_000)
    plot!(y, ϕ.(y), lw = 2, color = :blue, label = "densidad teórica")
end

density!(x, lw = 3, color = :red, label = "densidad estimada")


## Densidades bivariadas

using Distributions
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


# `marginalkde` (es un poco tardado el proceso)

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


## violin  boxplot  dotplot

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

begin
    violin(["X" "Y" "Z"], [X Y Z], legend = false)
    boxplot!(["X" "Y" "Z"], [X Y Z])
    dotplot!(["X" "Y" "Z"], [X Y Z])
end

boxplot(["X" "Y" "Z"], [X Y Z], legend = false, permute = (:x, :y))


## Gráficas de barras agrupadas

matriz = [3 6 12;
     8 4 2;
     1 20 3;
     5 5 5
]

groupedbar(["Fila 1", "Fila 2", "Fila 3", "Fila 4"], matriz,
           bar_position = :stack, bar_width = 0.7,
           label = ["Columna 1" "Columna 2" "Columna 3"]
)

groupedbar(["Fila 1", "Fila 2", "Fila 3", "Fila 4"], matriz,
           bar_position = :dodge, bar_width = 0.3,
           label = ["Columna 1" "Columna 2" "Columna 3"]
)
