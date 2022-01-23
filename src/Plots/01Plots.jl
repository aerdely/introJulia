### Gráficas con el paquete Plots.jl  
### Dr. Arturo Erdely

# Requiere que previa instlación en la terminal de Julia
# mediante: add Plots 

using Plots # tarda unos segundos en cargar, es un paquete grande

# El primer gráfico tarda un poquito porque al mismo tiempo
# se precompila el paquete, pero a partir del segundo gráfico
# ya es más veloz:

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


# guardar gráfica en archivos .png y .pdf

savefig("pininos.png")

savefig("pininos.pdf")


# guardar gráfica en memoria

P = current()
typeof(P)
sizeof(P)
P
plot(P) 


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
     plot(x, y, f, st = :surface, xlabel = "x", ylabel = "y")
end

# curvas/conjuntos de nivel

contour(x, y, z, xlabel = "x", ylabel = "y", size = (400, 400), fill = true)

# modificar la cantidad de niveles en la gráfica anterior:

contour(x, y, z, xlabel = "x", ylabel = "y", size = (400, 400), fill = true, levels = 5)


## Para más detalles consulta la página de Plots.jl 
#  http://docs.juliaplots.org/latest/ 


## Otro paquete que utiliza el paradigma de Grammar of Graphics (como ggplot en R)
#  http://gadflyjl.org/stable/ 
