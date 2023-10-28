# Karol Janic
# 15.10.2023
# Lista 1, zad 3

function getKthNumberStr(lowerBound, k)
    return string(bitstring(Float64(lowerBound))[1:end-52], string(k, base=2, pad=52))
end

function checkStep(lowerBound, upperBound, delta, limit)
    number = lowerBound
    k = 0
    while number <= upperBound
        number = lowerBound + k * delta

        generatedWithDelta = bitstring(number)
        generatedWithBits = getKthNumberStr(lowerBound, k)
        if generatedWithDelta != generatedWithBits
            return false
        end

        k += 1

        if k > limit
            break
        end
    end    

    return true
end


lowerBound = Float64(2)
upperBound = Float64(4)
delta = Float64(2.0) ^ Float64(-51)
if checkStep(lowerBound, upperBound, delta, 1024)
    println("OK!")
else
    println("NOT OK!")
end