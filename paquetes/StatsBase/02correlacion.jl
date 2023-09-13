### Paquete `StatsBase`: Correlación
### Dr. Arturo Erdely

### Basado en: https://juliastats.org/StatsBase.jl/stable/  

using StatsBase


## Covarianza y correlación de Pearson
#  cov  scattermat  cor  cov2cor  cor2cov  StatsBase.cov2cor!  StatsBase.cor2cov!

n = 30;
x = randn(n); 
y = randn(n);
M = [x y];
cov(x, y)
var(x), var(y)
cov(M)
scattermat(M) / (n-1) # = cov(M)

scattermat(M)
scattermat(M, dims = 1)
scattermat(M, dims = 2)
aw = aweights(rand(n)) 
scattermat(M)
scattermat(M, aw)
cov(M)
cov(M, aw)
scattermat(M, aw) / aw.sum 
cov(M, aw, corrected = :true)
scattermat(M, aw) / (aw.sum - sum(aw.values .^ 2)/aw.sum)

cor(x, y)
cor(M)
cor(M, aw)

cov2cor(cov(M)) # cov --> cor
cor(M)
cor2cov(cor(M), [std(M[:, 1]), std(M[:, 2])]) # cor --> cov
cov(M)


## Medidas de concordancia

#  ordinalrank  competerank  denserank
begin
    D = [0.3, 0.5, 0.2, 0.1, 0.4]
    or = ordinalrank(D)
    println(D)
    println(or)
end
begin
    D = [.1, .2, .2, .2, .3, .3]
    or = ordinalrank(D)
    cr = competerank(D)
    dr = denserank(D)
    tr = tiedrank(D)
end;
d = Dict([:or, :cr, :dr, :tr] .=> ["ordinal", "compete", "dense", "tied"]);
for r ∈ [:or, :cr, :dr, :tr]
    println(d[r])
    display(hcat(D, eval(r)))
    println()
end

#  corspearman  corkendall

x = randn(30); 
y = randn(30);
M = [x y];
corspearman(x, y)
corspearman(M)
corkendall(x, y)
corkendall(M)

x = rand(30);
y = x .^ 10;
(corspearman(x, y), corkendall(x, y), cor(x, y))
(corspearman(log.(x), log.(y)), corkendall(log.(x), log.(y)), cor(log.(x), log.(y)))

z = rand(30);
(corspearman(x, z), corkendall(x, z), cor(x, z))
(corspearman(log.(x), log.(z)), corkendall(log.(x), log.(z)), cor(log.(x), log.(z)))

corspearman(x, z)
cor(ordinalrank(x), ordinalrank(z))
cor(competerank(x), competerank(z))
cor(denserank(x), denserank(z))
cor(tiedrank(x), tiedrank(z))

x = [3, 1, 2, 1, 3]
y = [8, 5, 5, 4, 8]
corspearman(x, y)
cor(ordinalrank(x), ordinalrank(y))
cor(competerank(x), competerank(y))
cor(denserank(x), denserank(y))
cor(tiedrank(x), tiedrank(y))


## Autocovarianza y autocorrelación
#  autocov  autocov!  autocor  autocor!  crosscov  crosscov!
#  crosscor  crosscor!  pacf  pacf!
