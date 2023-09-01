### Un poquito de Álgebra Lineal: Paquete `LinearAlgebra` de la biblioteca estándar de Julia
### Por Arturo Erdely 

#=
 **Advertencia** Aquí se aborda muy poco de lo mucho que tiene este paquete,
 recomiendo revisar el manual completo del mismo en:
 https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/ 
=#


# `transpose` e `inv` están exportadas al módulo `Base` y por tanto
# no requieren haber cargado el paquete `LinearAlgebra`

parentmodule(transpose)
parentmodule(inv)

# `transpose`

M = [1 2 3; 4 5 6; 7 8 5]
transpose(M)

# `inv`

methods(inv)
inv(3)
3 * inv(3)
inv(M)
round.(M * inv(M), digits=4) # matriz identidad, como era de esperarse


### `LinearAlgebra`

using LinearAlgebra


## Algunas transformaciones (además de `transpose` e `inv` del módulo `Base`)

# diagonales de una matriz

A = [1 2 3; 4 5 6; 7 8 9]
diag(A)
diag(A, 0)
diag(A, 1)
diag(A, 2)
diag(A, -1)
diag(A, -2)
diag(A, -3)

diagind(A)
A[diagind(A)] .= 1_000
display(A)

# `tr`: traza de una matriz (cuadrada), es decir suma de elementos de su diagonal

display(M)
tr(M)
sum(diag(M))
tr(rand(2, 3)) # ERROR porque no es matriz cuadrada
A = rand(100, 100);
@time tr(A) # más rápido que:
@time sum(diag(A)) #más lento e ineficiente que `tr`

# `det`: determinante de una matriz cuadrada

display(M)
det(M)

# `eigvals`  `eigvecs`

e = eigvals(M)
sum(e) # teóricamente igual a `tr(M)`, diferencia numérica por redondeo
V = eigvecs(M)
iV = inv(V)
D = round.(iV * M * V, digits=6) # = matriz diagonal de eigenvalores
[diag(D) e]


## Algunas operaciones con matrices y vectores

# multiplicación

display(M)
round.(M * inv(M), digits=4) # matriz identidad, como era de esperarse

rand(3, 5) * rand(5, 4) # resulta matriz de 3×4
rand(3, 5) * rand(3, 5) # ERROR porque no son compatibles para multiplicación matricial 

rand(3, 5) .* rand(3, 5) # matriz 3×5 por ser multiplicación entrada por entrada

z = [10,100,1000]
M * z
z * M # ERROR
transpose(z) * M


#= división
  A\B es la solución para X en la ecuación AX=B cuando A es matriz cuadrada
  A/B es la solución para X en la ecuación A=XB cuando A es matriz cuadrada
=#

A = [1 2 3; 4 5 6; 7 8 5]
X = [2 4 9; 3 8 7; 1 2 1]
B = A * X
A \ B # igual a X como era de esperarse

X = [4 3; 1 5; 8 7]
B = A * X
A \ B

B = [9 8 7; 6 5 4]
A = X * B
A / B 


# `dot`: producto interno (o producto punto)

x = [1,2,3]
y = [10, 100, 1000]
dot(x,y) # producto interno de 2 vectores
x ⋅ y # o bien con el operador binario \cdot + tecla de tabulación
# es lo mismo que:
sum(x .* y) # pero más lento:
u = rand(1_000_000);
v = rand(1_000_000);
@time u ⋅ v # ejecutar 2 veces
@time sum(u .* v) # ejecutar 2 veces

dot(x, A, y) # es lo mismo que:
x ⋅ (A * y) # pero esto último es más lento

x = rand(1_000);
y = rand(1_000);
A = rand(1_000, 1_000);
@time dot(x, A, y) # ejecutar 2 veces
@time x ⋅ (A * y) # ejecutar 2 veces

# `norm`: norma Lp de un vector o matriz
# norm(A, p) = sum(abs.(A) .^ p) ^ (1/p)

norm([3, -4]) # por default L2
norm([3, -4], 2) # p = 2
norm([3, -4], 1) # p = 1
norm([3, -4], 1.5) # p = 1.5
norm([3, -4], Inf) # p = ∞  es decir el máximo en valor absoluto
norm([3, -4], -Inf) # p = -∞  es decir el mínimo en valor absoluto
norm([3, -4], -1) 

w = rand(1_000);
@time norm(w) # ejecutar 2 veces
@time sum(abs.(w) .^ 2) ^ (1/2) # ejecutar 2 veces

# potencias enteras (las no enteras tienen otras implicaciones, ver manual)

A = [1 2 3; 4 5 6; 7 8 9]
A * A
A ^ 2
A .^ 2
