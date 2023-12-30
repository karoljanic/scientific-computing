# Karol Janic
# 1.12.2023
# Lista 4, zad 5

# using Pkg
# Pkg.add("Plots")

using Plots

include("WielomianyInterpolacyjne.jl")

f1 = x -> exp(x)
a1 = 0.0
b1 = 1.0
n1 = [2, 3, 4, 5, 10, 15]

f2 = x -> x * x * sin(x)
a2 = -1.0
b2 = 1.0
n2 = [2, 3, 4, 5, 10, 15]

function performExperiment(f, a, b, ns, funName)
    for n in ns
        p = WielomianyInterpolacyjne.rysujNnfx(f, a, b, n)
        title!("Wielomian interpolacyjny dla \$ $funName \$ oraz \$ n=$n \$")
        savefig(p, "plots/$funName; n=$n")

    end
end


performExperiment(f1, a1, b1, n1, "e^x")
performExperiment(f2, a2, b2, n2, "x^2sinx")
