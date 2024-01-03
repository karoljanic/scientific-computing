# Karol Janic
include("matrixgen.jl")
include("blocksys.jl")

# import Pkg
# Pkg.add("BenchmarkTools")
# Pkg.add("LinearAlgebra")
# Pkg.add("Plots")

using BenchmarkTools
using LinearAlgebra
using Plots


function calculateRelativeError(vector1::blocksys.structures.BlockVector, vector2::blocksys.structures.BlockVector)
    # Calculates relative error between two vectors
    # Inputs:
    #   vector1 - first vector
    #   vector2 - second vector
    # Outputs:
    #   relativeError - relative error between vector1 and vector2
    return norm(vector1 - vector2) / norm(vector1)
end # function calculateRelativeError

function test1(pathToSources::String, pivoting::Bool)
    # Tests gaussian elimination with given matrix A and vector b
    # It saves solution to file in pathToSources directory
    # Inputs:
    #   pathToSources - path to sources
    #   pivoting - if true, partial pivoting is used
    # Outputs:
    #   nothing
    vectorb = blocksys.structures.BlockVector{Float64}(pathToSources * "/b.txt")

    if pivoting
        matrixA = blocksys.structures.ExtendedBlockMatrix{Float64}(pathToSources * "/A.txt")
        solutionX = blocksys.gaussianEliminationWithPartialPivoting(matrixA, vectorb)

        file = open(pathToSources * "/x_pivoting.txt", "w")
        for i in 1:solutionX.n
            println(file, solutionX[i])
        end
    else
        matrixA = blocksys.structures.BlockMatrix{Float64}(pathToSources * "/A.txt")
        solutionX = blocksys.gaussianElimination(matrixA, vectorb)

        file = open(pathToSources * "/x_no_pivoting.txt", "w")
        for i in 1:solutionX.n
            println(file, solutionX[i])
        end
    end
end # function test1

function test2(pathToSources::String, pivoting::Bool)
    # Tests gaussian elimination with given matrix A and generated vector b
    # It saves solution to file in pathToSources directory
    # Inputs:
    #   pathToSources - path to sources
    #   pivoting - if true, partial pivoting is used
    # Outputs:
    #   nothing
    if pivoting
        matrixA = blocksys.structures.ExtendedBlockMatrix{Float64}(pathToSources * "/A.txt")
        targetSolutionX = blocksys.structures.BlockVector{Float64}(matrixA.n, 1.0)
        for i in 1:matrixA.n
            targetSolutionX[i] = 10 * rand()
        end
        vectorb = matrixA * targetSolutionX
        solutionX = blocksys.gaussianEliminationWithPartialPivoting(matrixA, vectorb)
        relativeError = calculateRelativeError(targetSolutionX, solutionX)

        file = open(pathToSources * "/x_target_pivoting.txt", "w")
        println(file, relativeError)
        for i in 1:solutionX.n
            println(file, solutionX[i])
        end
    else
        matrixA = blocksys.structures.BlockMatrix{Float64}(pathToSources * "/A.txt")
        targetSolutionX = blocksys.structures.BlockVector{Float64}(matrixA.n, 1.0)
        for i in 1:matrixA.n
            targetSolutionX[i] = 10 * rand()
        end
        vectorb = matrixA * targetSolutionX
        solutionX = blocksys.gaussianElimination(matrixA, vectorb)
        relativeError = calculateRelativeError(targetSolutionX, solutionX)

        file = open(pathToSources * "/x_target_no_pivoting.txt", "w")
        println(file, relativeError)
        for i in 1:solutionX.n
            println(file, solutionX[i])
        end
    end
end # function test2

function test3(pathToSources::String, pivoting::Bool)
    # Tests gaussian elimination using LU decomposition with given matrix A and vector b
    # It saves solution to file in pathToSources directory
    # Inputs:
    #   pathToSources - path to sources
    #   pivoting - if true, partial pivoting is used
    # Outputs:
    #   nothing
    vectorb = blocksys.structures.BlockVector{Float64}(pathToSources * "/b.txt")

    if pivoting
        matrixA = blocksys.structures.ExtendedBlockMatrix{Float64}(pathToSources * "/A.txt")
        permutation = blocksys.luDecompositionWithPartialPivoting!(matrixA)
        solutionX = blocksys.gaussianEliminationWithLUWithPartialPivoting(matrixA, vectorb, permutation)

        file = open(pathToSources * "/x_lu_pivoting.txt", "w")
        for i in 1:solutionX.n
            println(file, solutionX[i])
        end
    else
        matrixA = blocksys.structures.BlockMatrix{Float64}(pathToSources * "/A.txt")
        blocksys.luDecomposition!(matrixA)
        solutionX = blocksys.gaussianEliminationWithLU(matrixA, vectorb)

        file = open(pathToSources * "/x_lu_no_pivoting.txt", "w")
        for i in 1:solutionX.n
            println(file, solutionX[i])
        end
    end
end # function test3

function test4(pathToSources::String, pivoting::Bool)
    # Tests gaussian elimination using LU decomposition with given matrix A and generated vector b
    # It saves solution to file in pathToSources directory
    # Inputs:
    #   pathToSources - path to sources
    #   pivoting - if true, partial pivoting is used
    # Outputs:
    #   nothing
    if pivoting
        matrixA = blocksys.structures.ExtendedBlockMatrix{Float64}(pathToSources * "/A.txt")
        targetSolutionX = blocksys.structures.BlockVector{Float64}(matrixA.n, 1.0)
        for i in 1:matrixA.n
            targetSolutionX[i] = 10 * rand()
        end
        vectorb = matrixA * targetSolutionX
        permutation = blocksys.luDecompositionWithPartialPivoting!(matrixA)
        solutionX = blocksys.gaussianEliminationWithLUWithPartialPivoting(matrixA, vectorb, permutation)
        relativeError = calculateRelativeError(targetSolutionX, solutionX)

        file = open(pathToSources * "/x_target_lu_pivoting.txt", "w")
        println(file, relativeError)
        for i in 1:solutionX.n
            println(file, solutionX[i])
        end
    else
        matrixA = blocksys.structures.BlockMatrix{Float64}(pathToSources * "/A.txt")
        targetSolutionX = blocksys.structures.BlockVector{Float64}(matrixA.n, 1.0)
        for i in 1:matrixA.n
            targetSolutionX[i] = 10 * rand()
        end
        vectorb = matrixA * targetSolutionX
        blocksys.luDecomposition!(matrixA)
        solutionX = blocksys.gaussianEliminationWithLU(matrixA, vectorb)
        relativeError = calculateRelativeError(targetSolutionX, solutionX)

        file = open(pathToSources * "/x_target_lu_no_pivoting.txt", "w")
        println(file, relativeError)
        for i in 1:solutionX.n
            println(file, solutionX[i])
        end
    end
end # function test4

function generateTimeBenchmarks(fun::Function, title::String, pivoting::Bool)
    # Generates benchmarks for gaussian elimination
    # It saves plots to current directory
    # Inputs:
    #   nothing
    # Outputs:
    #   nothing
    nValues = 1000:100000:1001000
    lValues = [5, 10, 25]
    reps = 100

    timeSeries = []
    for l in lValues
        times = []
        for n in nValues
            timesSum = 0.0
            for _ in 1:reps
                matrixgen.blockmat(n, l, 1.0, "tmp.txt")
                A = pivoting ? blocksys.structures.ExtendedBlockMatrix{Float64}("tmp.txt") : blocksys.structures.BlockMatrix{Float64}("tmp.txt")
                targetX = blocksys.structures.BlockVector{Float64}(n, 1.0)
                b = A * targetX

                elapsedTime = @elapsed begin
                    x = fun(A, b)
                end
                timesSum += elapsedTime
            end
            push!(times, timesSum / reps)
        end
        push!(timeSeries, times)
    end

    for i in eachindex(lValues)
        plot!(nValues, timeSeries[i], label="l = $(lValues[i])")
    end

    title!(title)
    xlabel!("n")
    ylabel!("czas [s]")
    savefig("plots//$title.png")
end

function generateMemoryBenchmark()
    # Generates benchmarks for gaussian elimination
    # It saves plots to current directory
    # Inputs:
    #   nothing
    # Outputs:
    #   nothing
    nValues = 1000:100000:1001000
    lValues = [5, 10]

    memorySeries = []
    for l in lValues
        memory1 = []
        memory2 = []
        for n in nValues
            matrixgen.blockmat(n, l, 1.0, "tmp.txt")
            A1 = blocksys.structures.BlockMatrix{Float64}("tmp.txt")
            A2 = blocksys.structures.ExtendedBlockMatrix{Float64}("tmp.txt")

            push!(memory1, Base.summarysize(A1) / 10^6)
            push!(memory2, Base.summarysize(A2) / 10^6)
        end
        push!(memorySeries, [memory1, memory2])
    end

    for i in eachindex(lValues)
        plot!(nValues, memorySeries[i][1], label="l = $(lValues[i]) - bez rozszerzenia")
        plot!(nValues, memorySeries[i][2], label="l = $(lValues[i]) - z rozszerzeniem")
    end

    title!("Zużycie pamięci przez struktury")
    xlabel!("n")
    ylabel!("pamięć [Mb]")
    savefig("plots//Zuzycie Pamieci Struktur.png")
end

for dir in readdir("tests")
    if isdir("tests/" * dir)
        println(dir)
        for pivoting in [true, false]
            test1("tests/" * dir, pivoting)
            test2("tests/" * dir, pivoting)
            test3("tests/" * dir, pivoting)
            test4("tests/" * dir, pivoting)
        end
    end
end

# test1("tests//Dane16_1_1/", false)
# test2("tests//Dane16_1_1/", false)
# test3("tests//Dane16_1_1/", true)
# test4("tests//Dane16_1_1/", false)

function core1(A, b)
    blocksys.gaussianElimination(A, b)
end

function core2(A, b)
    blocksys.gaussianEliminationWithPartialPivoting(A, b)
end

function core3(A, b)
    blocksys.luDecomposition!(A)
    blocksys.gaussianEliminationWithLU(A, b)
end

function core4(A, b)
    permutation = blocksys.luDecompositionWithPartialPivoting!(A)
    blocksys.gaussianEliminationWithLUWithPartialPivoting(A, b, permutation)
end

# generateTimeBenchmarks(core1, "Eliminacja Gaussa bez wyboru elementu głównego", false)
# generateTimeBenchmarks(core2, "Eliminacja Gaussa z częściowym wyborem elementu głównego", true)
# generateTimeBenchmarks(core3, "Eliminacja Gaussa z rozkładem LU bez wyboru elementu głównego", false)
# generateTimeBenchmarks(core4, "Eliminacja Gaussa z rozkładem LU z częściowym wyborem elementu głównego", true)
# generateMemoryBenchmark()