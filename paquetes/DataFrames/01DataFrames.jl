### 1. Introducción a DataFrames
### Por Dr. Arturo Erdely 

### Con base en: https://dataframes.juliadata.org/stable/man/basics/ 

## Requiere haber instalado previamente los paquetes 
## DataFrames, CSV, BenchmarkTools

begin
   import Pkg
   Pkg.add("CSV")
   Pkg.add("DataFrames")
   Pkg.add("BenchmarkTools")   
end

## Usar los paquetes

using CSV, DataFrames, BenchmarkTools



## Crear un DataFrame

df = DataFrame(Nombre = ["Abigail", "Beatriz", "Caritina", "Delia"],
               Edad = [21, 19, 23, 24],
               Estatura = [1.56, 1.74, 1.65, 1.69]
)

typeof(df)


## Información del DataFrame
#  size  nrow  ncol  describe  names  propertynames  eachcol 

size(df)
size(df, 1)
size(df, 2)

nrow(df)
ncol(df)

describe(df)
describe(df, cols = [1,3])
describe(df, cols = 2:3)
describe(df, cols = [:Nombre, :Estatura])

names(df)
names(df, Number)
names(df, String)
names(df, Char)
names(df, r"a") # que contengan la letra `a` (regex = regular expressions)
names(df, Not(r"a")) # que NO contengan la letra `a` (regex)
names(df, r"da") # que contengan "da"
propertynames(df)

eltype(df.Edad)
eachcol(df)
eltype.(eachcol(df))
hcat(propertynames(df), eltype.(eachcol(df)))
DataFrame(campo = propertynames(df), tipo = eltype.(eachcol(df)))
describe(df)[:, [1, end]]


## Desplegar partes del DataFrame
#  ! vs :   first  last

df.Estatura
df[!, 3]
df.Estatura === df[!, 3] # misma ubicación en memoria (si lo modificas, se modifica el df original)
df[:, 3]
df.Estatura === df[:, 3]  # porque df[:, 3] es una copia (no vinculada)

first(df, 2)
last(df, 2)
first(df)
last(df)


## Visualizar dataframe con uso eficiente de memoria
#  view  @view 

view(df, :, :)
view(df, :, [:Nombre])
@view df[[1,4], [:Nombre, :Estatura]]

@btime $df[1:end-1, 1:end-1]
@btime @view $df[1:end-1, 1:end-1] # más rápido

# `view` es más rápido y eficiente en uso de memoria,
# pero apunta al mismo lugar de memoria que el df original
# y por tanto un cambio en un dataframe creado con view
# modifica el dataframe original.
# Algunas operaciones con dataframes creados con `view`
# pueden resultar más lentas porque tiene que referirse al
# dataframe original.


## Agregar campos (columnas)
#  insertcols!

df
df.Covid = [true, false, false, true]
df # se agregó la columna al final

insertcols!(df, 3, :Peso => [45,54,63,59])
insertcols!(df, 2, :Sexo => 'F')
df

# --> para eliminar columnas ver más adelante Transformaciones de columnas `select!`


## Agregar registros (filas)
#  push!  append!

push!(df, ["Ema", 'F', 20, 71, 1.81, false]) # agregar un solo registro
df
append!(df, df[1:2, :]) # agregar varios registros (mediante otro dataframe)


## Eliminar registros (filas)
#  delete!  empty  empty!

df
delete!(df, [1, 6, 7])
df

empty(df)
df
dfvaciar = copy(df)
empty!(dfvaciar)
dfvaciar
size(dfvaciar)
df


## Extraer algunos registros
#  Not 

df2 = df[[1, 3, 4], :]
typeof(df2)

df
df[Not(4), :]
df[Not(2, 4), :]
df[Not(2:4), :]


## Extraer algunos campos
#  Not  Between  Cols

df
df3 = df[:, [1, 4]]
typeof(df3)

df
df4 = df[:, [:Nombre, :Peso]]
df3 == df4  # mismos valores
df3 === df4 # false porque están en distintas ubicaciones de memoria (es una copia)

df
df[:, Not(:Peso)]

df
df[:, Not([:Edad, :Peso])]

df
df[:, Between(:Edad, :Estatura)]

df
df[:, Cols(:Nombre, Between(:Peso, :Covid))]


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
df[4, :Estatura]


## Modificar valores

df.Nombre[2]
df.Nombre[2] = "Carolina"
df

df[4, :Estatura]
df[4, :Estatura] = 1.73
df

df[4, 6]
df[4, 6] = true
df

df.Covid .= false # se asigna el mismo valor a toda la columna
df


## DataFrames grandes

df = DataFrame(rand(100, 15), string.(collect('A':'Z')[1:15])) # despliegue parcial
show(df, allrows = true) # forzar a que se muestren todas las filas
show(df, allcols = true) # forzar a que se muestren todas las columnas
show(df, allcols = true, allrows = true) # forzar a que muestren todas las filas y columnas 


## Escritura / lectura de archivos CSV 

df = DataFrame(Nombre = ["Abigail", "Beatriz", "Caritina", "Delia"],
               Edad = [21, 19, 23, 24],
               Estatura = [1.56, 1.74, 1.65, 1.69]
)

CSV.write("dfEjemplo.csv", df)
dfLeer = DataFrame(CSV.File("dfEjemplo.csv"))
typeof(dfLeer)
# también:
dfLeer2 = CSV.read("dfEjemplo.csv", DataFrame)
dfLeer == dfLeer2
@btime dfLeer = DataFrame(CSV.File("dfEjemplo.csv"))
@btime dfLeer2 = CSV.read("dfEjemplo.csv", DataFrame)
rm("dfEjemplo.csv") # eliminar archivo

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

#=
¿Cuáles son la ventajas de utilizar `DelimitedFiles` en lugar de `CSV.jl`?
1) `DelimitedFiles` es parte de la biblioteca estándar de Julia y por lo tanto
   no requiere instalación previa.
2) Para archivos de datos pequeños será mucho más rápido en la primera ejecución
   que en la primera compilación del paquete `CSV.jl` que toma varios segundos.

¿Cuáles son las desventajas? 
1) Para archivos de datos muy grandes la función `readdlm` será más lenta.
2) Carece de diversas opciones.
3) `DelimitedFiles` es más eficiente para leer datos del mismo tipo, pero
   si las columnas tienen distintos tipos de dato es menos eficiente.
4) Ante datos faltantes en el archivo CSV tendrás que identificarlos manualmente
   después de leerlos con la función `readdlm`.
=#

## DataFrames + DelimitedFiles (sin usar CSV)
#  Fuente: https://bkamins.github.io/julialang/2022/02/04/delimitedfiles.html 


## Funciones básicas de transformación de dataframes

df = DataFrame(Nombre = ["Abigail", "Beatriz", "Caritina", "Delia"],
               Sexo = ['F', '?', 'F', 'F'],
               Edad = [21, 19, 23, 24],
               Estatura = [1.56, 1.74, 1.65, 1.69],
               Covid = [false, true, false, false]
)

# cálculos sobre columnas
# mapcols  mapcols!

mapcols(x -> x .^ 2, df)
df
df2 = copy(df)
mapcols!(x -> x .^ 2, df2)
df2

# combine  select  ByRow  select!  

df
combine(df, :Edad => mean => :Edad_prom)
select(df, :Edad => mean => :Edad_prom)
combine(df, :Sexo => unique => :Sexos)
select(df, :Sexo => unique => :Sexos) # ERROR
resumen = combine(df, :Edad => mean => :Edad_prom, :Sexo => unique => :Sexos)
typeof(resumen)

df
select(df, :Nombre => (x -> uppercase.(x)) => :NOMBRE)

df
select(df, :Nombre => ByRow(lowercase) => :nombre)

df
@btime select(df, :Edad, :Edad => (x -> x .- 18) => :mayor_edad)
@btime select(df, :Edad, :Edad => ByRow(x -> x - 18) => :mayor_edad)

df 
select(df, Not(:Edad))

df
select(df, r"e") # expresiones regulares (regex)

df
select(df, r"e", "Covid", :Edad, 4)

df
select(df, :Covid, :)

df
select(df, :Nombre => :Name, "Edad" => "Age")

df
df2 = select(df, :Nombre)
df.Nombre == df2.Nombre # mismos valores
df.Nombre === df2.Nombre # pero distinta ubicación en memoria (es una copia)

df2 = select(df, :Nombre, copycols = false)
df.Nombre == df2.Nombre # mismos valores
df.Nombre === df2.Nombre # misma ubicación en memoria (lo que modifiques en uno se modifica en el otro)

df
select(df, Not(:Edad)) # es una copia de `df` que omite la columna :Edad pero no modifica `df`
df 
select!(df, Not(:Edad)) # aquí sí se modifica `df` y se elimina al columna :Edad
df

# transform  transform!

df2 = copy(df)
combine(df2, :Estatura => maximum)
combine(df2, :Estatura => maximum => "Estatura_máxima")
select(df2, :Estatura => maximum => :Estatura_máxima)
transform(df2, :Estatura => maximum => :Estatura_máxima)

df2
transform!(df2, :Estatura => maximum => :Estatura_máxima)
df2

transform(df2, :Sexo => :Covid, :Covid => :Sexo)

df2
select(df2, :Estatura, "Estatura_máxima", [:Estatura, :Estatura_máxima] => (+) => :suma)


## Más funciones especializadas en DataFrames, consultar:
#  https://dataframes.juliadata.org/stable/ 
