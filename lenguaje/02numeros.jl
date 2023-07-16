### Números en Julia
### Por Arturo Erdely basado en https://docs.julialang.org/en/v1/

## Enteros ##
# typeof  typemin  typemax  bitstring

println(typeof(1)) # tipo de elemento
println(Sys.WORD_SIZE) # Tamaño de las palabras (bloques de memoria) en la computadora
println(Int, "\t", UInt) # tipo de enteros con y sin signo

# típicamente el tamaño de palabras es a 64 bits
println(typemin(Int64), "\t", typemax(Int64)) # enteros a 64 bits con signo, mínimo y máximo
println(bitstring(typemin(Int64))) # representación binaria del mínimo
println(bitstring(typemax(Int64))) # representación binaria del máximo
println(typemin(UInt64), "\t", typemax(UInt64)) # enteros a 64 bits sin signo, mínimo y máximo
println(bitstring(typemin(UInt64))) # representación binaria
println(bitstring(typemax(UInt64))) # representación binaria

x = typemax(Int64)
println(x, "\t", typeof(x))
y = x + 1 # overflow: ¡brinca al más pequeño!
z = x + 2 # overflow: ¡brinca al segundo más pequeño!
println(y, "\t", typeof(y))
println(z, "\t", typeof(z))

# Se pueden definir enteros a 128 bits:
println(typemin(Int128), "\t", typemax(Int128)) # enteros a 128 bits con signo, mínimo y máximo
println(bitstring(typemin(Int128))) # representación binaria del mínimo
println(bitstring(typemax(Int128))) # representación binaria del máximo
println(typemin(UInt128), "\t", typemax(UInt128)) # enteros a 128 bits sin signo, mínimo y máximo
println(bitstring(typemin(UInt128))) # representación binaria
println(bitstring(typemax(UInt128))) # representación binaria
println(x, "\t", typeof(x))
xx = Int128(x)
println(xx, "\t", typeof(xx))
println(xx + 1) # no hay overflow como con x + 1

# Si se van a realizar operaciones con números enteros que exceden el rango
# mínimo y máximo posible con enteros a 128 bits, hay que utilizar enteros
# de precisión arbitraria, de otra forma se pueden obtener resultados inesperados:
println(3^500) # que arroja un resultado negativo y absurdo
# Hay que definir el número entero con precisión arbitraria
b = BigInt(3)
println(typeof(b))
println(b^500) 
# Los enteros definidos mediante el tipo `BigInt` no tienen representación en bits,
# y por tanto las operaciones artiméticas con ellos no son tan veloces como con
# números que sí tienen representación de bits, esto sería notorio si se realiza
# una gran cantidad de cálculos.

# también hay enteros a 8, 16 y 32 bits, por ejemplo:
println(typemin(Int8), "\t", typemax(Int8)) # enteros con signo, mínimo y máximo a 8 bits
println(bitstring(typemin(Int8))) # representación binaria
println(bitstring(typemax(Int8))) # representación binaria
println(typemin(UInt8), "\t", typemax(UInt8)) # enteros sin signo, mínimo y máximo a 8 bits
println(bitstring(typemin(UInt8))) # representación binaria
println(bitstring(UInt8(127))) # representación binaria
println(bitstring(typemax(UInt8))) # representación binaria

# La diferencia está la cantidad de memoria que ocupa cada tipo:
e8 = Int8(5)
e16 = Int16(5)
e32 = Int32(5)
e64 = Int64(5)
e128 = Int128(5)
eBig = BigInt(5)
bitstring(e8)
sizeof(e8) # en bytes, recuerda 1 byte = 8 bits
bitstring(e16)
sizeof(e16)
bitstring(e32)
sizeof(e32)
bitstring(e64)
sizeof(e64)
bitstring(e128)
sizeof(e128)
Base.summarysize(e128)
# eBig no tiene representación binaria
sizeof(eBig)
Base.summarysize(eBig)
# utiliza la ayuda para entender la diferencia entre `sizeof`` y `Base.summarysize` 


## Números de punto flotante ##
# sizeof   100_000   0.000_001  reinterpret 

x = 1
println(typeof(x))
x = 1.0
println(typeof(x))
println(2.3e3, "\t", 2.5e-4, "\n")

println(1, "\t", typeof(1), "\t", sizeof(1), "\n") # sizeof -> tamaño en bytes
println(1.0, "\t", typeof(1.0), "\t", sizeof(1.0), "\n")

println(10^6, "\t", typeof(10^6), "\t", sizeof(10^6), "\n") 
println(2.3e6, "\t", typeof(2.3e6), "\t", sizeof(2.3e6), "\n")
println(10_000 + 1, "\t", 0.000_001 + 1, "\n") # se puede utilizar _ como separador

# dos ceros en el caso float
bitstring(5)
length(bitstring(5))
# el símbolo ≡ se obtiene mediante \equiv + tecla TAB y determina
# equivalencia en representación de bits 
println(0 == -0, "\t", 0 ≡ -0) 
println(bitstring(0))
println(bitstring(-0))
println(0.0 == -0.0, "\t", 0.0 ≡ -0.0)
println(bitstring(0.0))
println(bitstring(-0.0))

println(bitstring(2), "\t", length(bitstring(2)))
println(bitstring(2.0), "\t", length(bitstring(2.0)))
println(bitstring(2.1), "\t", length(bitstring(2.1)))

# Inf  -Inf  NaN

println(1/0, "\t", 2.0/0, "\t", -3/0, "\t", 4.1/Inf, "\t", 0/0, "\t", 0*Inf)
println(0*Inf, "\t", false*Inf, "\t", 0*(-Inf), "\t", false*(-Inf))
println(typeof(NaN), "\t", typeof(Inf), "\t", typeof(-Inf))

println(NaN, "\t", typeof(NaN))
println(0/0, "\t", typeof(0/0))
println(0.0/0.0, "\t", typeof(0.0/0.0))

println(0/0, "\t", NaN*0, "\t", NaN*false, "\t", (0/0)*false)

println(bitstring(reinterpret(UInt64, 0/0)))
println(bitstring(reinterpret(UInt64, NaN))) # un bit de diferencia

println(0/0 == NaN, "\t", 0/0 === NaN)
println(-0.0 == 0.0, "\t", -0.0 === 0.0)

# Precisión de máquina (epsilon)
# eps  prevfloat  nextfloat

x = 10.0
ε = eps(x) # distancia al Float64 más pequeño pero mayor que x
xε = x + ε
println(x, "\t", ε, "\t", xε, "\t", nextfloat(x), "\t", prevfloat(x))
println(xε == nextfloat(x), "\t", xε ≡ nextfloat(x))
bitstring(x)
bitstring(nextfloat(x))


## Aritmética de precisión arbitraria ##
# BigInt  BigFloat  parse  factorial

function que(x)
    println(x, "\t typeof: ", typeof(x), "\t sizeof: ", sizeof(x))
end

n = typemax(Int64)
que(n)
que(n + 1)
que(BigInt(n))
que(BigInt(n) + 1)

println(parse(Int64, "9223372036854775807")) # máximo valor Int64
println(parse(Int64, "9223372036854775899")) # ERROR: Int64 overflow
println(parse(BigInt, "9223372036854775899")) # tipo BigInt
m = parse(BigInt, "9223372036854775899")
que(m + 1)

que(factorial(20))
que(factorial(21)) # ERROR: overflow
que(factorial(20)*21) # INCOHERENCIA por overflow
que(factorial(BigInt(21)))
que(BigInt(factorial(20))*21)
println(factorial(BigInt(21)) == BigInt(factorial(20))*21)
que(factorial(BigFloat(21)))

x = typemax(Float64)
que(x)
que(x + 1)
que(BigFloat(x))
que(BigFloat(x) + 1)

x = typemin(Float64)
que(x)
que(x + 1)
que(BigFloat(x))
que(BigFloat(x) - 1)

que(2.3^852)
que(2.3^853)
que(BigFloat(2.3)^853)

# Cuidado con: setrounding  setprecision


## Números racionales ## 
# 2//3  numerator  denominator  float  Rational

pq = 6//9
que(6)
que(pq)
numerator(pq)
denominator(pq)
float(pq)
Rational(float(pq))


## Números complejos
# im  real  imag  conj  abs  abs2  angle
 
que(im)
im^2

sqrt(-1) # error
sqrt(-1 + 0im)
√(-1 + 0im) # \sqrt seguido de tecla TAB

c1 = 3 + im
c2 = 2 - 3.1im
c3 = 4 + 5//6im
que(c1)
que(c2)
que(c3)
real(c1)
imag(c1)
conj(c1)
abs(c1)
abs2(c1)
angle(c1)


## Coeficientes

x = 3
2*x + 1 == 2x + 1
println(2^3x == 2^(3*x))
println((x-1)x)
println(x(x-1)) # ERROR


## Números irracionales

# π 
pi
π # \pi seguido de la recla TAB
que(π)
que(float(π))
que(big(π))

# ℯ
que(ℯ) # \euler seguido de tecla TAB 
ℯ
que(float(ℯ))
que(big(ℯ))

# gamma de euler
Base.MathConstants.eulergamma
γ # error
const γ = Base.MathConstants.eulergamma
que(γ)
que(float(γ))
γ = 3 # error: una constante declarada no puede ser redefinida

# proporción áurea
const ϕ = Base.MathConstants.golden
que(ϕ)
que(BigFloat(ϕ))

# constante de Catalan
catalan = Base.MathConstants.catalan
que(catalan)
que(float(catalan))


## zero  one

x = 5
cero = zero(x)
uno = one(x)
println(cero, " ", typeof(cero), "\t", uno, " ", typeof(uno), "\n")

x = 6.0
cero = zero(x)
uno = one(x)
println(cero, " ", typeof(cero), "\t", uno, " ", typeof(uno), "\n")
