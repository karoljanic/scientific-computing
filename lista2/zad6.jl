# Karol Janic
# 3.11.2023
# Lista 2, zad 6

import Pkg
Pkg.add("Plots")

using Plots


function f(c, x)
    return x * x + c
end

function experiment(x0, c, n)
    result = []
    x = x0

    for k in 1:n
        x = f(c, x)
        push!(result, x)
    end

    return result
end

function visualize(x0, c, outputFilename)
    minX = -3
    maxX = 3
    funPointsNum = 100

    iterations = 40

    # plot function 
    funPointsX = []
    funPointsY = []
    for k in 1:funPointsNum
        x = minX + k *(maxX - minX) / funPointsNum
        y = f(c, x)
        push!(funPointsX, x)
        push!(funPointsY, y)
    end
    plot(funPointsX, funPointsY, linewidth=2, linecolor="blue")

    # plot y = x
    plot!(funPointsX, funPointsX, linewidth=2, linecolor="green")

    # plot iterations
    x = x0
    y = -3
    for k in 1:iterations
        newY = f(c, x)
        newX = newY
        scatter!([x, x, newX], [y, newY, newY], color="red", legend=false)
        plot!([x, x, newX], [y, newY, newY], linewidth=1, linecolor="red", legend=false)
        x = newX
        y = newY
    end

    scatter!([x], [y], color="black", markersize=3)

    title!("argument początkowy = $x0")
    savefig(outputFilename)
end

n = 40

c1 = -2
c2 = -1

x01 = [1, 2, 1.99999999999999]
x02 = [1, -1, 0.75, 0.25]

ex1 = experiment(x01[1], c1, n)
ex2 = experiment(x01[2], c1, n)
ex3 = experiment(x01[3], c1, n)

ex4 = experiment(x02[1], c2, n)
ex5 = experiment(x02[2], c2, n)
ex6 = experiment(x02[3], c2, n)
ex7 = experiment(x02[4], c2, n)

for k in 1:n
    println("\\hline")
    println(k, " & ", ex1[k], " & ", ex2[k], " & ", ex3[k], " \\\\")
end

println()

for k in 1:n
    println("\\hline")
    println(k, " & ", ex4[k], " & ", ex5[k], " & ", ex6[k], " & ", ex7[k], " \\\\")
end


visualize(1, -2, "report/plots/x^2-2:1.png")
visualize(1.99999999999999, -2, "report/plots/x^2-2:1.999.png")
visualize(2, -2, "report/plots/x^2-2:2.png")
# visualize(2.5, -2, "report/plots/x^2-2:2.5.png")

visualize(1, -1, "report/plots/x^2-1:1.png")
visualize(-1, -1, "report/plots/x^2-1:-1.png")
visualize(0.75, -1, "report/plots/x^2-1:0.75.png")
visualize(0.25, -1, "report/plots/x^2-1:0.25.png")
# visualize(2, -1, "report/plots/x^2-1:2.png")