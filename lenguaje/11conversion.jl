### Conversión y promoción
### Por Arturo Erdely basado en https://docs.julialang.org/en/v1/

## Conversión
#  typeof  convert  parse  oftype  rationalize

function t(tipo)
    if isa(tipo, DataType)
        println("\nsupertipo:\t", supertype(tipo))
        println("Tipo:\t\t", tipo)
        println("subtipos:\t", subtypes(tipo))
    else
        println("\n$tipo no es un DataType válido")
    end
    return nothing
end

function q(x)
    println()
    println(x, "\t", typeof(x), "\t", sizeof(x), " bytes")
end

x = 9
q(x)
x_UInt8 = convert(UInt8, x)
q(x_UInt8)
display(x_UInt8)
t(AbstractFloat)
x_AF = convert(AbstractFloat, x)
q(x_AF)
x_BF = convert(BigFloat, x)
q(x_BF)

A = Any[1 2 3; 4 5 6]
q(A)
display(A)

A_F = convert(Array{Float64}, A)
q(A_F)
display(A_F)

y = convert(Int64, "1234") # ERROR
y = parse(Int64, "1234")
q(y)

x = √2
q(x)
xBF = √BigFloat(2)
q(xBF)
y = convert(Float64, xBF)
q(y)
q(x - y)
println(x == y, "\t", x ≡ y)
z = convert(BigFloat, y)
q(z)
q(xBF - z)
println(xBF == z, "\t", xBF ≡ z)

x = 1//6
q(x)
xBF = convert(BigFloat, x)
q(xBF)
q(xBF - x)
println(x == xBF, "\t", x ≡ xBF)
y = convert(Rational{Int64}, xBF)
q(y)
q(y - x)
println(x == y, "\t", x ≡ y)

x = 4; y = 3.0;
oftype(x, y)
oftype(y, x)

convert(Rational, 5.6)
rationalize(5.6)
28/5


## Promoción
#  promote

entero  = 3
racional = 2//3
flotante = 4.0
q(entero)
q(racional)
q(flotante)

er = (entero, racional)
ef = (entero, flotante)
rf = (racional, flotante)

q(promote(entero, racional))
q(promote(entero, flotante))
q(promote(racional, flotante))
