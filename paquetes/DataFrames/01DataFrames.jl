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

df.Nombre

df[:, 3]

names(df)


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


## Escritura / lectura de archivos CSV 

pwd() # directorio de trabajo actual donde se guardará el archivo

CSV.write("dfEjemplo.csv", df)

dfLeer = DataFrame(CSV.File("dfEjemplo.csv"))

typeof(dfLeer)

rm("dfEjemplo.csv") # eliminar archivo


## Más funciones especializadas en DataFrames, consultar:
#  https://dataframes.juliadata.org/stable/ 


## DataFrames + DelimitedFiles (sin usar CSV)
#  Fuente: https://bkamins.github.io/julialang/2022/02/04/delimitedfiles.html 

using DelimitedFiles

csv = """
a,b,c
1,2,3
4,5,6
"""

mat, head = readdlm(IOBuffer(csv), ',', header = true)

mat

head 

DataFrame(mat, vec(head))

csv2 = """
a,b,c
1,2,x
4,5,y
"""

mat2, head2 = readdlm(IOBuffer(csv2), ',', header = true)

df2 = DataFrame(mat2, vec(head2))

identity.(df2)

# What is the benefit of using DelimitedFiles module over CSV.jl? 
# The first that it is shipped with Base Julia so it does not require installation. 
# The second is that for small files it will be faster on the first run as compilation
# of functions from the CSV.jl package takes several seconds.

# What are the drawbacks? For large data the readdlm function will be slower. 
# Additionally it lacks many options. DelimitedFiles is best suited for 
# reading data having homogeneous type. If columns have mixed types it becomes less convenient.
# Similarly, e.g. when you have missing data in the CSV file you would have to manually
# identify them after reading it in with the readdlm function.
