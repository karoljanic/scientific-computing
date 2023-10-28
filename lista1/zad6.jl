# Karol Janic
# 15.10.2023
# Lista 1, zad 6

function f(x)
    return Float64(sqrt(Float64(x * x) + Float64(1.0)) - Float64(1.0))
end

function g(x)
    return Float64(x * x) / Float64(sqrt(Float64(x * x) + Float64(1.0)) + Float64(1.0))
end

for k in 1:180
    fx = f(Float64(8.0) ^ Float64(-k))
    gx = g(Float64(8.0) ^ Float64(-k))
    println("f(2^-$k) = $fx    g(2^-$k) = $gx")
end