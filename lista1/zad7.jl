# Karol Janic
# 15.10.2023
# Lista 1, zad 7

import Pkg
Pkg.add("Plots")

using Plots

function f(x)
    return Float64(sin(x) + cos(3.0 * x))
end

function der1(x)
    return Float64(cos(x) - Float64(3.0 * sin(3.0 * x)))
end

function der2(x0, h)
    return Float64(f(x0 + h) - f(x0)) / Float64(h)
end

function draw(x0, n_min, n_max)
    n_vals = n_min:n_max
    h_vals = [Float64(2.0)^Float64(-n) for n in n_vals]
    
    one_plus_h = [Float64(1.0) + h for h in h_vals]
    der1_vals = [der1(x0) for h in h_vals]
    der2_vals = [der2(x0, h) for h in h_vals]
    diff_vals = [abs(der1(x0) - der2(x0, h)) for h in h_vals]

    plot(n_vals, one_plus_h, legend=false)   
    title!("Kolejne wartości \$1.0 + 2^{-n}\$")
    xlabel!("n")
    savefig("report/plots/zad7-plot0.png")

    plot(n_vals, der1_vals, label="wartość dokładna")   
    plot!(n_vals, der2_vals, label="wartość przybliżona")   
    title!("Porównanie wartości dokładnej i przybliżonej") 
    savefig("report/plots/zad7-plot1.png")

    plot(n_vals, diff_vals, legend=false,)
    title!("Różnica pomiędzy wartością dokładną a przybliżoną")
    xlabel!("n")
    savefig("report/plots/zad7-plot2.png")
end

draw(1, 0, 54)