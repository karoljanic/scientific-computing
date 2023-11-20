# Karol Janic
# 13.11.2023
# Lista 3, zad 4

include("ZeraFunkcji.jl")

f = x -> sin(x) - (x / 2.0)^2.0
pf = x -> cos(x) - (x / 2.0)

delta = 0.5e-5
epsilon = 0.5e-5
maxIter = 256

a = 1.5
b = 2.0
wynikBisekcji = ZeraFunkcji.mbisekcji(f, a, b, delta, epsilon)

x0 = 1.5
wynikStycznych = ZeraFunkcji.mstycznych(f, pf, x0, delta, epsilon, maxIter)

x0 = 1.0
x1 = 2.0
wynikSiecznych = ZeraFunkcji.msiecznych(f, x0, x1, delta, epsilon, maxIter)

println(wynikBisekcji)
println(wynikStycznych)
println(wynikSiecznych)
