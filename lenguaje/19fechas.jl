### Fechas: paquete Dates de la biblioteca estándar de Julia
### Por Arturo Erdely 

using Dates 

## Definir objetos tipo fecha
#  Date

typeof(Date)
supertype(Date)
subtypes(Date)
dump(Date)

d = Date(2022, 4, 15)
typeof(d)
Date(2022, 4)
Date(2022)


## Convertir texto a tipo fecha
#  dateformat""  DateFormat

Date("28/6/2021", dateformat"d/m/y")
Date("28062021", dateformat"ddmmyyyy")

formato = DateFormat("ddmmyyyy")
typeof(formato)
Date("28062021", formato)

años = ["2020", "2021"]
Date.(años, DateFormat("yyyy"))


## Duración y comparaciones
#  dump  DateTime

f1 = Date(2022, 1, 1)
f2 = Date(2022, 1, 6)
dump(f1)
dump(f2)
f2 > f1
f2 - f1
typeof(f2 - f1)

dump(Date(1, 1, 1))

f3 = DateTime(2022, 1, 1)
f4 = DateTime(2022, 1, 6)
typeof(f3)
dump(f3)
dump(f4)
f4 - f3
typeof(f4 - f3)


## Descomposición de Fechas
#  Dates.year  Dates.month  Dates.week  Dates.day
#  Dates.Year  Dates.Month  Dates.Week  Dates.Day
#  Dates.yearmonth  Dates.monthday  Dates.yearmonthdy
#  Dates.value

f = Date(2024, 2, 29)
año = Dates.year(f)
typeof(año)
Dates.month(f)
Dates.week(f)
Dates.day(f)

añoTipo = Dates.Year(f)
typeof(añoTipo)
añoTipo / 2
añoTipo / 13 # error
añoTipo - 4 # error

mesTipo = Dates.Month(f)
typeof(mesTipo)
mesTipo / 2
mesTipo / 3 # error

semanaTipo = Dates.Week(f)
typeof(semanaTipo)
semanaTipo / 3
semanaTipo / 4 # error
semanaTipo + 1 # error

díaTipo = Dates.Day(f)
typeof(díaTipo)
díaTipo / 29
díaTipo - 2 # error

f
ym = Dates.yearmonth(f)
typeof(ym)
Dates.monthday(f)
Dates.yearmonthday(f)

dump(f)
f.instant
n = Dates.value(f)
typeof(n)


## Funciones de calendario
#  Dates.dayofweek  Dates.dayname  Dates.dayofweekofmonth
#  Dates.monthname  Dates.daysinmonth  Dates.isleapyear
#  Dates.dayofyear  Dates.quarterofyear  Dates.dayofquarter

f = Date(2022, 1, 9)
Dates.dayofweek(f)
Dates.dayname(f)
Dates.dayofweekofmonth(f) # segundo domingo de enero
Dates.monthname(f)
Dates.daysinmonth(f)
Dates.isleapyear(f)
Dates.isleapyear(Date(2024, 2, 15))

f = Date(2022, 2, 3)
Dates.dayofyear(f)
Dates.quarterofyear(f)
Dates.quarterofyear(Date(2022, 4, 1))
Dates.dayofquarter(Date(2022, 4, 15))

# días y meses en idioma español

español_meses = ["enero", "febrero", "marzo", "abril", "mayo", "junio", "julio", "agosto", "septiembre", "octubre", "noviembre", "diciembre"]
español_meses_abrev = ["ene", "feb", "mar", "abr", "may", "jun", "jul", "ago", "sep", "oct", "nov", "dic"]
español_días = ["lunes", "martes", "miércoles", "jueves", "viernes", "sábado", "domingo"]
español_días_abrev = ["lun", "mar", "mie", "jue", "vie", "sab", "dom"]
Dates.LOCALES["español"]  =Dates.DateLocale(español_meses, español_meses_abrev, español_días, español_días_abrev)

f = Date(2022, 1, 7)
Dates.dayname(f; locale = "español")
Dates.dayabbr(f; locale = "español") 
Dates.monthname(f; locale = "español")
Dates.monthabbr(f; locale = "español")


## Aritmética de Fechas

Date(2022, 1, 29) + Day(1)
(Date(2022, 1, 29) + Day(1)) + Month(1)
Date(2022, 1, 29) + Month(1)
(Date(2022, 1, 29) + Month(1)) + Day(1)

# Si no se agrupa con paréntesis, primero se realizan las operaciones con
# años, luego meses, semanas y días al final:

(Date(2022, 1, 29) + Dates.Day(1)) + Dates.Month(1)
Date(2022, 1, 29) + Dates.Day(1) + Dates.Month(1)
Date(2022, 1, 29) + Dates.Month(1) + Dates.Day(1)

# secuencias de fechas

fechas1 = Date(2022,1,7):Day(1):Date(2022,2,15)
collect(fechas)
println(collect(fechas))

fechas2 = range(Date(2022,1,7), Date(2022,2,15), step = Day(1))
fechas1 == fechas2

collect(Date(2022,1,7):Day(2):Date(2022,1,16))
collect(range(Date(2022,1,7), Date(2022,1,16), step = Day(2)))

collect(Date(2022,1,7):Month(2):Date(2022,12,7))
collect(range(Date(2022,1,7), Date(2022,12,7), step = Month(2)))


## Fecha y hora actual

now()
typeof(now())
