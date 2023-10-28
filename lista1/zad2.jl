# Karol Janic
# 15.10.2023
# Lista 1, zad 2

FloatTypes = [Float16, Float32, Float64]

function kahanMachineEpsilon(FloatType)
    return FloatType(3.0) * (FloatType(4.0) / FloatType(3.0) - FloatType(1.0)) - FloatType(1.0)
end

for FloatType in FloatTypes
    kahan = kahanMachineEpsilon(FloatType)
    builtIn = eps(FloatType)
    println("$FloatType: $kahan | $builtIn")
end