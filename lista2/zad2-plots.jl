# Karol Janic
# 3.11.2023
# Lista 2, zad 2

import Pkg
Pkg.add("Plots")

using Plots

f(x) = exp(x) * log(1 + exp(-x))

plot(f, -50, 50, legend=false)
xlabel!("x")
ylabel!("f(x)")
savefig("report/plots/f(x)-1-plots.png")

plot(f, 32, 40, legend=false)
xlabel!("x")
ylabel!("f(x)")
savefig("report/plots/f(x)-2-plots.png")