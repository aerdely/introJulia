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

# --> ver paquete externo: BenchmarkTools

# `@time_imports`: tiempo de carga de un paquete y sus dependencias

@time_imports using OhMyREPL


## Fecha y hora del sistema

using Dates
now()


## Memoria
#  Sys.free_memory()  Sys.total_memory()  
#  Sys.free_physical_memory()  Sys.total_physical_memory()

Sys.free_memory() # En notación hexadecimal
fgigas(n::Integer) = convert(Int64, n) / 1_000_000_000 # convertir a GiB
fgigas(Sys.free_memory())
fgigas(Sys.total_memory())
fgigas(Sys.free_physical_memory())
fgigas(Sys.total_physical_memory())


## Nombre de usuario

Sys.username()


## Localizar paquetes y obtener versión

VERSION # de Julia
DEPOT_PATH
Sys.BINDIR # el archivo ejecutable de Julia

versioninfo()
versioninfo(verbose = true) # más detallado

using Dates # paquete de la biblioteca estándar de Julia
pkgdir(Dates)
pathof(Dates)

using OhMyREPL # paquete externo
pkgdir(OhMyREPL)
pathof(OhMyREPL)
pkgversion(OhMyREPL)


## InteractiveUtils: paquete de la biblioteca estándar de Julia

## `apropos`: Buscar texto dentro de la documentación de Julia

a = apropos("pattern")
# o bien desde el modo ayuda: help?> "pattern"
typeof(a)
# Por ejemplo `Base.count`
dc = Docs.doc(Base.count) # en su descripción aparece la palabra "pattern"
typeof(dc)
println(string(dc))
occursin("pattern", string(dc))

io = IOBuffer()
apropos(io, "pattern") # guardar info en el buffer
ap = String(take!(io)) # extraer info del buffer
println(ap)
String(take!(io)) # se vació el buffer
apvec = split(ap, "\n")
println(apvec)
println(apvec[1])
dc = Docs.doc(eval(Meta.parse(apvec[1])))
typeof(dc)
occursin("pattern", string(dc))

## `varinfo`: información de objetos en un módulo (`Main` por default)

varinfo() # que es lo mismo que `varinfo(Main)`
varinfo(InteractiveUtils) # info solo de los objetos que exporta
varinfo(InteractiveUtils, all = true) # info de todos los objetos definidos en el módulo
varinfo(InteractiveUtils, imported = true) # info de objetos exportados e importados
varinfo(InteractiveUtils, all = true, imported = true) # todo lo anterior

## `versioninfo`

versioninfo()
versioninfo(verbose = true) # más detallado
VERSION

## `@functionloc`: archivo y línea donde se ejecuta una función
## `@edit`: abre el archivo donde se ubica ¡cuidado con los archivos de Julia!

f(x) = x^2 + 1
@functionloc f(3)

@functionloc(sum([1,2,3]))
@edit sum([1,2,3])


#= Análisis de código
@code_lowered
@code_typed:
@code_warntype : resalta tipos que afectan tiempo de ejecución (amarillo, rojo)
@code_llvm
@code_native   : traduce código a lenguaje ensamblador
=#

function senolim(θ)
    if θ == 0
        return 1
    else
        return sin(θ)/θ
    end
end

@code_lowered senolim(0) # igual que @code_lowered senolim(π/2)
string(@code_lowered senolim(0)) == string(@code_lowered senolim(π/2))

@code_typed senolim(0)
@code_typed senolim(π/2)
string(@code_typed senolim(0)) == string(@code_typed senolim(π/2)) # distinto

@code_typed senolim(0)
@code_typed optimize=true senolim(0)

@code_warntype senolim(0)
@code_warntype senolim(π/2)
string(@code_warntype senolim(0)) == string(@code_warntype senolim(π/2)) # iguales

# Se elimina la incertidumbre sobre el tipo que arrojará
function senolim2(θ)::Float64
    if θ == 0
        return 1
    else
        return sin(θ)/θ
    end
end
@code_warntype senolim2(0)

# Se especifican los tipos
function senolim3(θ::Float64)::Float64
    if θ == 0.0
        return 1.0
    else
        return sin(θ)/θ
    end
end
@code_warntype senolim3(0.0)

@code_native senolim(0)

@code_llvm senolim3(0.0)


## `@time_imports`: tiempo de carga de un paquete y sus dependencias

@time_imports using OhMyREPL


## `clipboard`: copy-paste

clipboard(3)
clipboard()

# copia en memoria algo desde cualquier parte de tu sistema operativo y luego:
clipboard()

