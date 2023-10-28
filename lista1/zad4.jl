# Karol Janic
# 15.10.2023
# Lista 1, zad 4

function findSmallest()
    delta = Float64(2.0) ^ Float64(-52)
    x = Float64(1.0) + delta

    while Float64(x * (Float64(1.0 / x))) == Float64(1.0)
        x += delta
    end

    println(x)
end

findSmallest()