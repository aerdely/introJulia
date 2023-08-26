### Metaprogramación
### Por Arturo Erdely basado en https://docs.julialang.org/en/v1/

function que(x)
    println()
    println(x, "\t", typeof(x), "\t", sizeof(x), " bytes\n")
end

## Representación de programas
#  Meta.parse   .head   .args   Expr
#  dump   Meta.show_sexpr   eval   Symbol

parentmodule(Meta) # `Meta` es un submódulo de `Base`
names(Meta)

texto = "2 + 3"
ex1 = Meta.parse(texto)
que(ex1)

propertynames(ex1)
ex1.head
que(ex1.head)
ex1.args
que(ex1.args)

ex2 = Expr(:call, :+, 2, 3)
que(ex2)
ex1 == ex2, ex1 ≡ ex2
dump(ex1)
dump(ex2)

ex3 = Meta.parse("(2 + 3) / 4")
que(ex3)
dump(ex3)

eval(ex1)
eval(ex2)
eval(ex3)

s1 = Symbol("perro", 666)
que(s1)
s2 = :perro666
que(s2)
s1 == s2

tupla = (a = 1, b = 2)
que(tupla)
dump(tupla)


## Expresiones y evaluación
#  Expr   quote   eval  evalfile 

ex = :(a + b*c + 1)
que(ex)
que(ex.head)
que(ex.args)
dump(ex)

que(Expr)
:(a + b*c + 1) == Meta.parse("a + b*c + 1") == Expr(:call, :+, :a, Expr(:call, :*, :b, :c), 1)

ex = quote
    x = 1
    y = 2
    x + y
end
que(ex)
eval(ex)


# interpolación

a = 1
ex = :($a + 2)
que(ex)
eval(ex)

ex = :(a in $:((1,2,3)))
que(ex)
eval(ex)

# funciones sobre expresiones

function operación(operador, a, b)
    expresión = Expr(:call, operador, a, b)
    @show expresión
    return eval(expresión)
end
operación(:+, 1, Expr(:call, :*, 4, 5))
operación(:*, 0 + 1im, 0 + 1im)
f(x, y) = √(x^2 + y^2)
operación(:f, 3, 4)

a = 4
gtexto = "g(x, y) = x*y + $a"
g = eval(Meta.parse(gtexto))
g(2, 5)
dump(Meta.parse(gtexto))


## Macros

macro dihola()
    return :( println("Hola perro") )
end

@dihola() # o simplemente @dihola sin paréntesis

macro saluda(nombre)
    return :( println("Hola ", $nombre, ", me caes mal.") )
end

@saluda("Arturo")
@saluda "Juan" # funciona igual

println(@macroexpand @saluda "Arturo")

expresión = @macroexpand @saluda "Arturo"
println(typeof(expresión), "\t", expresión)
eval(expresión)

macro dospasos(arg)
    println("Durante la ejecución. arg = ", arg)
    return :( println("Fin de ejecución. arg = ", $arg) )
end

@dospasos "perro maldito"

expresión = @macroexpand @dospasos "perro maldito"
println(typeof(expresión), "\t", expresión)
eval(expresión)

# macros importantes

@time  @show  @display  @assert
@edit  @which  @doc 
@code_warntype  @code_native  @code_lowered  @code_typed  @code_llvm
@macroexpand  @test  @testset
# --> Lista completa escribe en julia> @ + [tab]


# quasi-macros útiles

varinfo()  # qué objetos hemos definido hasta el momento

versioninfo() # versión de Julia e info de la computadora

clipboard('α') # funciona como <copy> 
algo = clipboard() # funciona como <paste> incluso desde fuera de Julia

exit() # cierra la terminal de Julia


# multilínea

@time begin
    sleep(1)
    sleep(2)
end


## Generación de código

function generar_código(nombrefunc::String, creer::String)
    """function $nombrefunc(nombre::String, edad::Int)
                  println("Hola " * nombre)
                  println("$creer creo que tengas ", edad, " años de edad")
                  return (nombre, edad)
       end"""
end
código = generar_código("saludar", "No")
println(typeof(código))
println(código)
eval(Meta.parse(código))
saludar("Arturo", 53)
código = generar_código("conocer", "Sí")
println(código)
eval(Meta.parse(código))
conocer("Arturo", 53)

#=
My first macro in Julia 
https://giordano.github.io/blog/2022-06-18-first-macro/ 

Metaprogramming in Julia: A Full Overview
Fuente: https://towardsdatascience.com/metaprogramming-in-julia-a-full-overview-2b4e811f1f77
=#