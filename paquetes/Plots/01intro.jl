### Introducción al paquete `Plots` por medio de ejemplos
### Dr. Arturo Erdely

### Basado en: https://docs.juliaplots.org/stable/ 

### Versión: 1.39.0

using Plots # tarda unos segundos en cargar, es un paquete grande


#=
  El primer gráfico tarda un poquito porque al mismo tiempo
  se precompila el paquete, pero a partir del segundo gráfico
  ya es más veloz.
=#

@time plot([1, 4, 2, 5, 3]) # primera vez

@time plot([5, 1, 4, 2, 3]) # segunda vez en adelante


## Funciones de una variable

begin
     x = range(0, 2π, length = 1_000)
     y = sin.(x)
     plot(x, y)
end

plot(x, y, lw = 3, legend = false) # `lw` significa line width

plot(x, y, lw = 3, color = :red, legend = false)


# agregar elementos a la última gráfica: comandos con !

begin
     xaxis!("ángulo en radianes")
     yaxis!("función seno")
     title!("Mi primera gráfica en Julia")
end

begin
     z = cos.(x)
     plot!(x, z, color = :blue, lw = 3)
     yaxis!("funciones seno y coseno")
end

begin
     plot(x, y, lw = 3, color = :orange, label = "seno")
     xaxis!("ángulo en radianes")
     yaxis!("seno y coseno")
     title!("Funciones trigonométricas")
     plot!(x, z, lw = 3, color = :brown, label = "coseno")
end

begin
     plot(x, y, lw = 3, color = :orange, label = "seno", legend = (0.6, 0.9))
     xaxis!("ángulo en radianes")
     yaxis!("seno y coseno")
     title!("Funciones trigonométricas")
     plot!(x, z, lw = 3, color = :brown, label = "coseno")
end

begin
     plot(x, y,
          xlim = (-0.5, 7.0), ylim = (-1.5, 1.5),
          lw = 3,
          color = :orange,
          label = "seno",
          legend = (0.6, 0.9)
     )
     xaxis!("θ = ángulo en radianes")
     yaxis!("seno y coseno de θ")
     title!("Funciones trigonométricas")
     plot!(x, z, lw = 3, color = :brown, label = "coseno")
end

current() # vuelve a crear la última gráfica

plot!(xticks = [0, 1, 2, 4, 6.5], yticks = -1.5:0.25:1.5)

plot!(legend = :bottom)
plot!(legend = :bottomleft)
plot!(legend = :bottomright)
plot!(legend = :top)
plot!(legend = :topleft)
plot!(legend = :topright)
plot!(legend = :left)
plot!(legend = :right)

plot!(legend = :outerbottom)
plot!(legend = :outerbottom, legendcolumns = 2)
plot!(legend = :outerbottomleft)
plot!(legend = :outerbottomleft, legendcolumns = 1)
plot!(legend = :outerleft)
plot!(legend = :outertopleft)
plot!(legend = :outertop)
plot!(legend = :outertop, legendcolumns = 2)
plot!(legend = :outertopright, legendcolumns = 1)
plot!(legend = :outerright)
plot!(legend = :outerbottomright)


# guardar gráfica en archivos .png y .pdf

savefig("pininos.png")

savefig("pininos.pdf")

# también:

png("pininos2") # y te ahorras esciribr la extensión

Plots.pdf("pininos2") # y te ahorras esciribr la extensión


# guardar gráfica en memoria y luego a archivo

P = current()
typeof(P)
sizeof(P)
Base.summarysize(P)
P
plot(P) 

savefig(P, "pininos3.png")


# Hasta el momento tenemos la siguiente sintaxis general:
# plot(datos...; parámetros...) # crear una nueva gráfica, recuperable mediante `current()`
# plot!(datos...; parámetros...) # agrega a la última gráfica, es decir `current()`
# plot!(g, datos...; parámetros...) # agrega a la gráfica `g`

begin
     θ = range(-5π, 5π, length = 1_000)
     y = sin.(θ) ./ θ
     plot(θ, y, lw = 3)
end

plot!(title = "ondulaciones", xlabel = "θ", ylabel = "sen θ / θ", legend = false)

plot!(xlims = (-20, 20), ylims = (-0.4, 1.2), xticks = round.(-5π:π:5π, digits = 1), yticks = -0.4:0.2:1.2)

yaxis!(:flip)


# cambio de escala

x = 10 .^ range(0, 4, length = 1_000)
y = @. 1/(1+x)
plot(x, y, label = "y = 1/(1+x)", legend = :outertop)
plot!(xscale = :ln)
plot!(yscale = :log10)
plot!(minorgrid = true)
plot!(xscale = :log10, yscale = :log10, minorgrid = true)
plot!(xlims = (1, 10^4), ylims = (10^(-5), 1), xlabel = "x", ylabel = "y")


# LaTeX

using LaTeXStrings

x = 10 .^ range(0, 4, length = 1_000)
y = @. 1/(1+x)
plot(x, y, label = L"y = \frac{1}{1+x}", legend = :outertop)
plot!(xscale = :log10, yscale = :log10, minorgrid = true)
plot!(xlims = (1, 10^4), ylims = (10^(-5), 1), xlabel = "x", ylabel = "y")


# matriz de gráficas

θ = range(-2π, 2π, length = 1000)
T = [sin.(θ) cos.(θ)]

plot(θ, T, layout = (2, 1), lw = 3, label = ["seno" "coseno"])

rand(10) # genera números pseudo-aleatorios de manera uniforme en el intervalo [0,1[

begin
     n = 1_000
     θ = range(0, 2π, length = n)
     x = sin.(θ)
     ε = rand(n)
     p1 = plot(θ, x, legend = false, lw = 3)
     p2 = scatter(θ, x .+ 0.1*ε, legend = false, markersize = 1)
     p3 = scatter(θ, x .+ ε, legend = false, markersize = 2)
     p4 = scatter(θ, x .+ 2*ε, legend = false, markersize = 3)
     plot(p1, p2, p3, p4, legend = false, layout = (2, 2))
end 


# unir puntos con líneas

begin
     x = rand(30)
     scatter(x, legend = false) # puntos
end

plot!(x) # agregar líneas

begin
     scatter(x, legend = false, markercolor = :red, markershape = :square)
     plot!(x, color = :green) 
end

#=
     lc: linecolor (color de línea)
     lw: linewidth (grosor de línea)
     la: linealpha (difuminación de color, escala [0,1])
     mc: markercolor
     ms: markersize
     ma: markeralpha
     markershape (forma)
=#

x = range(0, 10, length = 100);
y = sin.(x);
z = @. sin(x) + 0.1*rand();
plot(x, y, label = "y = sen x", color = :red)
plot(x, y, label = "y = sen x", color = :black, lw = 2)
scatter!(x, z, label = "datos", mc = :red, ms = 2, ma = 0.5)
plot!(legend = :top, xlabel = "x", ylabel = "y")
begin
     plot(x, y, label = "y = sen x", color = :black, lw = 2)
     scatter!(x, z, label = "datos", mc = :red, ms = 4, ma = 0.5)
     plot!(legend = :top, xlabel = "x", ylabel = "y")
end
begin
     plot(x, y, label = "y = sen x", color = :black, lw = 2)
     scatter!(x, z, label = "datos", mc = :red, ms = 4, ma = 0.1)
     plot!(legend = :top, xlabel = "x", ylabel = "y")
end
begin
     plot(x, y, label = "y = sen x", color = :blue, lw = 4, la = 0.2)
     scatter!(x, z, label = "datos", mc = :red, ms = 4, ma = 1.0, markershape = :square)
     plot!(legend = :top, xlabel = "x", ylabel = "y")
end


# agregar rectas y curvas

scatter(randn(100), randn(100), legend = false)
hline!([0], lw = 2, color = :red)
vline!([-0.5], lw = 4, color = :green)
Plots.abline!(0.5, -1, lw = 3)

scatter([1,2,3,4,5,6,7], [1,1,2,4,3,2,1], legend = false)
curves!([1,2,3,4,5,6,7], [1,1,2,4,3,2,1]) # Curva de Bezier


# agregar texto sobre la gráfica

plot(1:10, legend = false)
annotate!(2, 9, "@")
annotate!([(3, 9, "hola"), (3, 8, "mundo")])
scatter!([3], [7], ms = 2.0)
annotate!(3, 7, text("Julia", 8, 45.0, :bottom, :red))
annotate!(3, 7, text("Julia", 8, 45.0, :top, :green))
scatter!([4], [7], ms = 2.0)
annotate!(4, 7, text("Julia", 6, -45.0, :right, :blue))
annotate!(4, 7, text("Julia", 10, -45.0, :left, :orange))
annotate!([3,4], [2,3], ["(3,2)", "(4,3)"])


# gráficas en coordenadas polares

begin
     n = 1_000
     r = fill(1, n) # r = 1 (constante)
     θ = range(0, 2π, length = n)
     plot(θ, r, proj = :polar, legend = false, lw = 3)
     scatter!([θ[1]], [r[1]]) # inicio de la gráfica
end

# transformación de coordenadas polares a cartesianas

begin
     x = r .* cos.(θ)
     y = r .* sin.(θ)
     plot(x, y, legend = false, lw = 3, xlabel = "x", ylabel = "y")
     scatter!([x[1]], [y[1]]) # inicio de la gráfica
end

# para que no se deforme:

begin
     x = r .* cos.(θ)
     y = r .* sin.(θ)
     plot(x, y, legend = false, lw = 3, size = (400, 400), xlabel = "x", ylabel = "y")
     scatter!([x[1]], [y[1]]) # inicio de la gráfica
end

begin
     x = r .* cos.(θ)
     y = r .* sin.(θ)
     plot(x, y, legend = false, lw = 3, size = (700, 700), xlabel = "x", ylabel = "y")
     scatter!([x[1]], [y[1]]) # inicio de la gráfica
end


# otro ejemplo

begin
     θ = range(0, 2π, length = 1_000)
     a = 1
     b = 2
     r = a .+ b.*cos.(θ)
     plot(θ, r, proj = :polar, legend = false, lw = 3)
     scatter!([θ[1]], [r[1]]) # inicio de la gráfica
end

begin
     x = r .* cos.(θ)
     y = r .* sin.(θ)
     plot(x, y, lw = 3, legend = false)
     scatter!([x[1]], [y[1]]) # inicio de la gráfica
end

# corregimos deformación y agregamos etiquetas a los ejes:

plot!(size = (400, 400), xlabel = "x", ylabel = "y")


##  Gráficas 3D

# trayectorias en 3D

begin
     n = 10_000
     θ = range(0, 10π, length = n)
     x = cos.(θ)
     y = sin.(θ)
     z = θ .^ (1/3)
     plot(x, y, z, legend = false, lw = 3, xlabel = "x", ylabel = "y", zlabel = "z")
     scatter!(x[[1, n]], y[[1, n]], z[[1, n]]) # puntos de inicio y final de la trayectoria
end


# puntos en 3D

scatter3d([0,1,2,3], [0,1,4,9], [0,1,8,27], legend = false)
xaxis!("x"); yaxis!("y"); zaxis!("z")
scatter3d!([0], [4], [20], mc = :red)


# superficies en 3D

begin
     n = 100
     x = range(-2π, 2π, length = n)
     y = x
     z = zeros(n, n)
     f(x, y) = sin(x^2 + y^2)/(x^2 + y^2)
     for i ∈ 1:n, j ∈ 1:n
          z[i, j] = f(x[i], y[j])
     end
     # plot(x, y, f, st = :surface, xlabel = "x", ylabel = "y")
     surface(x, y, f, xlabel = "x", ylabel = "y")
end


# curvas/conjuntos de nivel

contour(x, y, z, xlabel = "x", ylabel = "y", size = (400, 400))

contour(x, y, z, xlabel = "x", ylabel = "y", size = (400, 400), fill = true)

contour(x, y, z, xlabel = "x", ylabel = "y", size = (400, 400), fill = false)

contourf(x, y, z, xlabel = "x", ylabel = "y", size = (400, 400))

# modificar la cantidad de niveles en la gráfica anterior:

contour(x, y, z, xlabel = "x", ylabel = "y", size = (400, 400), fill = true, levels = 5)


## Ejemplos de Emmett Boudreau
## Fuente: https://towardsdatascience.com/spruce-up-your-gr-visualizations-in-julia-88a964450a7

using Plots

# Using function we can return what backend we are in: 
begin
     println("Current Plots.jl Backend:")
     Plots.backend()
end

# And if it isn’t GR, you can set it to GR by doing:
# Plots.gr()

# The Basics
begin
x = rand(100); y = randn(100)
scatter(x,y,
    # title:
    title = "GR Scatter Plot",
    # X label:
    xlabel = "Random data",
    # Y label
    ylabel = "Random data",
    # Grid:
    grid = false,
    # Legend position
    legend = :bottomright,
    # Color of the marker
    color = :lightblue,
    # Marker stroke width and opacity
    markerstrokewidth = 4,
    markerstrokealpha = .75,
    # Marker stroke color
    markerstrokecolor = :lightblue,
    # Adjust out y ticks
    yticks = [-3,-1, 0, 2],
    # Our font options
    fontfamily = :Courier,xtickfontsize=7,ytickfontsize=9,
    ytickfont=:Courier,xtickfont = :Courier,titlefontsize=13,
    # We can also add annotations, super easily:
)
end

# Of course, the title is pretty simple, just set title equal to a string,
# relatively straight forward. We can also change the title’s font using:
# titlefont = :FontName
# titlefontsize = fontsize

# We can also set the font globally, of course I prefer to keep them in a 
# single instance, but it may be useful for some:
# gr(tickfont=font("serif"), titlefont=font("serif"))

begin
x = [1,2,3,4,5,6,7,8]
y = [3,4,5,6,7,8,9,10]
gr(bg = :whitesmoke)
plot(x,y,arrow = true,
    linewidth = 6,
    color = :pink,
    yticks = ([0,250000,500000,750000,100000]),
    grid = false, legend = :bottomright, label="Sample",
    title = "Price per square footage in NYC",
    xlabel = "Square Footage", ylabel = "Sale Price",
    fontfamily = :Courier, xtickfontsize=4, ytickfontsize=4,
    ytickfont = :Courier, xtickfont = :Courier, titlefontsize=10
)
end

begin
gr(leg = false, bg = :lightblue)
scatter(x, y, smooth = true,
title = "NYC Housing Pricing",arrow = true,
markershape = :hexagon,
    markersize = 3,
    markeralpha = 0.6,
    markercolor = :blue,
    markerstrokewidth = 1,
    markerstrokealpha = 0.0,
    markerstrokecolor = :black,
    linealpha = 0.5,
    linewidth = 5,
    linecolor = :orange,
    textcolor = :white,
xlabel = "Area", ylabel = "Pricing",
fontfamily = :Courier, grid = false)
end

begin
gr(leg = false, bg = :black)
l = @layout [  a{0.3w} [grid(3,3)
                         b{0.2h} ]]
plot(
    rand(200, 11),
    layout = l, legend = false, seriestype = [:bar :scatter :path], textcolor = :white,
    markercolor = :green, linecolor = :orange, markerstrokewidth = 0, yticks = [.5, 1],
    xticks = [0, 100, 200]
)
end

begin
p = plot([sin, cos], zeros(0), leg = false, linecolor = :white)
anim = Animation()
@gif for x = range(0, stop=10π, length=100)
         push!(p, x, Float64[sin(x), cos(x)])
         frame(anim)
     end
end


## Otro paquete pero que utiliza el paradigma de Grammar of Graphics (como ggplot en R)
#  http://gadflyjl.org/stable/ 

## Otro paquete prometedor: 
#  https://docs.makie.org/stable/ 
