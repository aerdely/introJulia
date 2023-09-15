### Atributos gráficos del paquete `Plots`
### Dr. Arturo Erdely

### Basado en: https://docs.juliaplots.org/stable/ 


using Plots 


plotattr(:Plot)
plotattr(:Series)
plotattr(:Subplot)
plotattr(:Axis)


## Atributos de `Plot`

plotattr(:Plot) # lista de Atributos

# ejemplo: dimensiones de la gráfica
plotattr("size")
x = randn(10)
plot(x)
plot(x, size = (600, 400)) # valor por defecto
plot(x, size = (200, 200))

# ejemplo: color de fondo
plotattr("background_color")
plot(x, bg = :blue)


## Atributos de `Series`

plotattr(:Series) # lista de atributos

# ejemplo: color
plotattr("seriescolor")
plot(x, color = :red)
scatter(x, color = :green)


## Atributos de `Subplot`

plotattr(:Subplot) # lista de atributos

# ejemplo: rotar la etiqueta
plotattr("legend_font_rotation")
plot(x, legend_font_rotation = 45.0, label = "Hola")

# ejemplo: tamaño de letra del título de la gráfica
plotattr("titlefontsize")
plot(x, title = "Título")
plot(x, title = "Título", titlefontsize = 14) # valor por defecto
plot(x, title = "Título", titlefontsize = 28)


## Atributos de `Axis`

plotattr(:Axis) # lista de atributos

# ejemplo: rotación de etiquetas en ejes
plotattr("rotation")
x = rand(10); y = rand(10);
scatter(x, y)
scatter(x, y, rotation = 90)

# ejemplo: invertir el orden de los datos en un eje
plotattr("flip")
scatter(x, y)
yaxis!(flip = true)

# ejemplo: ocultar los ejes
plotattr("showaxis")
plot(x, y, legend = false)
plot(x, y, legend = false, showaxis = false)

# ejemplo: ocultar la rejilla
plotattr("grid")
plot(x, y, legend = false, showaxis = false, grid = false)


## Ejemplos de atributos simultáneos

x = rand(30);
y = randn(30);
scatter(x, y, legend = false)
scatter(x, y, legend = false,
        xlims = (-0.2, 1.2),
        xticks = range(0.0, 1.0, step = 0.1),
        xflip = true;
        xtickfont = font(6, "Courier")
)

plot(y,
    seriestype = :steppre,
    linestyle = :dot,
    arrow = :arrow,
    linealpha = 0.5,
    linewidth = 4,
    linecolor = :red
)

plot(y,
    fillrange = 0,
    fillalpha = 0.5,
    fillcolor = :red
)

scatter(y,
    markershape = :hexagon,
    markersize = 20,
    markeralpha = 0.6,
    markercolor = :green,
    markerstrokewidth = 3,
    markerstrokealpha = 0.2,
    markerstrokecolor = :black,
    markerstrokestyle = :dot
)

scatter(y, thickness_scaling = 2)

x = randn(100);
y = @. x + 0.3*randn();
scatter(x, y, legend = false)
scatter(x, y, legend = false, smooth = true)


## Lista de colores

# consultar: https://juliagraphics.github.io/Colors.jl/stable/namedcolors/

p = palette(:tab10)
dump(p)
p
p.colors[[1,3,4]]

palette([:purple, :green], 7)
p = palette([:yellow, :black], 15)
p.colors[[1, 7, 12]]
