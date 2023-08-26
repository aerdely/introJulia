# https://docs.julialang.org/en/v1/base/base/ 

## Tiempo
#  time  sleep  @time  @showtime @timev  @elapsed  @timed  
#  @time@eval  time_ns  @allocations  @allocated

begin
    inicio = time() # en segundos
    sleep(3) # 3 segundos
    final = time()
    inicio, final, final - inicio
end

# la función `sleep` se ejecuta y solo entrega un objeto tipo `Nothing`
isnothing(sleep(1)) 

@time sleep(2)
@time "2 segundos" sleep(2) # agregar descripción
@showtime sleep(2) # agregar expresión evaluada
@timev sleep(2) # información más detallada que @time
@timev "Más detalle" sleep(2) 

# @time, @timev y @showtime informan el tiempo de ejecución, 
# pero solo entregan el resultado de evaluar el objeto:
M = rand(10, 10) # matriz aleatoria de 10 × 10
a = @time "M²" M^2
display(a)
b = @showtime M^2
display(b)
c = @timev "M²" M^2
display(c)

# Si solo deseamos el tiempo entonces:
t = @elapsed M^2

# En cambio @timed te entrega una tupla con toda la información:
info = @timed M^2
info.value
info.time
keys(info)
info.bytes
info.gctime
info.gcstats
propertynames(info.gcstats)

# Recordemos que la primera vez que se ejecuta una función es
# más lenta que las subsecuentes por efecto de una primera compilación:
f(n::Int) = sum(0:n)
@time "Primera ejecución con `eval`" @eval f(1_000_000_000)
@time "Segunda ejecución con `eval`" @eval f(1_000_000_000)

begin
    inicio = time_ns() # en nanosegundos
    sleep(3) # 3 segundos
    final = time_ns()
    convert(Int, inicio), convert(Int, final), convert(Int, final - inicio)
end

@time "Primera ejecución" M^3
@time "Segunda ejecución" M^3
@allocations M^3
@allocated M^3


## Memoria
#  Sys.free_memory()  Sys.total_memory()  
#  Sys.free_physical_memory()  Sys.total_physical_memory()

Sys.free_memory() # En notación hexadecimal
fgigas(n::Integer) = convert(Int64, n) / 1_000_000_000 # convertir a GiB
fgigas(Sys.free_memory())
fgigas(Sys.total_memory())
fgigas(Sys.free_physical_memory())
fgigas(Sys.total_physical_memory())


## Localizar paquetes y obtener versión

VERSION # de Julia
DEPOT_PATH
Sys.BINDIR # el archivo ejecutable de Julia

using Dates # paquete de la biblioteca estándar de Julia
pkgdir(Dates)
pathof(Dates)

using OhMyREPL # paquete externo
pkgdir(OhMyREPL)
pathof(OhMyREPL)
pkgversion(OhMyREPL)


## Info de la computadora

versioninfo()
Sys.WORD_SIZE
Sys.CPU_THREADS


## https://docs.julialang.org/en/v1/base/arrays/ 

