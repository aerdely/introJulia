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
