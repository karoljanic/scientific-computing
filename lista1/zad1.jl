# Karol Janic
# 15.10.2023
# Lista 1, zad 1

FloatTypes = [Float16, Float32, Float64]

function findMachineEpsilon(FloatType)
    machineEpsilon = FloatType(1.0)
    
    while FloatType(1.0 + machineEpsilon / 2) > FloatType(1.0)
        machineEpsilon = FloatType(machineEpsilon / 2)
    end

    return machineEpsilon
end

function findEta(FloatType)
    eta = FloatType(1.0)

    while FloatType(eta / 2) > FloatType(0.0)
        eta = FloatType(eta / 2)
    end

    return eta
end

function findMax(FloatType)
    max = FloatType(1.0)

    while !isinf(max * 2)
        max = FloatType(max * 2)
    end

    gap = max / 2
    while !isinf(max + gap) && gap >= FloatType(0.0)
        max = FloatType(max + gap)
        gap = FloatType(gap / 2)
    end

    return max
end

println("Machine Epsilon:")
for FloatType in FloatTypes
    calculatedMachineEpsilon = findMachineEpsilon(FloatType)
    builtItMachineEpsilon = eps(FloatType)
    println("$FloatType: $calculatedMachineEpsilon | $builtItMachineEpsilon")
end

println("Eta Epsilon:")
for FloatType in FloatTypes
    calculatedEta = findEta(FloatType)
    etaUsingNextFloat = nextfloat(FloatType(0.0))
    println("$FloatType: $calculatedEta | $etaUsingNextFloat")
end

println("Max Number:")
for FloatType in FloatTypes
    calculatedMax = findMax(FloatType)
    builtItMax = floatmax(FloatType)
    println("$FloatType: $calculatedMax | $builtItMax")
end