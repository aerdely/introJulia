### Control de flujo
### Por Arturo Erdely basado en https://docs.julialang.org/en/v1/


## Expresiones compuestas  
#  begin

z = begin
    x = 1
    y = 2
    x + y
end
println(z, "\t", typeof(z))

z = (x = 4 ; y = 5 ; x + y)
println(z, "\t", typeof(z))

begin x = 1 ; y = 2 ; println(x + y) end


## Evaluación condicional
#  if  elseif  else  ifelse

function compara(x, y)
    if x < y
        println("$x < $y")
    elseif x > y
        println("$x > $y")
    else
        println("$x = $y")
    end
    return nothing
end

compara(2, 3)
compara(7, 1)
compara(3, 3)

compara2(x, y) = println(x < y ? "$x < $y" : x > y ? "$x > $y" : "$x = $y")
compara2(2, 3)
compara2(7, 1)
compara2(3, 3)

esmayor(x, y) = ifelse(x > y, "sí", "no")
esmayor(5, 4)
esmayor(2.3, 3.2)


## Evaluación de corto circuito 
#  &&  ||  &  |

t(x) = (println(x) ; true)
f(x) = (println(x) ; false)

println(t(1) & t(2))
println(t(1) & f(2))
println(f(1) & t(2))
println(f(1) & f(2))

println(t(1) && t(2))
println(t(1) && f(2))
println(f(1) && t(2))
println(f(1) && f(2))

println(t(1) | t(2))
println(t(1) | f(2))
println(f(1) | t(2))
println(f(1) | f(2))

println(t(1) || t(2))
println(t(1) || f(2))
println(f(1) || t(2))
println(f(1) || f(2))

println(true && 1000)
println(false && 1000)

println(true || 1000)
println(false || 1000)


## Ciclos
#  while  for  in  ∈  continue  break  foreach

letra = 'a'
while letra ≤ 'z'
    print(letra, " ")
    global letra += 1
end
println(letra)

letra = 'a'
while letra ≤ 'z'
    if letra == 'w'
        print("perro ")
        global letra += 1
        continue
    end
    if letra == 'y'
        break
    end
    print(letra, " ")
    global letra += 1
end
println(letra)

for 🐷 ∈ 'α':'ω'  # en lugar de ∈ puede usarse `in` o bien `=`
    print(🐷, " ")
end

for 🍉 ∈ ['♌', 'Q', '3', '❌']
    print(🍉, "\t")
end

for ℘ ∈ "La vida es lucha"
    print(℘, " ◐ ")
end

for 🍉 ∈ 'α':'δ', 🐼 ∈ 3:5
    println((🍉 , 🐼))
end

for i ∈ 1:2, j ∈ 3:4
    println((i, j))
    i = 0
end
for i ∈ 1:2
    for j ∈ 3:4
        println((i, j))
        i = 0
    end
end

vf = [x -> x + 1, x -> x^2, x -> x/2]
vx = [1, 10]
Afx = [f(x) for f ∈ vf, x ∈ vx]
display(Afx)


# Pkg.add("BenchmarkTools")
using BenchmarkTools

n = 100
Δ = zeros(Int64, n, n, n) # arreglo 3D

@btime begin
    for i ∈ 1:n , j ∈ 1:n, k ∈ 1:n
        Δ[i, j, k] = i + j + k
    end
end
# en lugar de:
@btime begin
    for i ∈ 1:n
        for j ∈ 1:n
            for k ∈ 1:n
                Δ[i, j, k] = i + j + k
            end
        end
    end
end

function ∠(θ)
    for k ∈ 1:length(θ)
        θ[k] = sin(θ[k])
    end
    θ
end;
println(round.(∠([0, π/2, π, 3π/2, 2π])))
θ = rand(100_000_000);
@btime lista = [sin(β) for β ∈ θ]; # lista comprensiva
@btime vecto = sin.(θ); # vectorizado
@btime ciclo = ∠(θ); # con ciclo <for> puro

A = zeros(Int, 100, 100, 100);
@btime for i ∈ 1:100, j ∈ 1:100, k ∈ 1:100
           A[i, j, k] = i + j + k
end
B = zeros(Int, 100, 100, 100);
@btime for i ∈ 1:100, j ∈ 1:100, k ∈ 1:100
           B[k, j, i] = i + j + k
end # más rápido
B == A


# foreach

foreach(println, 'α':'ω')


## Manejo de excepciones
#  throw  error  try/catch  finally

# Solo mensajes (texto)
error("¡Cometiste un error muy grave!")

# Mensaje de error por medio de un objeto no necesarimente de texto
a = 0/0
throw(a)
throw("¡No hagas eso!")

function dameTexto(texto)
    if typeof(texto) == String
        println("Bien hecho")
    else
        throw(println("Requiere que su argumento `texto` sea tipo String y no " * string(typeof(texto))))
    end
    println("Fin")
end
dameTexto("Hola perro")
dameTexto(3)

function damePositivo1(x)
    if x > 0
        println("bien hecho")
    else
        throw(DomainError(x, "¿no entendiste que positivo 😢?"))
    end
    println("fin")
end
damePositivo1(3)
damePositivo1(-2)

function damePositivo2(x)
    if x > 0
        println("bien hecho")
    else
        error("¿no entendiste que positivo 😢?")
    end
    println("fin")
end
damePositivo2(3)
damePositivo2(-2)

function damePositivo(x)
    try
        return sqrt(x) # si x < 0 -> ERROR
    catch # atrapar/administrar el ERROR
        println("dije positivo, tonto")
        return 0
    end
    println("fin") # nunca se ejecuta
end
damePositivo(3)
damePositivo(-2)
sqrt(-2)

function damePositivo3(x)
    try
        return sqrt(x)
    catch
        println("dije positivo, tonto")
        return 0
    finally
        println("fin") # siempre se ejecuta al margen de try / catch
    end
end
damePositivo3(3)
damePositivo3(-2)
