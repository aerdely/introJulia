### Cadenas de caracteres
### Por Arturo Erdely basado en https://docs.julialang.org/en/v1/


## Caracteres
#  Int  Char  isvalid  isletter  isuppercase  islowercase  isnumeric

println('@', "\t typeof: ", typeof('@'), "\t Int value: ", Int('@'))
println("Char(64) = ", Char(64))

println(Char.(8700:8710))
println(Char.(0:2048))

println(2000, "\t\t isvalid: ", isvalid(Char, 2000), "\t", Char(2000))
println(1000_000_000, "\t isvalid: ", isvalid(Char, 1000_000_000))

isletter('A')
isletter('z')
isletter('9')
isletter('@')

islowercase('T')
islowercase('t')
isuppercase('T')
isuppercase('t')

isnumeric('9')
isnumeric('w')


# \n (new line)  \t (tab)  \v (vertical tab)  \b (backspace)  \r (return)  chomp
println("El mundo es color\nrosa")
println("El mundo es color\trosa")
println("El mundo es color\vrosa")
println("El mundo es color\brosa")
println("El mundo es color\rrosa")

a = "Julia es lo\nmáximo\n"
println(a, "fin")
chomp(a)
println(chomp(a), "fin")


# comparaciones y operaciones

println('A', "\t", Int('A'))
println('a', "\t", Int('a'))
println("'A' < 'a' \t", 'A' < 'a')
println("'a' - 'A' \t", 'a' - 'A')
println('A' .+ [0, 1, 2, 3, 4])


## Subcadenas de caracteres
#  firstindex  lastindex  SubString  end  chop  chomp  chopprefix  chopsuffix  
#  strip  lstrip  rstrip

texto₁ = "A quien madruga Dios lo arruga"
println(texto₁)
texto₂ = """Me molesta que utilicen "comillas" para todo"""
println(texto₂)
texto₃ = "Otra forma de utilizar \"comillas\" dentro de las comillas"
println(texto₃)

println(texto₁)
println(texto₁[3], "\t", typeof(texto₁[3]))
println(texto₁[3:3], "\t", typeof(texto₁[3:3]))
println(texto₁[begin], "\t", texto₁[1], "\t", texto₁[end])
println(texto₁[3], "\t", texto₂[25], "\t", texto₃[24:25])
println(texto₃[[25, 28, 31]], "\t", texto₃[end], "\t", texto₃[end - 1])

oraciónLarga = "Esta es una oración \
demasiado larga"
println(oraciónLarga)

println(firstindex(texto₃), "\t", lastindex(texto₃))
println(texto₃[firstindex(texto₃)], "\t", texto₃[lastindex(texto₃)])
println(texto₃[0]) # ERROR
println(texto₃[99]) # ERROR

println(texto₃[25], "\t", typeof(texto₃[25]))
println(texto₃[25:25], "\t", typeof(texto₃[25:25]))
println(texto₃[25:28], "\t", typeof(texto₃[25:28]))
println(texto₃[[25, 28, 31]], "\t", typeof(texto₃[[25, 28, 31]]))

println(texto₁, "\t", typeof(texto₁))
subtexto₁ = SubString(texto₁, 3, 7)
println(subtexto₁, "\t", typeof(subtexto₁))

SubString("abcdefghi", 3, 6)
chop("abcdefghi", head = 2, tail = 3)

print("INICIO"); print("     texto 123 "); println("FIN")
print("INICIO"); print(strip("     texto 123 ")); println("FIN")
print("INICIO"); print(lstrip("     texto 123 ")); println("FIN")
print("INICIO"); print(rstrip("     texto 123 ")); println("FIN")


## Unicode y UTF-8
#  nextind   prevind   eachindex   transcode

println(sizeof.(['∀', 'x', '∃', 'y']))
println(sizeof.(["∀", "x", "∃", "y"]))
expr = "∀ x ∃ y"
println(expr)
println(length(expr), "\t", sizeof(expr))
println(Int.(ℓ for ℓ ∈ expr))
println(sizeof.(ℓ for ℓ ∈ expr))
println(sizeof.(String([ℓ]) for ℓ ∈ expr))

println(expr)
println(length(expr), "\t", sizeof(expr))
println(expr[1], "\t", sizeof(String([expr[1]])))
println(expr[2]) # error porque ∀ abarca posiciones 1:3
println(expr[4:7])
println(nextind(expr, 1))
println(nextind(expr, 2))
println(nextind(expr, 4))
println(nextind(expr, 5))
println(nextind(expr, 6))
println(nextind(expr, 7))
println(nextind(expr, 10))
println(nextind(expr, 11))
println(nextind(expr, 12))

println(prevind(expr, 12))
println(prevind(expr, 10))

println(eachindex(expr))
println(collect(eachindex(expr)))


## Concatenación

saluda = "Hola"
quien = "mundo"
frase₁ = string(saluda, " ", quien, " cruel!")
println(frase₁)
println(saluda * quien)


## Interpolación

saluda = "Hola"
quien = "mundo"
println("$saluda $quien cruel!")

println("1 + 2 = $(1 + 2)")

v = [1, 2, 3]
println("v = $v", "\t", v, "\t", typeof(v))

println("Tengo \$1,000 pesos en mi cartera")


# Escribir cadena larga mediante separaciones

"Esto está muy largo así que \
 lo vamos a separar"


## Operaciones comunes
#  findfirst  findlast  findnext  findprev  occursin

println("abc" < "xyz", "\t", "abc" == "xyz")
println("abc" < "ayz", "\t", "ayc" < "abz")
println("1 + 2 = 3" == "1 + 2 = $(1 + 2)")

# sizeof("xilofono") = 8  versus  sizeof("xilófono") = 9
# "ó" ocupa las bit-posiciones 4 y 5

println(firstindex("xilofono"), "\t", lastindex("xilofono"))
println(findfirst(isequal('o'), "xilofono"), "\t", findlast(isequal('o'), "xilofono"))
println(findfirst("o", "xilofono"), "\t", findlast("o", "xilofono"))

println(firstindex("xilófono"), "\t", lastindex("xilófono"))
println(findfirst(isequal('o'), "xilófono"), "\t", findlast(isequal('o'), "xilófono"))
println(findfirst("o", "xilófono"), "\t", findlast("o", "xilófono"))

println(findnext(isequal('o'), "xilófono", 7))
println(findnext(isequal('o'), "xilófono", 8))
println(findprev(isequal('o'), "xilófono", 9))

println(occursin("Dios", "A quien madruga Dios lo ayuda"))
println(occursin("dios", "A quien madruga Dios lo ayuda"))
println(occursin("i", "A quien madruga Dios lo ayuda"))
println(occursin('i', "A quien madruga Dios lo ayuda"))
println(occursin("z", "A quien madruga Dios lo ayuda"))
println(occursin('z', "A quien madruga Dios lo ayuda"))

# endswith  startswith  contains

nombre_archivo_1 = "imagen01.png"
nombre_archivo_2 = "imagen02.pdf"
endswith(nombre_archivo_1, ".png")
endswith(nombre_archivo_2, ".png")
startswith(nombre_archivo_1, "imagen")
startswith(nombre_archivo_2, "imagen")
contains(nombre_archivo_1, "gen")
contains(nombre_archivo_1, "g")
contains(nombre_archivo_1, 'g')
contains(nombre_archivo_1, "gw")

# repeat  join  length  ncodeunits  codeunit  codeunits
# thisind  nextind  prevind

println(repeat(".:Z:.", 10))
println(".:Z:."^10)
println(join(["perros", "gatos", "ratones", "lombrices"], ", ", " y "))

function quetexto(x)
    println(x, "\t typeof: ", typeof(x))
    println("length: ", length(x), "\t sizeof: ", sizeof(x))
    println("firstindex: ", firstindex(x), "\t lastindex: ", lastindex(x))
    println(length(x, firstindex(x), lastindex(x)), " índices válidos de caracteres")
end

quetexto("xilófono")
println(length("xilófono", 4, 5))
println(length("xilófono", 5, 6))
println(length("xilófono", 6, 7))

println(ncodeunits("xilófono"))
println(codeunit("xilófono", 2))
println(Char(codeunit("xilófono", 2)))
println(codeunits("xilófono"))
println(codeunit("xilófono", 4))
println(Char(codeunit("xilófono", 4)))
println(codeunit("xilófono", 5))
println(Char(codeunit("xilófono", 5)))

println(thisind("xilófono", 2))
println(nextind("xilófono", 2))
println(prevind("xilófono", 2))

println(thisind("xilófono", 5))
println(nextind("xilófono", 5))
println(prevind("xilófono", 5))

# replace

S = "Hola perros"
T = replace(S, "H" => "J")
println(S, "\t", T)

# uppercase  lowercase  titlecase  uppercasefirst  lowercasefirst

t = "el mejor lenguaje de programación es Julia"
println(t)
t_mayúsculas = uppercase(t)
t_minúsculas = lowercase(t)
t_título = titlecase(t)
t_mayúscula_inicial = uppercasefirst(t)
t_minúscula_inicial = lowercasefirst(t_mayúscula_inicial)

# split  join  rsplit  eachsplit  eachrsplit

r = split("hola, ahí,perro", ',')
show(r); println() 
r = split("hola, ahí,perro", ", ")
show(r); println() 
r = split("hola, ahí,perro", [',', ' '], limit=0, keepempty=false)
show(r); println() 
r = join(collect(1:10), ", ")
println(r) #> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10

oración = "Primera frase. Segunda frase. Tercera frase. Una frase más. La última. Ahora sí ya se acabó. . . . . ..... "
println(oración)
split1 = split(oración, "."); println(split1)
split2 = split(oración, "."; keepempty = false); println(split2)

himno = "Mexicanos.al.grito.de.guerra"
a = split(himno, '.')
b = rsplit(himno, '.')
a == b
c = split(himno, "."; limit = 3)
d = rsplit(himno, "."; limit = 3)
c == d

iterador = eachsplit(himno, '.')
collect(iterador)
iterador2 = eachrsplit(himno, '.')
collect(iterador2)


## Expresiones regulares (Regex)
#  Regex  match  eachmatch

rx = Regex("a.a")
typeof(rx)
m = match(rx, "abracadabra")
typeof(m)
m.match
typeof(m.match)
m = match(rx, "abracadabra", 5)

rx = Regex("a(?<key>.)a")
m = match(rx, "abracadabra")
m.match
m.captures
m["key"]

rx = r"a.a"
m = eachmatch(rx, "abracadabra", overlap = true)
collect(m)
