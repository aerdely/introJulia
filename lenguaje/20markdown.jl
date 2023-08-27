### Paquete Markdown de la biblioteca estándar de Julia
### Por Arturo Erdely


## Esto no requiere el paquete

# Uso de colores y estilos

Docs.doc(printstyled)

printstyled("Rojo", bold = true, color = :red)
printstyled("Azul", underline = true, color = :blue)
printstyled("Fondo amarillo", color = :yellow, reverse = true)

for i ∈ 1:256
    printstyled(string(i) * "  ", bold = true, color = i)
end


## Markdown

using Markdown

md"Hola"

md"Para que se vea en *itálicas* o bien *subrayado* (dependiendo del entorno)"

md"Para que se vea en **negritas**"

md"Para instrucción de sistema (azul), por ejemplo `println`"

md"Sintaxis de matemáticas (violeta), por ejemplo ``x²``"

md"Una liga de internet, por ejemplo [Julia](http://www.julialang.org)."

md"""
*Entorno multilínea*

La **siguiente** línea
"""

md"Está por ejemplo la función [`print`](@ref) que es **muy** útil."
# En algunos entornos genera una liga a la documentación de la función `print`

md"""# Encabezado
Bla Bla
## Segundo nivel
Bla bla
### Tercer nivel
Bla bla
"""

md"""
Aquí empieza el rollo...

    Por la indentación de 4 espacios esto es código

Sigue el rollo...
"""

# también así
md"""
Bla bla bla
```julia 
function patito(x)
    x + 1
end
```
Bla bla."""


citas = md"""
Ahora unas citas:

> Primera cita

> Segunda cita

> Tercera cita

Y se terminaron.
"""

typeof(citas)
citas
println(citas)
display(citas)


md"""# Listas
Ahora una lista de cosas:
- cosa 1
- cosa 2
- cosa 3
Y se terminó la lista."""

md"""## Sublistas
Otra lista más sofisticada:
- cosa 1
```julia
     varinfo()
```
- cosa 2 
    + subcosa 2.1
    + subcosa 2.2
- cosa 3

Y se terminó la lista.
"""  

md"""### Lista ordenada
1. uno
2. dos 
3. tres
9. cuatro
Adiós."""
# Nótese que corrigió el 9 por el 4

md"""
```math
F(x) = \\int_{-\\infty}^x f(t)dt 
```
"""
# código LaTeX


md"""
Arriba de la línea

---

Abajo de la línea"""


# Tablas

md"""
| Columna 1 | Columna 2 | Columna 3 |
|:----------| --------- |:---------:|
| Fila `1`  | Col `2`   |           |
| *Fila* 2  | **Fil** 2 | Col ``3`` |
"""
