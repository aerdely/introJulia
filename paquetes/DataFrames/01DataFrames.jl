### DataFrames
### Dr. Arturo Erdely

# Requiere haber instalado previamente los paquetes 
# DataFrames y CSV

using CSV, DataFrames


## Crear un Dataframe

df = DataFrame(Nombre = ["Abigail", "Beatriz", "Caritina", "Delia"],
               Edad = [21, 19, 23, 24],
               Estatura = [1.56, 1.74, 1.65, 1.69]
)

typeof(df)


## Información del DataFrame

size(df)

size(df, 1)

size(df, 2)

nrow(df)

ncol(df)

describe(df)

describe(df, cols = [1,3])

describe(df, cols = 2:3)


## Desplegar partes del DataFrame

df.Estatura

df[!, 3]

df.Estatura === df[!, 3]

df[:, 3]

df.Estatura === df[:, 3]  # porque df[:, 3] es una copia (no vinculada)

names(df)

names(df, Number)

names(df, String)

propertynames(df)

eltype(df.Edad)

eachcol(df)

eltype.(eachcol(df))


## Agregar campos (columnas)

df.Covid = [true, false, false, true]

df


## Agregar registros (filas)

push!(df, ["Ema", 20, 1.81, false])

df


## Extraer algunos registros

df2 = df[[1, 4, 5], :]

typeof(df2)


## Extraer algunos campos

df3 = df[:, [1, 4]]

typeof(df3)

# o también:

df4 = df[:, [:Nombre, :Covid]]

df3 == df4

typeof([:Nombre, :Covid])

# Al extraer un solo campo puedes obtener vector o DataFrame:

v1 = df.Nombre

v2 = df[:, :Nombre]

v1 == v2

typeof(v1) # vector

df5 = df[:, [:Nombre]] # DataFrame

typeof(df5)


## Extraer valores

df

df.Nombre[3]

df[2, 3]

df[5, :Estatura]


## Modificar valores

df.Nombre[3]

df.Nombre[3] = "Carolina"

df

df[4, :Estatura]

df[4, :Estatura] = 1.70

df

df[5, 4]

df[5, 4] = true

df


## Eliminar registros

delete!(df, [2, 5])

df

empty(df)

df

empty!(df)

df


## DataFrames grandes

df = DataFrame(rand(100, 15), string.(collect('A':'Z')[1:15]))

show(df, allrows = true)

show(df, allcols = true)

show(df, allcols = true, allrows = true)



## Escritura / lectura de archivos CSV 

df = DataFrame(Nombre = ["Abigail", "Beatriz", "Caritina", "Delia"],
               Edad = [21, 19, 23, 24],
               Estatura = [1.56, 1.74, 1.65, 1.69]
)

CSV.write("dfEjemplo.csv", df)

dfLeer = DataFrame(CSV.File("dfEjemplo.csv"))

typeof(dfLeer)

rm("dfEjemplo.csv") # eliminar archivo


## Más funciones especializadas en DataFrames, consultar:
#  https://dataframes.juliadata.org/stable/ 


## DataFrames + DelimitedFiles (sin usar CSV)
#  Fuente: https://bkamins.github.io/julialang/2022/02/04/delimitedfiles.html 

using DelimitedFiles

# mismo tipo de datos

csv = """
a,b,c
1,2,3
4,5,6
"""

mat, head = readdlm(IOBuffer(csv), ',', header = true)

mat

head 

DataFrame(mat, vec(head))

# distinto tipo de datos por columna

csv2 = """
a,b,c
1,2,x
4,5,y
"""

mat2, head2 = readdlm(IOBuffer(csv2), ',', header = true)

df2 = DataFrame(mat2, vec(head2))

identity.(df2)

# ¿Cuál es la ventaja de utilizar `DelimitedFiles` en lugar de `CSV.jl`?
# La primera es que `DelimitedFiles` es parte de la biblioteca estándar
# de Julia y por lo tanto no requiere instalación previa. La segunda es que
# para archivos de datos pequeños será mucho más rápido en la primera ejecución
# que en la primera compilación del paquete `CSV.jl` que toma varios segundos.

# ¿Cuáles son las desventajas? Para archivos de datos muy grandes la función
# `readdlm` será más lenta. Adicionalmente, carece de diversas opciones.
# `DelimitedFiles` es más eficiente para leer datos del mismo tipo, pero
# si las columnas tienen distintos tipos de dato es menos eficiente.
# Similarmente, por ejemplo, ante datos faltantes en el archivo CSV
# tendrás que identificarlos manualmente después de leerlos con la
# función `readdlm`.
