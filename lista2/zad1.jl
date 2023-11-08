# Karol Janic
# 3.11.2023
# Lista 2, zad 1

function forwardDotProduct(X, Y, FloatType)
    dotProduct = FloatType(0.0)
    for index in firstindex(X):lastindex(X)
        dotProduct += FloatType(X[index] * Y[index])
    end

    return dotProduct
end

function backwardDotProduct(X, Y, FloatType)
    dotProduct = FloatType(0.0)
    for index in lastindex(X):-1:firstindex(X)
        dotProduct += FloatType(X[index] * Y[index])
    end

    return dotProduct
end

function sortedDecreasingDotProduct(X, Y, FloatType)
    partialSums = []
    for index in firstindex(X):lastindex(X)
        push!(partialSums, FloatType(X[index] * Y[index]))
    end

    sortedPositiveSums = sort(filter(x -> x > 0, partialSums), rev=true)
    sortedNegativeSums = sort(filter(x -> x < 0, partialSums), rev=false)

    dotProductPositiveSum = FloatType(0.0)
    for index in firstindex(sortedPositiveSums):lastindex(sortedPositiveSums)
        dotProductPositiveSum += sortedPositiveSums[index]
    end

    dotProductNegativeSum = FloatType(0.0)
    for index in firstindex(sortedNegativeSums):lastindex(sortedNegativeSums)
        dotProductNegativeSum += sortedNegativeSums[index]
    end

    return dotProductPositiveSum + dotProductNegativeSum
end

function sortedIncreasingDotProduct(X, Y, FloatType)
    partialSums = []
    for index in firstindex(X):lastindex(X)
        push!(partialSums, FloatType(X[index] * Y[index]))
    end

    sortedPositiveSums = sort(filter(x -> x > 0, partialSums), rev=false)
    sortedNegativeSums = sort(filter(x -> x < 0, partialSums), rev=true)

    dotProductPositiveSum = FloatType(0.0)
    for index in firstindex(sortedPositiveSums):lastindex(sortedPositiveSums)
        dotProductPositiveSum += sortedPositiveSums[index]
    end

    dotProductNegativeSum = FloatType(0.0)
    for index in firstindex(sortedNegativeSums):lastindex(sortedNegativeSums)
        dotProductNegativeSum += sortedNegativeSums[index]
    end

    return dotProductPositiveSum + dotProductNegativeSum
end

X = [2.718281828, -3.141592654, 1.414213562, 0.5772156649, 0.3010299957]
Xp = [2.718281828, -3.141592654, 1.414213562, 0.577215664, 0.301029995]
Y = [1486.2497, 878366.9879, -22.37492, 4773714.647, 0.000185049]


for FloatType in [Float32, Float64]
    castedX = map((x) -> FloatType(x), X)
    castedXp = map((x) -> FloatType(x), Xp)
    castedY = map((x) -> FloatType(x), Y)
    println(forwardDotProduct(castedX, castedY, FloatType))
    println(forwardDotProduct(castedXp, castedY, FloatType))
    println(backwardDotProduct(castedX, castedY, FloatType))
    println(backwardDotProduct(castedXp, castedY, FloatType))
    println(sortedDecreasingDotProduct(castedX, castedY, FloatType))
    println(sortedDecreasingDotProduct(castedXp, castedY, FloatType))
    println(sortedIncreasingDotProduct(castedX, castedY, FloatType))
    println(sortedIncreasingDotProduct(castedXp, castedY, FloatType))
    println()
end