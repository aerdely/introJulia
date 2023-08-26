### Entrada / salida (Input / output)
### Por Arturo Erdely basado en https://docs.julialang.org/en/v1/

# función auxiliar
function que(x)
    println("object: \t", x)
    T = typeof(x)
    println("tipo:\t\t", T)
    println("supertipo:\t", supertype(T))
    println("subtipos:\t", subtypes(T))
    println("memory: \t", Base.summarysize(x), " bytes")
    return nothing
end


## Lectura de la línea de comandos
#  readline

# escribir directo en la línea de comandos:
a = readline() 
que(a)


## Archivos de texto 
#  filesize  countlines  open  isopen  close  
#  readlines  readline  readuntil  read  write  eachline  rm  evalfile

# Importante --> Text encoding: UTF-8

archivo = "MiTexto.txt"
filesize(archivo) # tamaño en bytes
countlines(archivo)
f = open(archivo, "r") # solo lectura, por default si se omite "r" (read only)
que(f)
contenido = readlines(f)
isopen(f) # verificando si el archivo está abierto, porque hay que cerrarlo
close(f)
isopen(f) 
que(contenido)
display(contenido)
println(contenido)

readlines("MiTexto.txt")
readlines("MiTexto.txt", keep = true)
readline("MiTexto.txt")
readline("MiTexto.txt", keep = true)

readuntil("MiTexto.txt", "á")

f = open(archivo) # solo lectura, por default si se omite "r"
contenido = read(f, String)
close(f)
que(contenido)
display(contenido)
println(contenido)

for renglón ∈ eachline(archivo)
    println(renglón)
end

f = open("MiTextoNuevo.txt", "w") # con opción a escribir (write), si ya existe sobreescribe
contenido = readlines(f)
que(contenido)
write(f, "Adiós mundo cruel.")
close(f)

f = open("MiTextoNuevo.txt")
contenido = readlines(f)
close(f)
que(contenido)
display(contenido)
println(contenido)

f = open("MiTextoNuevo.txt", "a") # agregar al final (append)
write(f, " Me voy a Marte.\nNo me esperen a cenar.")
close(f)

f = open("MiTextoNuevo.txt")
contenido = readlines(f)
close(f)
que(contenido)
display(contenido)
println(contenido)

rm("MiTextoNuevo.txt") # eliminar archivo


## Directorios
#  pwd  readdir  cd  mkdir  isdir  isfile
#  dirname  basename  joinpath  rm  homedir

pwd() # directorio (o carpeta) de trabajo actual
directorio = pwd()
readdir(directorio) # nombres de archivos y carpetas en carpeta actual
elementos = readdir(directorio)
println(elementos)
for e ∈ elementos
    println(e)
end

# lo mismo pero con la dirección completa de cada archivo:
readdir(directorio, join = true)

#=
puedes usar las funciones `filter` junto con `endswith` o `startswith`
o `contains` para filtrar archivos, por ejemplo:
filter(endswith(".png"), readdir())
=#

# crear nueva carpeta en directorio de trabajo actual 
nueva = "nuevaCarpeta"
mkdir(nueva)
for e ∈ readdir(directorio)
    println(e)
end
println(directorio * "\\" * nueva)
isdir(directorio * "\\" * nueva)
isfile(directorio * "\\" * nueva)

# cambiar directorio de trabajo 
pwd()
cd(pwd() * "\\" * nueva)
pwd()
readdir() # es lo mismo que readdir(pwd())
f = open("prueba.txt", "w")
write(f, "Hola amigos.")
close(f)
readdir()
isdir("prueba.txt")
isfile("prueba.txt")
readlines("prueba.txt")
readdir(join = true)
readdir(join = true)[1]
isdir(readdir(join = true)[1])
isfile(readdir(join = true)[1])
basename(readdir(join = true)[1])
dirname(readdir(join = true)[1])
joinpath(dirname(readdir(join = true)[1]), basename(readdir(join = true)[1]))

# mover archivos
mv("prueba.txt", "pruebita.txt") 
readdir()
readlines("pruebita.txt")
write("prueba2.txt", "Perros malditos")
readdir()
readlines("prueba2.txt")
mv("prueba2.txt", "pruebita.txt") # ERROR
readdir()
mv("prueba2.txt", "pruebita.txt", force = true)
readdir()
readlines("pruebita.txt")

# eliminar archivos o carpetas
rm("pruebita.txt")
directorioactual = pwd()
readdir(directorioactual)
println(nueva)
d = chopsuffix(directorio, nueva)
cd(d)
pwd()
"nuevaCarpeta" ∈ readdir(pwd())
rm("nuevaCarpeta")
"nuevaCarpeta" ∈ readdir(pwd())

homedir() # carpeta de usuario establecida por el sistema operativo


## Archivos de datos numéricos
#  --> Hay que convertir a texto / desconvertir de texto

a = 1
b = 2.5
v = [1, 2, 3]
M = rand(2, 3)
X = [a, b, v, M]


f = open("valores.txt", "w")
for e ∈ X
    write(f, e)
end
close(f)

f = open("valores.txt")
contenido = readlines(f)
close(f)
contenido # no es lo que esperábamos

# hay que convertir todo a texto antes de escribirlo en el archivo
f = open("valores.txt", "w")
for e ∈ X
    write(f, string(e))
end
close(f)
f = open("valores.txt")
contenido = readlines(f)
close(f)
println(contenido)

# Faltó indicar los saltos de línea mediante \n
f = open("valores.txt", "w")
for e ∈ X
    write(f, string(e) * "\n")
end
close(f)
f = open("valores.txt")
contenido = readlines(f)
close(f)
println(contenido)

convertir(x) = eval(Meta.parse(x))
original = convertir.(contenido)
println(original)
X == original

rm("valores.txt")


## Crear / leer archivos CSV

A = [1, 2, 3, 4, 5]
B = ["Alma", "Betina", "Carmela", "Dionisia", "Eleuteria"]
C = rand(5)
D = [A, B, C]

f = open("prueba.csv", "w")
for i ∈ 1:length(D[1])
    for j ∈ 1:length(D)
        if j < length(D)
            write(f, string(D[j][i]) * ",")
        else
            write(f, string(D[j][i]) * "\n")
        end
    end
end
close(f)

f = open("prueba.csv")
contenido = readlines(f)
close(f)
display(contenido)

nfilas = length(contenido)
ncolumnas = length(findall(",", contenido[1])) + 1
E = fill(fill("", nfilas), 1)
for j ∈ 2:ncolumnas
    push!(E, fill("", nfilas))
end
display(E) 

contenido[1]

split(contenido[1], ",")

for i ∈ 1:length(E[1])
    fila = split(contenido[i], ",")
    for j ∈ 1:length(E)
        E[j][i] = fila[j]
    end
end
display(E)    

F = [convertir.(E[1]), E[2], convertir.(E[3])]
display(F)
D == F # comprobando

rm("prueba.csv")


## Descargar archivos de internet

using Downloads # paquete de la biblioteca estándar de Julia

url = "https://www.dropbox.com/scl/fi/z04jstg4jbnx8b7h0bg0w/MiDescarga.txt?rlkey=uwi65orguyfmqw8u2v8k7epgd&dl=0"

Downloads.download(url, "MiDescarga.txt")

f = open("MiDescarga.txt")
contenido = readlines(f)
close(f)
display(contenido)

rm("MiDescarga.txt")


## DelimitedFiles: paquete de la biblioteca estándar de Julia
## para leer y escribir matrices de datos

using DelimitedFiles

A = reshape(collect(1:20), 5, 4)
writedlm("archivo.txt", A, '|')

B = readdlm("archivo.txt", '|', Int64, '\n')
display(B)

rm("archivo.txt")

D = readdlm("MisDatos.csv", ',', String, '\n', header = true)
typeof(D)
D[2]
D[1]
