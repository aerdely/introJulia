### 4. Dataframesa agrupados
### Por Dr. Arturo Erdely con base en https://dataframes.juliadata.org/stable/ 

# Requiere haber instalado previamente los paquetes 
# DataFrames, CSV

using CSV, DataFrames, Statistics

path = joinpath(pkgdir(DataFrames), "docs", "src", "assets", "iris.csv")
iris = CSV.read(path, DataFrame)


## Dataframes agrupados: `groupby`

describe(iris)
sort(unique(iris.Species))
iris_gdf = groupby(iris, :Species)
typeof(iris_gdf)
size(iris_gdf)
collect(iris_gdf)

iris_gdf[1]
typeof(iris_gdf[1])
iris_gdf[2]
iris_gdf[3]
names(iris_gdf)
k = keys(iris_gdf)
iris_gdf[k[1]]
iris_gdf[k[1]] == iris_gdf[1]
iris_gdf[k[1]] === iris_gdf[1]
propertynames(iris_gdf)
iris_gdf.parent == iris, iris_gdf.parent === iris
iris_gdf.cols
iris_gdf.groups
iris_gdf.idx
iris_gdf.starts
iris_gdf.ends
iris_gdf.ngroups
iris_gdf.keymap
iris_gdf.lazy_lock

combine(iris_gdf, :PetalLength => mean)
combine(iris_gdf, nrow, proprow, groupindices)
combine(iris_gdf, nrow, :PetalLength => mean => :mean)
combine(iris_gdf, [:PetalLength, :SepalLength] => ((p,s) -> (a=mean(p)/mean(s), b = sum(p))) => AsTable)
combine(iris_gdf, eachindex)

iris_gdf
select(iris_gdf, 1:2)
select(iris_gdf, 1:2 => cor)
select(iris_gdf, 1:2 => cor => :SlenSwidCor)
transform(iris_gdf, 1:2 => cor => :SlenSwidCor)


## Operaciones de filas (independientes de columnas)
#  nrow  proprow  groupindices  eachindex

df = DataFrame(id_cliente = ["a", "b", "b", "b", "c", "c"],
               id_compra = [12, 15, 19, 17, 13, 11],
               volumen = [2, 3, 1, 4, 5, 9]
)
gdf = groupby(df, :id_cliente, sort = true)
show(gdf, allgroups = true)

combine(gdf, nrow)
combine(gdf, nrow => "num_ops")
combine(gdf, proprow => "prop_ops")
combine(gdf, groupindices => "clave_grupo")
transform(gdf, groupindices => "clave_grupo")
groupindices(gdf)
combine(gdf, eachindex)
select(gdf, eachindex, groupindices)
