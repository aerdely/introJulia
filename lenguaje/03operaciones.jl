### Operaciones matemáticas y funciones elementales
### Por Arturo Erdely basado en https://docs.julialang.org/en/v1/

## Operadores aritméticos
#  inv  div  rem

2 + 3
2 - 3
2 * 3
2 / 3
2 \ 3 
2 ^ 3
inv(3) # 1/3
inv(4//9)
sqrt(2)
√2 # \sqrt + TAB 
cbrt(27)
∛27 # \cbrt + TAB 
div(9, 4) # división entera
9 ÷ 4 # \div + TAB
rem(9, 4) # residuo de la división entera
9 % 4
divrem(9, 4)


## Multiplicación por cero débil y fuerte

NaN * 0.0
NaN * false 
Inf * 0.0
Inf * false
(-Inf) * 0.0
(-Inf) * false


## Operaciones de bits

##  ~  &  |  ⊻  ⊼  ⊽  >>>  >>  <<

function quebit(x)
    xBit = bitstring(x)
    xType = typeof(x)
    println(x, "\t", xType, "\n", xBit, "\n", length(xBit), " bits \n")
    return nothing
end

quebit(7)
quebit(~7)

function bitops(x, y)
    println("x = ", x, "\t", "y = ", y)
    println(bitstring(x), "\n", bitstring(y), "\n")
    println("x & y = ", x & y)
    println("x | y = ", x | y)
    println("x ⊻ y = ", x ⊻ y) # \xor + TAB para obtener ⊻
    println("x ⊼ y = ", x ⊻ y) # \nand + TAB para obtener ⊼
    println("x ⊽ y = ", x ⊻ y) # \nor + TAB para obtener ⊽ 
    println("x >>> y = ", x >>> y)
    println("x >> y = ", x >> y)
    println("x << y = ", x << y)
    return nothing
end

bitops(2, 3)


## Operadores incrementales
#  +=  -=  *=  /=  \=  ÷=  %=  ^=  &=  |=  ⊻=  >>>=  >>=  <<=

x = 3
x += 2
x *= 7
x /= 5
x ^= 2


## Operaciones vectorizadas

println([1, 2, 3] .^ 2)
println([1, 2, 3] .+ 1)
x = [1, 2, 3]
x .-= 1
println([1, 2, 3] .* [0, 1, 2])

function f(x)
    return x^2 - 1
end
x = 2
f(x)
x = [1, 2, 3]
f(x) # error
f.(x) 
println("x = ", x, "\t f.(x) = ", f.(x))

x = [1, 2, 3]
y = [10, 100, 1_000]
x + y  # operación suma de vectores
x .+ y # operación vectorizada de suma de números
x * y # error 
x .* y 

sum(x .* y) # producto interno
# o bien con el paquete de la biblioteca estándar: LinearAlgebra
using LinearAlgebra
x ⋅ y  #  \cdot + tecla TAB


## Comparaciones numéricas
#= 
==  (igualdad)
!=  o bien  ≠ (\ne + TAB)
<   
<=  o bien  ≤  (\le + TAB)
>   
>=  o bien  ≥  (\ge + TAB)
=#

3 == 3
3 == 4
3 ≠ 3
3 ≠ 4
-Inf < Inf
println(-0.0 == 0.0, "\t", -0.0 ≡ 0.0) # \equiv ≡
println(-0.0 < 0.0, "\t", -0.0 ≤ 0.0, "\t", -0.0 ≥ 0.0)
println(-0 == 0, "\t", -0 ≡ 0)
println(-0 < 0, "\t", -0 ≤ 0, "\t", -0 ≥ 0)
println(-Inf < Inf, "\t", Inf == (Inf + 1), "\t", Inf ≡ (Inf + 1))
println(NaN == NaN, "\t", NaN ≠ NaN, "\t", NaN === NaN, "\t", NaN < NaN, "\t", NaN ≤ NaN)
println(typeof(NaN), "\t", sizeof(NaN))

x = [1, 2, 3]
println(2 .≤ x)

# sign  cmp 

sign(4)
sign(-3)
sign(0)
cmp(2,3)
cmp(3,2)
cmp(3,3)

#=
isequal(x, y)  debiera ser isequiv porque funciona como ≡
isfinite(x)  isinf(x)
isnan(x)
iseven  isodd  isapprox
hash
=#

function isque(x, y)
    println("isequal ", x, " ", y, "\t", isequal(x, y))
    println("isfinite ", x, " ", isfinite(x))
    println("isinf ", x, " ", isinf(x))
    println("isnan ", x, " ", isnan(x))
    return nothing
end

println(-0.0 == 0.0, "\t", -0.0 ≡ 0.0)
isque(-0.0, 0.0)

println(-0 == 0, "\t", -0 ≡ 0)
isque(-0, 0)

isque(-Inf, Inf)
isque(NaN, Inf)

println(NaN == NaN, "\t", NaN ≡ NaN)
isque(NaN, NaN)

println(iseven(0), "\t", isodd(0)) # es par o impar


# comparaciones encadenadas

println(1 < 2 <= 2 < 3 == 3 > 2 >= 1 == 1 < 3 != 5)
println(0 < 1 < 2 < 3 < 2)

x = [1, 2, 3, 4, 5]
println(2 .< x .< 5)
println(1 .≤ x .< 6)


## Redondeo
#  round  floor  ceil  trunc

x = 2.5
xr = round(x)
xri = round(Int64, x)
println(xr, "\t", typeof(xr))
println(xri, "\t", typeof(xri))

x = 3.5
xr = round(x)
xri = round(Int64, x)
println(xr, "\t", typeof(xr))
println(xri, "\t", typeof(xri))

x = -2.5
xr = round(x)
xri = round(Int64, x)
println(xr, "\t", typeof(xr))
println(xri, "\t", typeof(xri))

x = -3.5
xr = round(x)
xri = round(Int64, x)
println(xr, "\t", typeof(xr))
println(xri, "\t", typeof(xri))

x = -3.1
println(x, "\t", floor(x), "\t", ceil(x), "\t", trunc(x))


#=
div  fld  cld  rem  mod  mod2pi  divrem  fldmod  gcd  lcd  clamp  binomial
abs  abs2  sign  signbit  copysign  flipsign  digits  ndigits
sqrt √   cbrt ∛  fourthroot ∜  hypot  exp  log  exponent  modf  evalpoly
sin cos tan sinh atan etc.  sinpi  cospi  sind  etc.
=#


## Funciones especiales

# --> instalar paquete SpecialFunctions.jl


#= Conjuntos
∩  intersect  intersect!  ∪  union  union!  length  isempty
setdiff  setdiff! # symdiff  symdiff!  issetequal
∈  in  ∉  ⊆  issubset  isdisjoint
⊊  ⊈  push!  append!  Set 
=#

A = [1, 2, 3, 4]
B = [3, 4, 5, 6]

A ∩ B # \cap + TAB = ∩
intersect(A, B)

A ∪ B # \cup + TAB = ∪
union(A, B)

C = [100, 1000]
A ∩ B ∩ C
isempty(A ∩ B ∩ C)
length(A ∩ B ∩ C)
A ∪ B ∪ C
length(A ∪ B ∪ C)

A ∩ B ∪ C
(A ∩ B) ∪ C
A ∩ (B ∪ C)

A, B
setdiff(A, B), setdiff(B, A)

AB = symdiff(A, B)
BA = symdiff(B, A)
AB, BA

AB == BA
issetequal(AB, BA)

println(AB)
2 in AB
2 ∈ AB # \in + TAB = ∈
2 ∉ AB # \notin + TAB = ∉
!(2 in AB) 

issubset([1, 2, 3], [3, 1, 2])
issubset([1, 2], [2, 3, 4])

A = [1, 2, 3]
B = [3, 4, 5]
C = A ∪ B
D = A ∩ B
C, D

A ⊆ B, A ∩ B ⊆ B
A ⊆ B, A ∩ B ⊆ B
A ∩ B ⊆ A ⊆ D

# Set

 A1 = [1, 2, 3]
 typeof(A1), sizeof(A1)
 A2 = Set([1, 2, 3])
 typeof(A2), sizeof(A2)

A1[2]
A2[2] # error

length(A1)
length(A2)

A3 = Set([3, 4, 5])
A2 ∪ A3 
A1 ∪ A3 