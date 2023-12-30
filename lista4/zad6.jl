# Karol Janic
# 1.12.2023
# Lista 4, zad 6

# using Pkg
# Pkg.add("Plots")

using Plots

include("WielomianyInterpolacyjne.jl")

f1 = x -> abs(x)
a1 = -1.0
b1 = 1.0
n1 = [2, 3, 4, 5, 10, 15]

f2 = x -> 1.0 / (1.0 + x * x)
a2 = -5.0
b2 = 5.0
n2 = [2, 3, 4, 5, 10, 15]

function performExperiment(f, a, b, ns, funName)
    for n in ns
        p = WielomianyInterpolacyjne.rysujNnfx(f, a, b, n)
        title!("Wielomian interpolacyjny dla \$ $funName \$ oraz \$ n=$n \$")
        fn = replace(funName, "\\" => "")
        savefig(p, "plots/$fn; n=$n.png")
    end
end


performExperiment(f1, a1, b1, n1, "|x|")
performExperiment(f2, a2, b2, n2, "\\frac{1}{1 + x^2}")
