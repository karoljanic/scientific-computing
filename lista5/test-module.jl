# Karol Janic

include("matrixgen.jl")
include("blocksys.jl")

# import Pkg
# Pkg.add("BenchmarkTools")
# Pkg.add("Plots")

using SparseArrays
using BenchmarkTools
using Plots


function calculateRelativeError(vector1::blocksys.structures.BlockVector, vector2::blocksys.structures.BlockVector)
    n = vector1.n
    relativeError = 0.0
    for i in 1:n
        relativeError += abs(vector1[i] - vector2[i]) / abs(vector1[i])
    end
    return relativeError / n
end

function test1(pathToSources::String)
    matrixA = blocksys.structures.BlockMatrix{Float64}(pathToSources * "/A.txt")
    vectorb = blocksys.structures.BlockVector{Float64}(pathToSources * "/b.txt")

    solutionX = blocksys.gaussianElimination(matrixA, vectorb)

    file = open(pathToSources * "/x.txt", "w")
    for i in 1:solutionX.n
        println(file, solutionX[i])
    end
end

function test2(pathToSources::String)
    matrixA = blocksys.structures.BlockMatrix{Float64}(pathToSources * "/A.txt")

    targetSolutionX = blocksys.structures.BlockVector{Float64}(matrixA.n, 1.0)
    vectorb = matrixA * targetSolutionX

    solutionX = blocksys.gaussianElimination(matrixA, vectorb)
    relativeError = calculateRelativeError(targetSolutionX, solutionX)

    file = open(pathToSources * "/x.txt", "w")
    println(file, relativeError)
    for i in 1:solutionX.n
        println(file, solutionX[i])
    end
end


function generateBenchmark()
    nValues = 10000:10000:100000
    lValues = [5, 10]#, 25, 50]
    reps = 10

    timeSeries = []
    for l in lValues
        times = []
        for n in nValues
            timesSum = 0.0
            for _ in 1:reps
                matrixgen.blockmat(n, l, 1.0, "tmp.txt")
                A = blocksys.structures.BlockMatrix{Float64}("tmp.txt")
                targetX = blocksys.structures.BlockVector{Float64}(n, 1.0)
                b = A * targetX

                elapsedTime = @elapsed begin
                    x = blocksys.gaussianElimination(A, b)
                end
                timesSum += elapsedTime
            end
            push!(times, timesSum / reps)
        end
        push!(timeSeries, times)
    end

    println(timeSeries)

    plot(nValues, timeSeries, label=["l = 5", "l = 10"],
        xlabel="n", ylabel="time [s]", title="Gaussian elimination time benchmark")

    title!("Elapsed Time Series")
    # legend!()
    savefig("benchmark.png")

    # matrixgen.blockmat(n, l, 1.0, "tmp.txt")
    # A = blocksys.structures.BlockMatrix{Float64}("tmp.txt")
    # targetX = blocksys.structures.BlockVector{Float64}(n, 1.0)
    # b = A * targetX

    # elapsedTime = @elapsed begin
    #     x = blocksys.gaussianElimination(A, b)
    # end
    # println(elapsedTime)

    # Memory measurement using Base.summarysize
    # memory_result = Base.summarysize(my_function(n, l))

    # # Store results in arrays
    # push!(time_results, time_result)
    # push!(memory_results, memory_result)
    #         end
    #     end
end

# generateBenchmark()

test2("tests//Dane16_1_1/")


