### Entorno de las variables
### Por Arturo Erdely basado en https://docs.julialang.org/en/v1/


## Entorno global

# `begin` es un entorno global

texto = "global"
begin
    println(texto)
    texto = "dentro de begin" # modifica variable en entorno global 
    println(texto)
end
println(texto)

# `if` es un entorno global

x = 0.0
if x > 0.0
    x = Inf
elseif x < 0.0
    x = -Inf
else
    x = -0.0
end
println(x)


## Entorno local versus global
#  global  local  let  for/outer

texto = "global"
for i ∈ 1:3
    println(i, "\t", texto) # i es entorno local, no existe en global
end
println(i) # ERROR: UndefVarError: i not defined

texto = "global"
i = 0
for i ∈ 1:3
    texto = "local" # modifica variable en entorno global
    println(i, "\t", texto) # i es entorno local, no modifica global 
end
println(texto, "\t", "i = ", i)

# local

texto = "global"
i = 0
for i ∈ 1:3
    local texto = "local" # NO modifica variable en entorno global
    println(i, "\t", texto) # i es entorno local, no modifica global 
end
println(texto, "\t", "i = ", i)

# más ejemplos

for i ∈ 1:1
    z = i
    for j ∈ 1:1
        z = 0
    end
    println(z)
end
println(z) # ERROR porque `z` no fue definida en entorno global

for i ∈ 1:1
    x = i + 1
    for j ∈ 1:1
        local x = 0
        println(x)
    end
    println(x)
end

# `let` crea un entorno local

x = 1
let
    println(x)
    q = x + 5
    println(q)
end
println(q) # UndefVarError: q not defined

x = 1
let
    println(x)
    q = x + 5
    println(q)
    x += 1 # ERROR porque `let` es un entorno local --> usa begin ... end
end
println(x)

x = 1
let
    println(x)
    q = x + 5
    println(q)
    global x += 1 # aquí sí modificas el entorno global
end
println(x)


# for/outer

function f()
    i = 0
    println(i)
    for i ∈ 1:3
        print(i, " ")
    end
    println("\n valor final i = ", i)
    return nothing
end
f()

function g()
    i = 0
    println(i)
    for outer i ∈ 1:3
        print(i, " ")
    end
    println("\n valor final i = ", i)
    return nothing
end
g()


## Constantes
#  solo para entornos globales, avisa intentos de redefinir
#  no recomendables si se busca optimizar código

const K = (√5 - 1)/2
println(typeof(K))
println("Proporción áurea = ", K)
K = 0.618 # aviso (warning)
println("Proporción áurea = ", K)
# pero esto no genera aviso porque es el mismo valor:
K = 0.618
