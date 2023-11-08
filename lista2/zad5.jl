# Karol Janic
# 3.11.2023
# Lista 2, zad 5

function experiment(p0, r, n, roundOn, FloatType)
    result = []
    p = FloatType(p0)

    for k in 1:n
        p = FloatType(p) + FloatType(r) * FloatType(p) * (FloatType(1.0) - FloatType(p))
        if k == roundOn
            p = FloatType(floor(p * 1000) / 1000)
        end
        push!(result, p)
    end

    return result
end

n = 40
r = 3
p0 = 0.01

ex1 = experiment(p0, r, n, -1, Float32)
ex2 = experiment(p0, r, n, 10, Float32)
ex3 = experiment(p0, r, n, -1, Float64)


for k in 1:n
    println("\\hline")
    println(k, " & ", ex1[k], " & ", ex2[k], " & ", ex3[k], " \\\\")
end