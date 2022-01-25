### Entrada / salida (Input / output)
### Por Arturo Erdely basado en https://docs.julialang.org/en/v1/

# funciones auxiliares
function que(x)
    println("object: \t", x)
    println("typeof: \t", typeof(x))
    println("sizeof: \t", sizeof(x))
    println("length: \t", length(x))
    return nothing
end
function stipo(T::DataType)
    println("tipo:\t\t", T)
    println("supertipo:\t", supertype(T))
    println("subtipos:\t", subtypes(T))
    return nothing
end


## Archivos de texto 
#  countlines  open  sizeof  isopen  close  readlines  read  write  eachline

countlines("texto.txt")
f = open("texto.txt", "r") # solo lectura, por default si se omite "r" (read only)
que(f)
stipo(typeof(f))
display(f)
sizeof(f)
contenido = readlines(f)
isopen(f) # verificando si el archivo está abierto, porque hay que cerrarlo
close(f)
isopen(f) 
que(contenido)
display(contenido)
println(contenido)

f = open("texto.txt") # solo lectura, por default si se omite "r"
contenido = read(f, String)
close(f)
que(contenido)
display(contenido)
println(contenido)

for renglón ∈ eachline("texto.txt")
    println(renglón)
end

f = open("textoNuevo.txt", "w") # con opción a escribir (write), si ya existe sobre escribe
contenido = readlines(f)
que(contenido)
write(f, "Adiós mundo cruel.")
close(f)

f = open("textoNuevo.txt")
contenido = readlines(f)
close(f)
que(contenido)
display(contenido)
println(contenido)

f = open("textoNuevo.txt", "a") # agregar al final (append)
write(f, " Me voy a Marte.\nNo me esperen a cenar.")
close(f)

f = open("textoNuevo.txt")
contenido = readlines(f)
close(f)
que(contenido)
display(contenido)
println(contenido)


## Directorios
#  pwd  readdir  cd  mkdir  rm

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

# crear nueva carpeta en directorio de trabajo actual 
mkdir("nuevaCarpeta")
for e ∈ readdir(directorio)
    println(e)
end

# cambiar directorio de trabajo 
pwd()
cd(pwd() * "\\nuevaCarpeta")
pwd()
readdir(pwd())
f = open("prueba.txt", "w")
write(f, "Hola amigos.")
close(f)
readdir(pwd())

# eliminar archivos o carpetas
rm("prueba.txt")
directorio = pwd()
readdir(directorio)
d = SubString(directorio, 1, length(directorio) - length("nuevaCarpeta"))
cd(d)
pwd()
"nuevaCarpeta" ∈ readdir(pwd())
rm("nuevaCarpeta")
"nuevaCarpeta" ∈ readdir(pwd())


## Archivos de datos numéricos
# Hay que convertir a texto / desconvertir de texto

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
que(contenido) # no es lo que esperábamos
contenido # no es lo que esperábamos

# hay que convertir todo a texto
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


## Descargar archivos de internet

using Downloads # paquete de la biblioteca estándar de Julia

url = "https://www.dropbox.com/s/bv1a0m74tlnj736/pruebaDescarga.txt?dl=0"

Downloads.download(url, "descarga.txt")

f = open("descarga.txt")
contenido = readlines(f)
close(f)
display(contenido)


## DelimitedFiles: paquete de la biblioteca estándar de Julia
## para leer y escribir matrices de datos

using DelimitedFiles

A = reshape(collect(1:20), 5, 4)
writedlm("archivo.txt", A, '|')

B = readdlm("archivo.txt", '|', Int64, '\n')
display(B)

D = readdlm("datos.csv", ',', String, '\n', header = true)
typeof(D)
D[2]
D[1]
