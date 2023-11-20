# Karol Janic
# 13.11.2023
# Lista 3, zad 6

include("ZeraFunkcji.jl")

const e = MathConstants.e

f1 = x -> e^(1.0 - x) - 1.0
pf1 = x -> -e^(1.0 - x)
f2 = x -> x * e^(-x)
pf2 = x -> -e^(-x) * (x - 1.0)

delta = 10.0e-5
epsilon = 10.0e-5
maxit = 256

println("Function 1")

a1Vals = [0.0, -1.0, 256.5, 1.0, -5.0e6]
b1Vals = [2.0, 5.0, -256.5, 512.0, 5.0e6]
for index in eachindex(a1Vals)
    wynikBisekcji1 = ZeraFunkcji.mbisekcji(f1, a1Vals[index], b1Vals[index], delta, epsilon)
    println("a = ", a1Vals[index], " b = ", b1Vals[index], ": ", wynikBisekcji1)
end
println()

x01Vals = [1.0, 0.0, -2.0, -5.0, -7.0, -10.0, -512.0, 2.0, 5.0, 7.0, 10.0, 512.0]
for index in eachindex(x01Vals)
    wynikStycznych1 = ZeraFunkcji.mstycznych(f1, pf1, x01Vals[index], delta, epsilon, maxit)
    println("x0 = ", x01Vals[index], ": ", wynikStycznych1)
end
println()

x01Vals = [0.0, 0.0, -10.0, -32.0, 1.5, 2.0, 2.0, 32.0]
x11Vals = [1.0, 0.5, -5.0, 0.0, 3.0, 4.0, 16.0, 64.0]
for index in eachindex(x01Vals)
    wynikSiecznych1 = ZeraFunkcji.msiecznych(f1, x01Vals[index], x11Vals[index], delta, epsilon, maxit)
    println("x0 = ", x01Vals[index], " x1 = ", x11Vals[index], ": ", wynikSiecznych1)
end
println()


println("\nFunction 2")

a2Vals = [-5.0, -3.0, 0.0, -3.0, -2.0]
b2Vals = [5.0, 7.0, 10.0, 0.0, 1024.0]
for index in eachindex(a2Vals)
    wynikBisekcji2 = ZeraFunkcji.mbisekcji(f2, a2Vals[index], b2Vals[index], delta, epsilon)
    println("a = ", a2Vals[index], " b = ", b2Vals[index], ": ", wynikBisekcji2)
end
println()

x02Vals = [0.0, 1.0, 2.0, 4.0, 16.0, 256.0, -1.0, -2.0, -4.0, -16.0, -256.0]
for index in eachindex(x02Vals)
    wynikStycznych2 = ZeraFunkcji.mstycznych(f2, pf2, x02Vals[index], delta, epsilon, maxit)
    println("x0 = ", x02Vals[index], ": ", wynikStycznych2)
end
println()

x02Vals = [-1.0, -2.0, -8.0, -16.0, 1.0]
x12Vals = [0.0, -1.0, -4.0, -1.0, 2.0]
for index in eachindex(x02Vals)
    wynikSiecznych2 = ZeraFunkcji.msiecznych(f2, x02Vals[index], x12Vals[index], delta, epsilon, maxit)
    println("x0 = ", x02Vals[index], " x1 = ", x12Vals[index], ": ", wynikSiecznych2)
end
println()
