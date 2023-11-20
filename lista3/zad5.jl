# Karol Janic
# 13.11.2023
# Lista 3, zad 4

include("ZeraFunkcji.jl")

const e = MathConstants.e

f1 = x -> e^x
f2 = x -> 3*x
f = x -> f1(x) - f2(x)
delta = 10e-4
epsilon = 10e-4

a1 = 0.0
b1 = 1.0
a2 = 1.0
b2 = 2.0
a3 = 0.0
b3 = 2.0

wynikBisekcji1 = ZeraFunkcji.mbisekcji(f, a1, b1, delta, epsilon)
wynikBisekcji2 = ZeraFunkcji.mbisekcji(f, a2, b2, delta, epsilon)
wynikBisekcji3 = ZeraFunkcji.mbisekcji(f, a3, b3, delta, epsilon)

println(wynikBisekcji1)
println(wynikBisekcji2)
println(wynikBisekcji3)

println(f1(wynikBisekcji1[1]), " ", f2(wynikBisekcji1[1]))
println(f1(wynikBisekcji2[1]), " ", f2(wynikBisekcji2[1]))
println(f1(wynikBisekcji3[1]), " ", f2(wynikBisekcji3[1]))
