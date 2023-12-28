#  Karol Janic
module blocksys

include("structures.jl")


function luDecomposition!(A::structures.BlockMatrix)
    n = A.n
    l = A.l
    v = div(n, l)

    for v in 0:(v-1)   # for each block
        for ii in 0:(l-1)   # for each row in block
            i = v * l + ii + 1

            maxj = (ii == (l - 1)) ? (v * l + 2 * l) : (v * l + l)
            for j in (i+1):(min(n, maxj))   # for each row below
                lambda = A[j, i] / A[i, i]

                for k in i:(min(n, i + l))   # for each column in row
                    A[j, k] -= lambda * A[i, k]
                end

                A[j, i] = lambda
            end
        end
    end
end

function luDecompositionWithPartialPivoting!()
    n = A.n
    l = A.l
    v = div(n, l)

    permutation = [i for i in 1:n]

    for v in 0:(v-1)   # for each block
        for ii in 0:(l-1)   # for each row in block
            i = v * l + ii + 1
            maxj = (ii == (l - 1)) ? (v * l + 2 * l) : (v * l + l)
            for j in (i+1):(min(n, maxj))   # for each row below
                lambda = A[j, i] / A[i, i]

                for k in i:(min(n, i + l))   # for each column in row
                    A[j, k] -= lambda * A[i, k]
                end

                A[j, i] = lambda
            end
        end
    end
end

function gaussianEliminationWithLU(A::structures.BlockMatrix, b::structures.BlockVector)
    n = A.n
    l = A.l
    v = div(n, l)

    y = structures.BlockVector{eltype(b)}(n, 0.0)
    for v in 0:(div(n, l)-1)     # for each block
        for ii in 1:l
            i = v * l + ii
            sum_term = 0.0
            for j in max(1, v * l):(i-1)
                sum_term += A[i, j] * y[j]
            end
            y[i] = (b[i] - sum_term)  # L[i, i] is not used in this snippet
        end
    end

    x = structures.BlockVector{eltype(b)}(n, 0.0)
    x[end] = y[end] / A[end, end]

    # Looping over rows in reverse (from the bottom up),
    # starting with the second to last row, because the
    # last row solve was completed in the last step.
    for v in (div(n, l)-1):-1:0    # for each block
        for ii in l:-1:1
            i = v * l + ii
            sum_term = 0.0
            for j in (i+1):min(n, v * l + l + ii)
                sum_term += A[i, j] * x[j]
            end
            x[i] = (y[i] - sum_term) / A[i, i]
        end
    end

    return x

end # function gaussianEliminationWithLU

function gaussianElimination(A::structures.BlockMatrix, b::structures.BlockVector)
    luDecomposition!(A)
    return gaussianEliminationWithLU(A, b)
end # function gaussianElimination

function gaussianEliminationWithPartialPivoting()

end # function gaussianEliminationWithPartialPivoting

end # module blocksys