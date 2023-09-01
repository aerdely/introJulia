### Estadística: Paquetes `Random` y `Statistics` de la biblioteca estándar de Julia
### Por Arturo Erdely 

#= 
  Las funciones `rand` y `randn` son importadas automáticamente por el 
  módulo `Base` y por tanto no requieren cargar el paquete `Random`
=#

parentmodule(rand)
parentmodule(randn)

# `rand`: Crea un arreglo con una muestra aleatoria uniforme a partir de una colección o tipo.
#         Si el tipo es Float es sobre el intervalo [0,1), y si no se especifica tipo ni
#         colección entonces es Float64 por defecto.

begin
    n = 1_000
    m = 4
    V = collect(range('a', length = m))
    rC = rand(V, 1_000) # Muestra tamaño `n` uniforme discreta a partir de la colección `V`
    println(rC)
end

begin # conteo de casos
    cont = zeros(Int, m)
    for k ∈ 1:m
        cont[k] = count(rC .== V[k])
    end
    display(hcat(V, cont))
end

rand(V, 10, 10)

rand(Float64, (2, 3, 4)) # igual que rand(2,3,4) distribución uniforme sobre [0,1)

rand("Hola", 10)

rand(Int8, 6) # distribución uniforme discreta entre typemin(Int8) y typemax(Int8)
(typemin(Int8), typemax(Int8))
all(typemin(Int8) .≤ rand(Int8, 100) .≤  typemax(Int8)) # siempre verdadero

begin
    fun(z) = z^2 + 1
    A = rand(2, 3)
    S = [(2, "hola"), fun, A]
    rand(S, 10)
end


# `randn`: simula números pseudoaleatorios Normal(0,1) tipo Float o Complex, y
#          si no se especifica el tipo entonces es Float64 por defecto.

randn(Float16, 5)

randn(2, 3)

randn(ComplexF64, 3, 2)

begin
    media(x) = sum(x) / length(x)
    varianza(x) = sum((x .- media(x)) .^2) / (length(x) - 1)
    x = randn(1_000_000) # lo mimso que randn(Float64, 10_000)
    media(x), varianza(x) # aprox (0, 1)
end


## Paquete `Random`

using Random 

names(Random)
varinfo(Random)


# rand!  randn!

A = zeros(Int, 3, 5)
rand!(A, [1, 10, 100])
display(A)

B = zeros(2, 3)
randn!(B)
display(B)


# randexp: distribución Exponencial(1)
# randexp!

randexp(Float16, 10)

randexp(5, 3) # igual que randexp(Float64, 5, 3)

begin
    e = randexp(1_000_000)
    media(e), varianza(e) # aprox (1, 1)
end

A = zeros(10)
randexp!(A)
display(A)


# `randstring`: distribución uniforme discreta sobre un conjunto de caracteres

randstring('a':'z', 10)
# distinto de: 
println(rand('a':'z', 10))

randstring("Hola", 15)
# distinto de:
println(rand("Hola", 15))


# `randsubseq`: Muestreo secuencial Bernoulli(p)

randsubseq('a':'e', 0.3) # ejecutar varias veces

randsubseq(1:100, 0.2)

randsubseq([[], [[]], [[[]]]], 0.7) # ejecutar varias veces

length(randsubseq(1:1_000_000, 0.1)) # aprox 100_000

@isdefined Z
Z = []
randsubseq!(Z, 1:100, 0.3) # modifica el tamaño de Z según se requiera
display(Z)


# `randperm`: Permutación aleatoria de una sucesión finita de números enteros 1:n
# `randperm!`

println(randperm(10)) # ejecutar varias veces 

println(randperm(Int8(10))) # ejecutar varias veces 

A = collect(1:7)
println(randperm!(A))
println(A)


# `shuffle`: Permutación aleatoria de un arreglo arbitrario
# `shuffle!`

println(shuffle('a':'h')) # ejecutar varias veces

A = rand("Mexicanos", 2, 3)
shuffle(A) # ejecutar varias veces

display(A)
shuffle!(A) 
display(A)


# Generadores pseudoaleatorios (RNG)
#-----------------------------------
# RNG = Random Number Generator

Random.default_rng() # Generador por defecto
typeof(Random.default_rng())
typeof(TaskLocalRNG)
supertypes(TaskLocalRNG)
subtypes(AbstractRNG) # Subtipos de RNGs

# `Random.seed`: especificar semilla generadora

rand(2)
rand(2)

Random.seed!(123)
x = rand(2)
rand(2)
Random.seed!(123)
y = rand(2)
x == y

#= Generadores específicos
   Xoshiro  MersenneTwister  RandomDevice
=#

rng = Xoshiro(1234)
typeof(rng)
w = rand(rng, 2)
rng = Xoshiro(1234)
z = rand(rng, 2)
w == z

begin
    rng = Xoshiro(1234)
    typeof(rng)
    w = rand(rng, 2)
    # rng = Xoshiro(1234)
    z = rand(rng, 2)
    w == z
end

begin
    rng = Xoshiro()
    typeof(rng)
    w = rand(rng, 2)
    rng = Xoshiro()
    z = rand(rng, 2)
    w == z
end

begin
    rng = MersenneTwister(666)
    typeof(rng)
    w = rand(rng, 2)
    rng = MersenneTwister(666)
    z = rand(rng, 2)
    w == z
end

Random.RandomDevice(123) # ERROR porque no admite semillas específicas

rng = RandomDevice()
typeof(rng)
w = rand(rng, 2)
rng = RandomDevice()
z = rand(rng, 2)
w == z

begin
    rng = RandomDevice()
    typeof(rng)
    w = rand(rng, 2)
    # rng = RandomDevice()
    z = rand(rng, 2)
    w == z
end


## Paquete `Statistics`
#  mean  median  middle  quantile  std  var  cov  cor

using Statistics, Random

# `mean`

x = randexp(100_000);
mean(x) # aprox 1.0 (media teórica)
f(x) = x^2 + 100
a = mean(f, x)
# es lo mismo que:
b = mean(f.(x))
a == b
# pero...
@time mean(f, x) # es más rápido y eficiente en memoria
@time mean(f.(x))

U = rand(10_000, 3)
mean(U, dims = 1)
mean(U, dims = 2)
mean(f, U, dims = 1)

# `middle`

middle(2,3) # igual que (2+3)/2
x = randexp(30)
middle(x) # es lo mismo que
mean(extrema(x)) # y lo mismo que
middle(minimum(x), maximum(x))

x = randexp(1_000_000)
@time middle(x) # menor uso de memoria pero no el más rápido
@time mean(extrema(x)) # el menos eficiente
@time middle(minimum(x), maximum(x)) # el más rápido pero más uso de memoria

# `median`

x = randexp(100_000);
median(x) # aprox log 2 (mediana teórica)
log(2)
median!(x)
x
median(x)

U = randexp(10_000, 3)
median(U, dims = 1)
median(U, dims = 2)

# `quantile`

x = [1,2,3,4,5];
quantile(x, 0.5)
# igual que:
median(x)

x = randn(100_000);
quantile(x, 0.025)
mean(x .≤ quantile(x, 0.025)) # comprobando

quantile(x, [0.025, 0.500, 0.975])

#=
El valor por defecto de los parámetros opcionales de `quantile` son
`alpha = 1` y `beta = 1` pero la mejor recomendación es
`alpha = 1/3` y `beta = 1/3` según:
  Hyndman, R.J and Fan, Y. (1996) "Sample Quantiles in Statistical Packages",
  The American Statistician, Vol. 50, No. 4, pp. 361-365
=#

x = collect(1:20);
println(x)
quantile(x, 0.1)
quantile(x, 0.1, alpha = 1/3) # por defecto beta=alfa

x = randexp(1_000_000);
xord = sort(x);
@time quantile(x, 0.2) # ejecutar 2 veces
@time quantile(xord, 0.2) # ejecutar 2 veces
@time quantile(sort(x), 0.2, sorted=true) # ejecutar 2 veces


# `var` `std`

begin
    media(x) = sum(x) / length(x)
    varianza(x) = sum((x .- media(x)) .^2) / (length(x) - 1)
end;

begin
    z = randn(100_000)
    var(z) # aprox 1.0
end

begin
    x = randn(10)
    vx = var(x) # es lo mismo que
    vx == varianza(x)
end

begin
    u = rand(100_000)
    std(u), sqrt(varianza(u)) # aprox 1/√12 ≈ 0.2887
end


# `cov`  `cor`

x = randn(100);
y = x + randn(100);
cov(x,y)
cor(x,y)

z = rand(100);
M = [x y z]
cov(M)
cor(M)

