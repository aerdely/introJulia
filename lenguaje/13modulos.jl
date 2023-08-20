### Módulos
### Por Arturo Erdely basado en https://docs.julialang.org/en/v1/

# Un módulo es un paquete de código que encapsula variables, funciones, tipos, etc.
# para poder ser utilizado (`using`) o importado (`import`) dentro de otro código.

# Se utilizan para crear «espacios de nombres» (namespaces) que son contenedores
# abstractos en el que un grupo de uno o más identificadores únicos pueden existir.
# Un identificador definido en un espacio de nombres está asociado con ese espacio
# de nombres.​ El mismo identificador puede ser definido independientemente en múltiples
# espacios de nombres, esto es, el sentido asociado con un identificador definido en un
# espacio de nombres es independiente del mismo identificador declarado en otro espacio
# de nombres. Fuente: https://es.wikipedia.org/wiki/Espacio_de_nombres 

# Los elementos esenciales de un `module` en julia son:
# 1) `export`: Los objetos que el módulo exporta a quien lo llame
# 2) `include`: El código que el módulo utiliza a partir de otros archivos .jl
# 3) `import`, `using`: Módulos que el requiere utilizar el actual módulo
# 4) Definiciones de objetos dentro del propio módulo, que pueden o no exportarse
# 5) Submódulos: para una mejor organización jerárquica del código relacionado

# De hecho el mismo lenguaje de programación Julia está organizado en módulos,
# siendo `Base` el principal, pero no el único. De hecho cuando abrimos la consola
# de Julia (REPL) podemos identificar que por default se cargan los módulos llamados
# `Base`, `Core`, `InteractiveUtils` y `Main`:

varinfo()

# instrucción que además muestra todos los objetos que se hayan creado
# en la sesión y que están ocupando memoria RAM.

# Podemos averiguar a qué módulo pertenecen ciertas funciones
# del lenguaje de programación Julia mediante `parentmodule` por ejemplo:

parentmodule(println) # Base
parentmodule(String) #Core
parentmodule(supertypes) # InteractiveUtils

# Se acostumbra para los nombres de módulos el estilo «UpperCamelcase»
# como en el ejemplo anterior: `InteractiveUtils`

# Definamos ahora una función y averigüemos:

fu(x) = x^2 + 1
varinfo()
parentmodule(fu) # Main

# La función `Date` no forma parte de los módulos que por default carga Julia:

Date # UndefVarError: `Date` not defined

# pero si cargamos el paquete `Dates` de la biblioteca estándar de Julia
# que contiene una función llamada `Date` entonces:

using Dates 
Date
parentmodule(Date)

# De hecho el código del módulo `Dates.jl` puede consultarse en:
# https://github.com/JuliaLang/julia/blob/master/stdlib/Dates/src/Dates.jl 

# El conjunto total del paquete `Dates` consistente en el módulo `Dates.jl`
# y demás archivos auxiliares puede consultarse en:
# https://github.com/JuliaLang/julia/tree/master/stdlib/Dates


# Lo que exporta el módulo: `export`

# Nombres de funciones, tipos, variables globales y constantes que serán
# importados por el código que lo solicite mediante la sintaxis:

# using NombreModulo

# No es obligatorio que un módulo exporte objetos explícitamente.
# No se acostumbra indentar mucho el código de módulos.

module CosasChidas
export lindo, PERRO 
struct Perro
    nombre::String
    edad::Int
end # este tipo no se exporta
const PERRO = Perro("Fido", 5) # esta constante sí se exporta
lindo(x) = "lindo $x" # esta función sí se exporta
end # module 

# De hecho nótese el mensaje recibido después de ejecutar este código: Main.CosasChidas
# que significa que el módulo `CosasChidas` quedó de hecho como submódulo de `Main`.

varinfo()

# El módulo ya fue creado pero lo que exporta todavía no está disponible:

lindo # UndefVarError: `lindo` not defined
PERRO # UndefVarError: `PERRO` not defined

# Para que esté disponible lo que exporta un módulo:

using Main.CosasChidas  # o bien: using .CosasChidas

frase = lindo(PERRO.nombre)
varinfo()

# Pero el tipo `Perro` sigue sin estar disponible directamente
# porque no fue incluido en la lista de `export`

Perro("Solovino", 8) # UndefVarError: `Perro` not defined

# Pero como el módulo ya fue llamado mediante `using` se puede
# acceder al objeto agregando antes el nombre del módulo (module path)

callejero = CosasChidas.Perro("Solovino", 8)
varinfo()

# Es decir, mediante `using` los objetos que aparecen en la lista de `export`
# están disponibles sin necesidad del module path, y los objetos que no están
# especificados para exportarse también están disponibles pero requieren
# module path. 

# Nótese que para usar un módulo que está en `Main` se ocupa la sintaxis:
# using Main.MiMódulo o bien using .MiMódulo
# pero si se trata de un paquete ya instalado de Julia no es necesario el punto:
# using NombrePaqueteJulia

# Si en un módulo no hay objetos a exportarse explícitamente mediante `export`
# no tiene sentido llamar al módulo mediante `using` sino mediante `import`,
# pero en tal caso para tener acceso a los objetos del módulo siempre habrá que
# llamarlos agregando antes el module path.

module MatesChidas
f(x) = x + 1
g = sqrt ∘ f
cte = g(1)
end # module

import .MatesChidas # o bien: import Main.MatesChidas

cte # UndefVarError: `cte` not defined
MatesChidas.cte
MatesChidas.f(1)
MatesChidas.g(1)

# Pareciera más cómodo ocupar `using` para no tener que escribir todo
# el module path, pero cuando se usan muchos módulos que tienen algunos
# nombres de objetos iguales entrarían en conflicto, y en tal caso
# es mejor llamarlos importarlos con `import`.

# Se pueden llamar varios módulos mediante una sola instrucción,
# separados por comas, por ejemplo:

# using LinearAlgebra, Statistics, Dates
# import LinearAlgebra, Statistics, Dates

# using .MiMódulo1, .MiMódulo2
# import .MiMódulo1, .MiMódulo2

# Es posible llamar solo algunos nombres de objetos dentro de un módulo:

module MatesChafas
export c, g 
f(x::Number, y::Number) = x * y
g(x::Number) = f(x, x)
h = g ∘ f 
a = 3
b = g(a)
c = f(100, b)
end # module

using .MatesChafas: b, g, h

c # UndefVarError: `c` not defined, a pesar de que está en la lista de `export`
MatesChafas.c
b # por el llamado explícito, a pesar de que no está en la lista de `export`
f(2,3) # UndefVarError: `f` not defined
MatesChafas.f(2,3)
g(3)
h(2,3)

methods(MatesChafas.f)
methods(g)
methods(h)

# Ahora supongamos que queremos definir un nuevo método para la función `g`

g(x::String) = "Hola $x" 
# ERROR: error in method definition: function MatesChafas.g must be
# explicitly imported to be extended

# Es decir `using` importa los objetos de forma que no es posible agregar nuevos
# métodos, a menos que se agregue explícitamente el module path que le corresponde:

MatesChafas.g(x::String) = "Hola $x" 
methods(g)
g(3)                        
g("Fido")

MatesChafas.f(x::String, y::String) = x * y
methods(MatesChafas.f)
MatesChafas.f(2,3)
MatesChafas.f("2","3")

MatesChafas.h(x::String, y::Int) = x ^ y
methods(h)
h(2,3)
h("2",3)

# Otra forma más sencilla de poder agregar métodos a funciones de un módulo
# es llamarlo mediante `import` en lugar de `using`:

module MatesChafas2
export z, k # se ignora esta parte si el módulo es llamado mediante `import`
j(x::Number, y::Number) = x * y
k(x::Number) = j(x, x)
l = k ∘ j 
x = 3
y = k(x)
z = j(100, y)
end # module

import .MatesChafas2: y, k, l

y # se reconoce a pesar de no estar en la lista de `export`
z # UndefVarError: `z` not defined, porque no fue importada explícitamente,
#   a pesar de estar en la lista de `export`
MatesChafas2.z

k
methods(k)
k(x::String) = "Hola $x" # nuevo método sin necesidad del module path
methods(k)
k(5)
k("perrito")

# También se puede aplicar `using` e `import` al mismo módulo con el objeto de faciliar
# el poder agregar métodos a determinadas funciones:

module Modulito
export f1
f1(x::Int) = x^2
f2(x::Int) = 3x
end # module 

using .Modulito

f1
f2 # UndefVarError: `f2` not defined
Modulito.f2

import .Modulito: f2

f2
f2(x::String) = "Hola " * x
methods(f2)
f2(8)
f2("mundo")

f1
methods(f1)

f1(x::String) = "Adiós $x" # ERROR: error in method definition: function Modulito.
# f1 must be explicitly imported to be extended, o bien mediante:
Modulito.f1(x::String) = "Adiós $x"
f1(4)
f1("mundo cruel")

# La ventaja con llamar varios módulos completos mediante `import` es que seguro
# no habrá conflictos de nombres porque en cada caso hay que antecederlos por su
# correspondiente module path. Solo podría haber conflicto si dos módulos se llaman igual.
# La desventaja es justamente tener que escribir el module path.

# Pero si se importan solo ciertos objetos de un módulo de forma explícita,
# mediante la sintaxis:
# import .Módulo: objeto1, objeto2
# estos objetos se reconocen sin necesidad de acompañarlos de su module path, y se les
# puede agregar métodos sin necesidad de especificar el module path.

# La ventaja con `using` es que se evita que por error el usuario agregue métodos indeseados
# a las funciones del módulo, y que para hacerlo tenga que ser conscientemente especificando
# el module path, además de que mediante `export` se especifica qué objetos no requieren
# module path para mayor facilidad de uso.


# Ante los conflictos de nombres que puede ocurrir al llamar varios módulos vía `using`
# y/o vía un `import` específico de nombres es renombrando objetos de los módulos mediante
# la instrucción `as`.

# Por ejemplo `println` y `supertypes` son parte de los módulo `Base` e `InteractiveUtils`
# que por default carga el lenguage de programación Julia:

parentmodule(println)
parentmodule(supertypes)

# Si un módulo pretente exportar objetos con algunos de esos nombres hay conflicto:

module MiModulo
export println
println(x) = "Imprime $x"
supertypes(x) = "Supertipo $x"
end # module

using .MiModulo
# WARNING: using MiModulo.println in module Main conflicts with an existing identifier.
# y en este caso lo ignora:

println("Nada")

# tendría que llamarse agregando su module path:

MiModulo.println("Nada")

# Con `import` no habría conflicto si se importa el módulo completo:

module MiModulo2
export println
println(x) = "Imprime $x"
supertypes(x) = "Supertipo $x"
end # module

import .MiModulo2

# ya que en este caso `import` hace caso omiso de `export`, y todos los objetos
# importados requieren module path, evitando así cualquier conflicto:

MiModulo2.println("Nada")
MiModulo2.supertypes("Bla")

# pero si se les importa directamente entonces sí hay conflicto:

import .MiModulo2: println
# WARNING: ignoring conflicting import of MiModulo2.println into Main

# Una solución a esto es renombrar:

import .MiModulo2: println as imprime

imprime
parentmodule(imprime)
methods(imprime)
imprime("Nada")

# Incluso si se tienen dos módulos con el mismo nombre pueden renombrarse también:
# import Modulo1 as Modulo2 

# Si al mismo tiempo llamamos módulos que tienen conflictos de nombres, puede
# manejarse de la siguiente forma, por ejemplo:

module A
export fun   
fun() = 0
end 

module B
export fun
fun() = 1
end

using .A, .B
fun
# WARNING: both B and A export "fun"; uses of it in module Main must be qualified
# UndefVarError: `fun` not defined

# Lo de "qualified" se refiere a que `fun` deberá ir precedido del module path
# que corresponda o se quiera ocupar. Podemos renombrar en un caso:

using .A: fun as fun
using .B: fun as gun

parentmodule(fun)
parentmodule(gun)
fun()
gun()


## Submódulos

# Por default cualquier módulo incorpora `using Core` y `using Base` aunque podría evitarse
# utilizando `baremodule` tema sobre el que no mencionaremos más, pero es importante tomarlo
# en cuanta al definir módulos dentro de módulos (submódulos) para evitar entrar en conflicto
#

######
module SuperModulo

export prin1, prin2

module Sub1
export println 
println(x) = "Imprime $x con newline al final"
end # module Sub1

module Sub2
print(x) = "Imprime $x"
end # module Sub2 

import .Sub1: println as pr
import .Sub2

prin1(x) = pr(x)
prin2(x) = Sub2.print(x)

end # SuperModulo 
######

using .SuperModulo

prin1("Hola")
prin2("Hola")


### Otro ejemplo

# En este caso el módulo se encuentra en otro archivo, en este caso en el mismo
# directorio (de lo contrario hay que especificar el path completo), que a su vez
# requiere de otro archivo (en este caso, también en el mismo directorio).

include("MiModulo.jl")

names(MiModulo)
que # ERROR porque el módulo no ha sido llamado con `using`
MiModulo.que
MiModulo.que(3.4)
# incluso disponible en
# help?> MiModulo.que

typeof(MiModulo)

using .MiModulo

que # Ahora no hay error porque ya fue exportado
parentmodule(que)
que(3.4)
adios() # también fue exportado
saludo() # ERROR porque saludo() NO fue exportado
# Así que:
MiModulo.saludo()
tipejo(Real)
