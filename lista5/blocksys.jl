#  Karol Janic
module blocksys

include("structures.jl")

function gaussianElimination(A::structures.BlockMatrix, b::structures.BlockVector)
    # Solving Ax = b using Gaussian method
    # Inputs:
    #   A - matrix
    #   b - vector
    # Outputs:
    #   x - solution vector
    for row in 1:A.n-1
        rows = structures.getBlockMatrixColBounds(A, row)
        for rowBelow in (row+1):rows[2]
            lambda = A[rowBelow, row] / A[row, row]
            A[rowBelow, row] = 0.0
            cols = structures.getBlockMatrixRowBounds(A, row)
            for col in (row+1):cols[2]
                A[rowBelow, col] -= lambda * A[row, col]
            end
            b[rowBelow] -= lambda * b[row]
        end
    end

    x = structures.BlockVector{eltype(b)}(A.n, 0.0)
    x[end] = b[end] / A[end, end]

    for row in A.n:-1:1
        cols = structures.getBlockMatrixRowBounds(A, row)
        sum_term = 0.0
        for col in row+1:cols[2]
            sum_term += A[row, col] * x[col]
        end
        x[row] = (b[row] - sum_term) / A[row, row]
    end

    return x
end # function gaussianElimination

function gaussianEliminationWithPartialPivoting(A::structures.ExtendedBlockMatrix, b::structures.BlockVector)
    # Solving Ax = b using Gaussian method with partial pivoting
    # Inputs:
    #   A - matrix
    #   b - vector
    # Outputs:
    #   x - solution vector
    for row in 1:A.n-1
        rows = structures.getExtendedBlockMatrixColBounds(A, row)
        maxElement = abs(A[row, row])
        maxElementRow = row
        for rowBelow in (row+1):rows[2]
            if abs(A[rowBelow, row]) > maxElement
                maxElement = abs(A[rowBelow, row])
                maxElementRow = rowBelow
            end
        end

        if maxElementRow != row
            cols = structures.getExtendedBlockMatrixRowBounds(A, maxElementRow)
            for col in cols[1]:cols[2]
                temp = A[row, col]
                A[row, col] = A[maxElementRow, col]
                A[maxElementRow, col] = temp
            end

            b[row], b[maxElementRow] = b[maxElementRow], b[row]
        end

        rows = structures.getExtendedBlockMatrixColBounds(A, row)
        for rowBelow in (row+1):rows[2]
            lambda = A[rowBelow, row] / A[row, row]
            A[rowBelow, row] = 0.0
            cols = structures.getExtendedBlockMatrixRowBounds(A, row)
            for col in (row+1):cols[2]
                A[rowBelow, col] -= lambda * A[row, col]
            end
            b[rowBelow] -= lambda * b[row]
        end
    end

    x = structures.BlockVector{eltype(b)}(A.n, 0.0)
    x[end] = b[end] / A[end, end]

    for row in A.n:-1:1
        cols = structures.getExtendedBlockMatrixRowBounds(A, row)
        sum_term = 0.0
        for col in row+1:cols[2]
            sum_term += A[row, col] * x[col]
        end
        x[row] = (b[row] - sum_term) / A[row, row]
    end

    return x
end # function gaussianEliminationWithPartialPivoting

function luDecomposition!(A::structures.BlockMatrix)
    # LU decomposition without pivoting
    # A is overwritten with L and U matrices
    # L is a lower triangular matrix with ones on the diagonal
    # U is an upper triangular matrix
    # A = L * U
    # Inputs:
    #   A - matrix
    # Outputs:
    # nothing
    for row in 1:A.n-1
        rows = structures.getBlockMatrixColBounds(A, row)
        for rowBelow in (row+1):rows[2]
            lambda = A[rowBelow, row] / A[row, row]
            cols = structures.getBlockMatrixRowBounds(A, row)
            for col in row:cols[2]
                A[rowBelow, col] -= lambda * A[row, col]
            end
            A[rowBelow, row] = lambda
        end
    end
end

function luDecompositionWithPartialPivoting!(A::structures.ExtendedBlockMatrix)
    # LU decomposition with partial pivoting
    # A is overwritten with L and U matrices
    # L is a lower triangular matrix with ones on the diagonal(ones are not stored)
    # U is an upper triangular matrix
    # A = L * U
    # Inputs:
    #   A - square matrix
    # Outputs:
    #   permutation - permutation vector
    permutation = [i for i in 1:A.n]

    for row in 1:A.n-1
        rows = structures.getExtendedBlockMatrixColBounds(A, row)
        maxElement = abs(A[row, row])
        maxElementRow = row
        for rowBelow in (row+1):rows[2]
            if abs(A[rowBelow, row]) > maxElement
                maxElement = abs(A[rowBelow, row])
                maxElementRow = rowBelow
            end
        end

        if maxElementRow != row
            permutation[row], permutation[maxElementRow] = permutation[maxElementRow], permutation[row]

            cols = structures.getExtendedBlockMatrixRowBounds(A, maxElementRow)
            for col in cols[1]:cols[2]
                temp = A[row, col]
                A[row, col] = A[maxElementRow, col]
                A[maxElementRow, col] = temp
            end
        end

        rows = structures.getExtendedBlockMatrixColBounds(A, row)
        for rowBelow in (row+1):rows[2]
            lambda = A[rowBelow, row] / A[row, row]
            cols = structures.getExtendedBlockMatrixRowBounds(A, row)
            for col in row:cols[2]
                A[rowBelow, col] -= lambda * A[row, col]
            end
            A[rowBelow, row] = lambda
        end
    end

    return permutation
end

function gaussianEliminationWithLU(A::structures.BlockMatrix, b::structures.BlockVector)
    # Solving Ax = b using Gaussian method and LU decomposition
    # Inputs:
    #   A = LU - matrix
    #   b - vector
    # Outputs:
    #   x - solution vector
    y = structures.BlockVector{eltype(b)}(A.n, 0.0)

    for row in 1:A.n
        cols = structures.getBlockMatrixRowBounds(A, row)
        sum_term = 0.0
        for col in cols[1]:(row-1)
            sum_term += A[row, col] * y[col]
        end
        y[row] = (b[row] - sum_term)
    end

    x = structures.BlockVector{eltype(b)}(A.n, 0.0)
    x[end] = y[end] / A[end, end]

    for row in A.n:-1:1
        cols = structures.getBlockMatrixRowBounds(A, row)
        sum_term = 0.0
        for col in row+1:cols[2]
            sum_term += A[row, col] * x[col]
        end
        x[row] = (y[row] - sum_term) / A[row, row]
    end

    return x

end # function gaussianEliminationWithLU

function gaussianEliminationWithLUWithPartialPivoting(A::structures.ExtendedBlockMatrix, b::structures.BlockVector, permutation::Array{Int64,1})
    # Solving Ax = b using Gaussian method and LU decomposition with partial pivoting
    # Inputs:
    #   A = LU - matrix
    #   b - vector
    #   permutation - permutation vector
    # Outputs:
    #   x - solution vector
    y = structures.BlockVector{eltype(b)}(A.n, 0.0)

    for row in 1:A.n
        cols = structures.getExtendedBlockMatrixRowBounds(A, row)
        sum_term = 0.0
        for col in cols[1]:(row-1)
            sum_term += A[row, col] * y[col]
        end
        y[row] = (b[permutation[row]] - sum_term)
    end

    x = structures.BlockVector{eltype(b)}(A.n, 0.0)
    x[end] = y[end] / A[end, end]

    for row in A.n:-1:1
        cols = structures.getExtendedBlockMatrixRowBounds(A, row)
        sum_term = 0.0
        for col in row+1:cols[2]
            sum_term += A[row, col] * x[col]
        end
        x[row] = (y[row] - sum_term) / A[row, row]
    end

    return x

end # function gaussianEliminationWithLUAndPartialPivoting

end # module blocksys