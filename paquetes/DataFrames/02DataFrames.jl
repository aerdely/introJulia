### 2. El tipo `DataFrame` y constructores
### Por Dr. Arturo Erdely con base en https://dataframes.juliadata.org/stable/ 

# Requiere haber instalado previamente los paquetes 
# DataFrames, CSV

using CSV, DataFrames, BenchmarkTools


## Construcción por columnas

df = DataFrame()
typeof(df)
size(df)
sizeof(df) # en bytes, de la pura estructura de DataFrame
Base.summarysize(df) # en bytes, la memoria total que ocupa

df.Nombre = ["Mafalda", "Guille", "Felipe", "Susanita", "Miguelito", "Manolito", "Libertad"]
df
sizeof(df)
Base.summarysize(df)
df[!, :Edad] = [7,3,8,7,6,7,7]
df[:, "IQ"] = [130, 110, 100, 95, 90, 70, 120]
df
insertcols!(df, 3, :Peso => [25.1, 13.2,26.3, 26.2, 28.4, 29.5, 19.4])

# diferencia entre df[:, ] y df[!, ]

df.Nombre == df[!, :Nombre] == df[!, "Nombre"] # mismos valores
df.Nombre == df[:, :Nombre] == df[:, "Nombre"] # mismos valores

df.Nombre === df[!, :Nombre] # misma ubicación de memoria 
df.Nombre === df[:, :Nombre] # distinta ubicación de memoria 

a = df[:, :Nombre]
a[1] = "Mafaldita"
df.Nombre[1] == a[1] # como `a` es un copia no se alteró el DataFrame original
df

b = copy(df.Nombre) # mismo efecto que `b = df[:, :Nombre]` o que `b = df[:, "Nombre"]`
b[1] = "Mafaldita"
df.Nombre[1] == b[1] 
df

c = df[!, :Nombre]
c[1] = "Mafaldita"
df.Nombre[1] == c[1] # si se modifica `c` se modifica el DataFrame original
df 

d = df.Nombre # mismo efecto que `d = df[!, :Nombre]` o que `d = df[!, "Nombre"]`
d[1] = "Mafalda"
df.Nombre[1] == d[1]
df


## Construcción por filas

df = DataFrame(Nombre = String[], Edad = Int[])
names(df)
describe(df)
push!(df, ("Mafalda", 7))
push!(df, ["Guille", 4])
push!(df, Dict(:Edad => 8, :Nombre => "Felipe")) # a partir de un `Dict`
append!(df, df[1:2, :]) # a partir de un DataFrame 

v = [(Name = "Manolito", Age = 8), (Name = "Susanita", Age = 7)]
df = DataFrame(v)


## Manipulación de DataFrames (funciones adicionales a 01DataFrames.jl)
#  subset  subset!  allowmissing!  filter 

begin
    df = DataFrame()
    df.Nombre = ["Mafalda", "Guille", "Felipe", "Susanita", "Miguelito", "Manolito", "Libertad"]
    df.Mujer = [true, false, false, true, false, false, true]
    df[!, :Edad] = [7,3,8,7,6,7,7]
    df[:, "IQ"] = [130, 110, 100, 95, 90, 70, 120]
    insertcols!(df, 3, :Peso => [25.1, 13.2,26.3, 26.2, 28.4, 29.5, 19.4])
end

subset(df, :Mujer)
subset(df, :Peso => x -> x .> 26.0)
subset(df, :Mujer, :Peso => x -> x .> 26.0)
subset(df, :Mujer, :Peso => x -> x .> 30.0)

df
subset!(df, :Edad => x -> x .> 6)
df

df.Cabello = ["negro", "café", "rubio", missing, "rubio"]
df # nótese el type `String?` donde `?` es por el `missing`
subset(df, :Cabello => x -> x .== "rubio") # ERROR por culpa de `missing`
subset(df, :Cabello => x -> x .== "rubio", skipmissing = true)

# `filter`` es más rápido que `subset`

n = 10_000
t = DataFrame(continuo = rand(n), discreto = rand([1,2,3], n), letra = rand('A':'Z', n))
t1 = subset(t, :continuo => x -> x .> 0.5, :discreto => x -> x .== 2)
all(t1.continuo .> 0.5 .&& t1.discreto .== 2) # comprobando
t2 = filter([:continuo, :discreto] => (x,y) -> x .> 0.5 .&& y .== 2, t)
all(t2.continuo .> 0.5 .&& t2.discreto .== 2) # comprobando
t1 == t2 # dataframes iguales
t1 === t2 # pero distinta ubicación de memoria
@btime subset(t, :continuo => x -> x .> 0.5, :discreto => x -> x .== 2);
@btime filter([:continuo, :discreto] => (x,y) -> x .> 0.5 .&& y .== 2, t);


## Reemplazar datos en un DataFrame
#  replace!

df

replace!(df.Cabello, "rubio" => "amarillo")
df

replace!(df.Cabello, missing => "no se sabe")
df


## Fusión de DataFrames (joins)
#  innerjoin  leftjoin  rightjoin  outerjoin
#  semijoin  antijoin  crossjoin

alumnos = DataFrame(ID = [3001, 3002, 3003, 3004], Nombre = ["Arias", "Benítez", "Calderón", "Díaz"])
examen = DataFrame(ID = [3001, 3002, 3004, 3005], Calif = [9, 10, 5, 7])
innerjoin(alumnos, examen, on = :ID) # ID es la columna pivote

alumnos
examen
leftjoin(alumnos, examen, on = :ID)

alumnos
examen
rightjoin(alumnos, examen, on = :ID)

alumnos
examen
outerjoin(alumnos, examen, on = :ID)

alumnos
examen
semijoin(alumnos, examen, on = :ID)

alumnos
examen
antijoin(alumnos, examen, on = :ID)

alumnos
examen
crossjoin(alumnos, examen, makeunique = true)

# si la columna pivote se llama diferente en los DataFrames
alumnos = DataFrame(ID = [3001, 3002, 3003, 3004], Nombre = ["Arias", "Benítez", "Calderón", "Díaz"])
examen = DataFrame(Cuenta = [3001, 3002, 3004, 3005], Calif = [9, 10, 5, 7])
innerjoin(alumnos, examen, on = :ID => :Cuenta)

# pivoteando con varias columnas
alumnos = DataFrame(ID = [3001, 3002, 3003, 3004],
                    Nombre = ["Arias", "Benítez", "Calderón", "Díaz"],
                    Generación = [2020, 2021, 2020, 2019]
)
examen = DataFrame(Cuenta = [3001, 3002, 3004, 3005],
                   Apellido = ["Arias", "Benítez", "Cisneros", "Enríquez"], 
                   Calif = [9, 10, 5, 7]  
)
innerjoin(alumnos, examen, on = [:ID => :Cuenta, :Nombre => :Apellido])


## Ordenar por columnas
#  sort  sort!

df = DataFrame(Edad = [20, 20, 19, 21, 20, 22, 20, 21],
               Estatura = [1.73, 1.85, 1.64, 1.71, 1.85, 1.59, 1.66, 1.69],
               Peso = [73, 81, 65, 78, 79, 69, 71, 89]
)

sort(df) # priorizando ordenamiento de columnas de izquierda a derecha

sort(df, rev = true)

sort(df, :Estatura)

sort(df, [:Estatura, :Peso])

sort(df, [:Edad, :Peso])

sort(df, [:Peso, :Edad])

sort(df, [:Edad, :Peso], rev = [false, true])

df
sort!(df, [:Edad, :Peso], rev = [false, true])
df


## Valores faltantes (missing)
#  skipmissing  coalesce  dropmissing  dropmissing!
#  allowmissing  allowmissing!  disallowmissing  disallowmissing!
#  passmissing  nonmissingtype

missing
typeof(missing)

x = [1, 2, missing, 2, 1, 1, missing, 3, 2]
typeof(x)
eltype(x)

skipmissing(x)
collect(skipmissing(x))
sum(x)
sum(skipmissing(x))

coalesce.(x, 0)
replace(x, missing => 0)
coalesce.(x, 0) == replace(x, missing => 0)

# `replace` versus `coalesce`

z = rand([1, 2, missing], 100)
@btime coalesce.(z, 0);
@btime replace(z, missing => 0); # Aprox 4 veces más rápido

df = DataFrame(ID = 1:5,
               X = [1, missing, 3, missing, 5],
               Y = ['A', 'B', missing, missing, 'E']
)
dropmissing(df)
df
dropmissing!(df)
df

df = DataFrame(ID = 1:5,
               X = [1, missing, 3, missing, 5],
               Y = ['A', 'B', missing, missing, 'E']
)
dropmissing(df, :X)
dropmissing(df, :Y)
dropmissing(df, [:X, :Y])
dropmissing!(df)

df
push!(df, [66, missing, 'Z']) # ERROR
allowmissing!(df)
push!(df, [66, missing, 'Z'])
df
disallowmissing!(df, [:ID, :Y])
df
