### Fechas: paquete `Dates` de la biblioteca estándar de Julia
### Por Arturo Erdely 

using Dates 


## Definir objetos tipo fecha
#  Date  DateTime

typeof(Date)
supertype(Date)
supertypes(Date)
subtypes(Date)
dump(Date)
fieldnames(Date)

d = Date(2001, 9, 11)
typeof(d)
Date(2001, 9)
Date(2023)

typeof(DateTime)
supertype(DateTime)
supertypes(DateTime)
subtypes(DateTime)
dump(DateTime)
fieldnames(DateTime)

DateTime(2001)
DateTime(2001,9)
DateTime(2001,9,11)
DateTime(2001,9,11,8)
DateTime(2001,9,11,8,46,40)
DateTime(2001,9,11,8,46,40,5)


## Convertir DateTime a Date

Date(DateTime(2001,9,11,8,46,40,5)) # trunca la parte de tiempo


## Convertir texto a tipo fecha
#  Date  dateformat""  DateFormat  parse  tryparse

Date("28/6/2021", dateformat"d/m/y")
Date("28062021", dateformat"ddmmyyyy")

formato = DateFormat("ddmmyyyy")
typeof(formato)
Date("28062021", formato)

años = ["2020", "2021"]
Date.(años, DateFormat("yyyy"))

# también se puede convertir con `parse` y `tryparse` con la ventaja en el 
# último caso de que no arroja error en caso de no resultar posible la conversión
parse(Date, "11.9.2001", dateformat"d.m.y")
tryparse(Date, "11.9.2001", dateformat"d.m.y")
parse(Date, "11.X.2001", dateformat"d.m.y") # ERROR
a = tryparse(Date, "11.X.2001", dateformat"d.m.y") # nothing
isnothing(a)


## Duración y comparaciones
#  dump  DateTime

f1 = Date(2022, 1, 1)
f2 = Date(2022, 1, 6)
dump(f1)
dump(f2)
f2 > f1
f2 - f1
typeof(f2 - f1)
f1 + f2 # ERROR

dump(Date(1, 1, 1))

f3 = DateTime(2001, 9, 11)
f4 = DateTime(2001, 9, 12)
typeof(f3)
dump(f3)
dump(f4)
f4 - f3
typeof(f4 - f3)
(86_400_000 / 1_000) / (60 * 60) # 24 horas
f3 + f4 # ERROR


## Descomposición de Fechas
#=
Dates.year  Dates.month  Dates.week  Dates.day
Dates.Year  Dates.Month  Dates.Week  Dates.Day
Dates.yearmonth  Dates.monthday  Dates.yearmonthdy
Dates.value  Dates.daysinyear
=#

f = Date(2024, 2, 29) # nótese que 2024 es año bisiesto y febrero tiene día 29
Date(2023, 2, 29) # ERROR porque 2023 no es año bisiesto
año = Dates.year(f)
typeof(año)
Dates.month(f)
Dates.week(f) # Semana 9 de 52 (o 53 según sea el caso)
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

Dates.daysinyear(2023)
Dates.daysinyear(2024) # es año bisiesto


## Funciones de calendario
#  Dates.dayofweek  Dates.dayname  Dates.dayabbr  Dates.dayofweekofmonth
#  Dates.monthname  Dates.monthabbr  Dates.daysinmonth  Dates.isleapyear
#  Dates.dayofyear  Dates.quarterofyear  Dates.dayofquarter  trunc

f = Date(2022, 1, 9)
Dates.dayofweek(f)
Dates.dayname(f)
Dates.dayabbr(f)
Dates.dayofweekofmonth(f) # segundo domingo de enero
Dates.monthname(f)
Dates.monthabbr(f)
Dates.daysinmonth(f)
Dates.isleapyear(f)
Dates.isleapyear(Date(2024, 2, 15))

f = Date(2022, 2, 3)
Dates.dayofyear(f)
Dates.quarterofyear(f)
Dates.quarterofyear(Date(2022, 4, 1))
Dates.dayofquarter(Date(2022, 4, 15))

trunc(Date(2001,9,11), Day)
trunc(Date(2001,9,11), Month)
trunc(Date(2001,9,11), Year)

# días y meses en idioma español

español_meses = ["enero", "febrero", "marzo", "abril", "mayo", "junio", "julio", "agosto", "septiembre", "octubre", "noviembre", "diciembre"]
español_meses_abrev = ["ene", "feb", "mar", "abr", "may", "jun", "jul", "ago", "sep", "oct", "nov", "dic"]
español_días = ["lunes", "martes", "miércoles", "jueves", "viernes", "sábado", "domingo"]
español_días_abrev = ["lun", "mar", "mie", "jue", "vie", "sab", "dom"]
Dates.LOCALES["español"] = Dates.DateLocale(español_meses, español_meses_abrev, español_días, español_días_abrev)

f = Date(2022, 1, 7)
Dates.dayname(f; locale = "español")
Dates.dayabbr(f; locale = "español") 
Dates.monthname(f; locale = "español")
Dates.monthabbr(f; locale = "español")


## Funciones de tiempo
#  Time
#  Dates.hour  Dates.minute  Dates.second  
#  Dates.Hour  Dates.Minute  Dates.Second  
#  Dates.millisecond  Dates.microsecond  Dates.nanosecond
#  Dates.Millisecond  Dates.Microsecond  Dates.Nanosecond  trunc

f = DateTime(2001,9,11,8,46,40,5)
Date(f)
t = Time(f)
typeof(t)
t2 = Time(8) # hasta horas
t2 = Time(8,46) # hasta minutos
t2 = Time(8,46,40) # hasta segundos
t2 = Time(8,46,40,5) # hasta milisegundos
t2 = Time(8,46,40,5,8) # hasta microsegundos
t2 = Time(8,46,40,5,8,2) # hasta nanosegundos

Dates.hour(t2)
Dates.minute(t2)
Dates.second(t2)
Dates.millisecond(t2)
Dates.microsecond(t2)
Dates.nanosecond(t2)

Dates.Hour(t2)
typeof(Dates.Hour(t2))
Dates.Minute(t2)
Dates.Second(t2)
Dates.Millisecond(t2)
Dates.Microsecond(t2)
Dates.Nanosecond(t2)

trunc(Time(8,46,40,5,8,2), Nanosecond)
trunc(Time(8,46,40,5,8,2), Microsecond)
trunc(Time(8,46,40,5,8,2), Millisecond)
trunc(Time(8,46,40,5,8,2), Second)
trunc(Time(8,46,40,5,8,2), Minute)
trunc(Time(8,46,40,5,8,2), Hour)


## Aritmética de Fechas

Date(2022, 1, 29) + Day(1)
(Date(2022, 1, 29) + Day(1)) + Month(1)
Date(2022, 1, 29) + Month(1)
(Date(2022, 1, 29) + Month(1)) + Day(1)

#=
Si no se agrupa con paréntesis, primero se realizan las operaciones
con años, luego meses, semanas y días al final:
=#

(Date(2022, 1, 29) + Dates.Day(1)) + Dates.Month(1)
Date(2022, 1, 29) + Dates.Day(1) + Dates.Month(1)
Date(2022, 1, 29) + Dates.Month(1) + Dates.Day(1)

# secuencias de fechas

fechas1 = Date(2022,1,7):Day(1):Date(2022,2,15)
collect(fechas1)
println(collect(fechas1))

fechas2 = range(Date(2022,1,7), Date(2022,2,15), step = Day(1))
fechas1 == fechas2

collect(Date(2022,1,7):Day(2):Date(2022,1,16))
collect(range(Date(2022,1,7), Date(2022,1,16), step = Day(2)))

collect(Date(2022,1,7):Month(2):Date(2022,12,7))
collect(range(Date(2022,1,7), Date(2022,12,7), step = Month(2)))


## Fecha y hora actual

today()
typeof(today())
now()
typeof(now())


## Aritmética de tiempo

Time(8,46,40)
Time(8,46,40) + Second(30)
Time(8,46,40) + Minute(30)
Time(8,46,40) + Hour(2)
Time(8,46,40) + Hour(25)


## Redondeo
#  trunc  floor  ceil  round  

t = DateTime(2001,9,11,8,46,40,5)

trunc(t, Month)
trunc(t, Second)

floor(t, Day)
ceil(t, Day)
floor(t, Minute)
ceil(t, Minute)
round(t, Minute)