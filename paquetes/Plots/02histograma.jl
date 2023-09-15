### Histogramas, barras, pastel y mapa de calor con el paquete `Plots`
### Dr. Arturo Erdely

### Basado en: https://docs.juliaplots.org/stable/ 


using Plots 


## Histograma univariado

x = randn(1_000); # simulación de una distribución Normal(0,1)
histogram(x)

histogram(x, nbins = 6) # aproximadamente 6, no necesariamente exacto 6

h = histogram(x, bins = collect(-5.0:0.5:5.0), color = :pink, legend = false)

histogram!(title = "histograma", xlabel = "x", ylabel = "frecuencia")

typeof(h)
histogram(x)
plot(h)
histogram(x)
display(h)

# re-escalar para que el área total de las barras sume 1

begin
    histogram(x, bins = collect(-5.0:0.5:5.0), color = :pink, label = "observado",
              normalize = true, xlabel = "x", ylabel = "densidad de probabilidades")
    ϕ(z) = exp(-z^2 / 2) / √(2π) # función de densidad de una Normal(0,1)
    y = range(-5.0, 5.0, length = 1_000)
    plot!(y, ϕ.(y), lw = 2, color = :blue, label = "densidad teórica")
end

# modificar el ancho de barra

histogram(x, legend = false)
histogram(x, legend = false, bar_width = 0.1)
histogram(x, legend = false, bar_width = 0.5)
histogram(x, legend = false, bar_width = 1.0)
histogram(x, legend = false, bar_width = 2.0)

# rotaciones

histogram(x, legend = false)
histogram(x, legend = false, permute = (:x, :y))
histogram(x, legend = false)
yaxis!(:flip)
histogram(x, legend = false, permute = (:x, :y))
xaxis!(:flip)

# formatos de histograma: barras, puntos y escalonado

begin
    p1 = histogram(x, title = "histogram")
    p2 = barhist(x, title = "barhist")
    p3 = scatterhist(x, title = "scatterhist")
    p4 = stephist(x, title = "stephist")
    plot(p1, p2, p3, p4, layout = (2, 2), legend = false)
end


## Histograma bivariado

begin
    x = randn(10_000)
    y = randn(10_000)
    histogram2d(x, y)
end

begin
    title!("Histograma bivariado")
    xaxis!("x")
    yaxis!("y")
end

begin
    w = exp.(x)
    histogram2d(x, y, bins = (40, 20), normalize = :pdf)
    xlabel!("x")
    ylabel!("y")
end

begin
    w = exp.(x)
    histogram2d(x, y, bins = (40, 20), normalize = :pdf, show_empty_bins = true)
    xlabel!("x")
    ylabel!("y")
end

begin
    w = exp.(x)
    histogram2d(x, y, bins = (40, 20), normalize = :pdf, color = :plasma, show_empty_bins = true)
    xlabel!("x")
    ylabel!("y")
end

begin
    w = exp.(x)
    histogram2d(x, y, bins = (40, 20), normalize = :pdf, color = :turbo, show_empty_bins = true)
    xlabel!("x")
    ylabel!("y")
end

begin
    w = exp.(x)
    histogram2d(x, y, bins = (40, 20), normalize = :pdf, color = :grayC, show_empty_bins = true)
    xlabel!("x")
    ylabel!("y")
end


## Gráfica de barras

B = [10, 2, 5, 1, 3]
bar(B)

bar(B, color = :yellow, legend = false)

E = collect('A':'Z')[1:length(B)]
bar(E, B, color = :yellow, legend = false, yticks = 0:10, title = "Barritas")

bar(E, B, color = :yellow, legend = false, yticks = 0:10, title = "Barritas",
    fillcolor = [:yellow, :green, :red, :blue, :gray]
)

bar(E, B, color = :yellow, legend = false, yticks = 0:10, title = "Barritas",
    fillcolor = [:yellow, :green, :red, :blue, :gray], 
    fillalpha = [0.2, 0.4, 0.6, 0.8, 1.0]
)

bar(E, B, color = :yellow, legend = false, yticks = 0:10, title = "Barritas",
    fillcolor = [:yellow, :green, :red, :blue, :gray], 
    fillalpha = [0.2, 0.4, 0.6, 0.8, 1.0], permute = (:x, :y)
)

bar(E, B, color = :yellow, legend = false, yticks = 0:10, title = "Barritas",
    fillcolor = [:yellow, :green, :red, :blue, :gray], 
    fillalpha = [0.2, 0.4, 0.6, 0.8, 1.0], permute = (:x, :y), bar_width = 0.5
)

bar(E, B, color = :yellow, legend = false, yticks = 0:10, title = "Barritas",
    fillcolor = [:yellow, :green, :red, :blue, :gray], 
    fillalpha = [0.2, 0.4, 0.6, 0.8, 1.0], permute = (:x, :y), bar_width = 1.0
)

bar(E, B, color = :yellow, legend = false, yticks = 0:10, title = "Barritas",
    fillcolor = [:yellow, :green, :red, :blue, :gray], 
    fillalpha = [0.2, 0.4, 0.6, 0.8, 1.0], permute = (:x, :y), bar_width = 1.5
)

xaxis!(:flip)
yaxis!(:flip)


## Gráfica de pastel

x = ["Python", "R", "Julia", "otros"]
y = [0.5, 0.3, 0.05, 0.15]
pie(x, y)
pie(x, y, legend = :outerbottom)
pie(x, y, legend = :outerbottom, legendcolumns = 4, title = "Análisis de datos")
pie(x, y, legend = :outerbottom, legendcolumns = 4, title = "Análisis de datos",
    color = [:blue, :lightblue, :violet, :gray]
)


## Mapa de calor

z = [1 0 0 1 1; 
     0 1 2 1 1;
     1 2 3 2 2;
     1 1 2 1 1;
     0 0 1 1 0
]

heatmap(z)
yaxis!(:flip)

x = [10, 20, 30, 40, 50];
y = [100, 200, 300, 400, 500];
heatmap(x, y, z)

heatmap(x, y, z, color = :inferno)

heatmap(x, y, z, color = :thermal)

heatmap(x, y, z, color = :plasma)

heatmap(x, y, z, color = :turbo)

heatmap(x, y, z, color = :grayC)
