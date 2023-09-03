### 3. Fusión de DataFrames (joins)
### Por Dr. Arturo Erdely con base en https://dataframes.juliadata.org/stable/ 

# Requiere haber instalado previamente los paquetes 
# DataFrames, CSV

using CSV, DataFrames


## Tipos  de joins

# innerjoin

alumnos = DataFrame(ID = [3001, 3002, 3003, 3004], Nombre = ["Arias", "Benítez", "Calderón", "Díaz"])
examen = DataFrame(ID = [3001, 3002, 3004, 3005], Calif = [9, 10, 5, 7])
innerjoin(alumnos, examen, on = :ID) # ID es la columna pivote

# leftjoin

alumnos
examen
leftjoin(alumnos, examen, on = :ID)

# rightjoin

alumnos
examen
rightjoin(alumnos, examen, on = :ID)

# outerjoin

alumnos
examen
outerjoin(alumnos, examen, on = :ID)

# semijoin

alumnos
examen
semijoin(alumnos, examen, on = :ID)

# antijoin

alumnos
examen
antijoin(alumnos, examen, on = :ID)

# crossjoin

alumnos
examen
crossjoin(alumnos, examen, makeunique = true)

# leftjoin!

alumnos_copia = copy(alumnos)
examen
leftjoin(alumnos_copia, examen, on = :ID)
alumnos_copia
leftjoin!(alumnos_copia, examen, on = :ID)
alumnos_copia


## Si la columna pivote se llama diferente en los DataFrames

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
outerjoin(alumnos, examen, on = [:ID => :Cuenta, :Nombre => :Apellido])
