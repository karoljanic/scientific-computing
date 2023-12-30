# Karol Janic
module structures

export BlockVector, BlockMatrix, ExtendedBlockMatrix,
    printBlockVector, printBlockMatrix, printExtendedBlockMatrix,
    getBlockMatrixRowBounds, getBlockMatrixColBounds,
    getExtendedBlockMatrixRowBounds, getExtendedBlockMatrixColBounds

import Base: getindex, setindex!, size, length, *

struct BlockVector{T<:Number} <: AbstractVector{T}
    # BlockVector is struct with fields:
    # n - number of elements
    # values - vector of values with length n and type T
    n::Int
    values::Vector{T}

    function BlockVector{T}(n::Int) where {T}
        # Constructor for BlockVector
        # Inputs:
        #   n - number of elements
        # Outputs:
        #   blockVector - BlockVector with n elements of type T
        new{T}(n, Vector{T}(undef, n))
    end

    function BlockVector{T}(n::Int, value::T) where {T}
        # Constructor for BlockVector
        # Inputs:
        #   n - number of elements
        #   value - value of each element
        # Outputs:
        #   blockVector - BlockVector with n elements of type T
        blockVector = BlockVector{T}(n)

        for i in 1:n
            blockVector[i] = value
        end

        return blockVector
    end

    function BlockVector{T}(inputFile::String) where {T}
        # Constructor for BlockVector
        # Inputs:
        #   inputFile - path to file with vector description
        # Outputs:
        #   blockVector - BlockVector with elements of type T
        open(inputFile, "r") do f
            n, = readline(f) |> split
            blockVector = BlockVector{T}(parse.(Int, n))

            for (lineNumber, line) in enumerate(eachline(f))
                value = split(line)[1]
                blockVector.values[lineNumber] = parse.(T, value)
            end

            return blockVector
        end
    end
end # struct BlockVector

function getindex(blockVector::BlockVector, index::Int)
    # Function for getting value from BlockVector at given index
    # Inputs:
    #   blockVector - BlockVector
    #   index - index of element
    # Outputs:
    #   value - value of element at given index
    return blockVector.values[index]
end # function getindex

function setindex!(blockVector::BlockVector, value::T, index::Int) where {T}
    # Function for setting value in BlockVector at given index
    # Inputs:
    #   blockVector - BlockVector
    #   value - value to set
    #   index - index of element
    # Outputs:
    #   blockVector - BlockVector with value set at given index
    blockVector.values[index] = value
    return blockVector
end # function setindex!

function size(blockVector::BlockVector)
    # Function for getting size of BlockVector
    # Inputs:
    #   blockVector - BlockVector
    # Outputs:
    #   size - size of BlockVector
    return size(blockVector.values)
end # function size

function length(blockVector::BlockVector)
    # Function for getting length of BlockVector
    # Inputs:
    #   blockVector - BlockVector
    # Outputs:
    #   length - length of BlockVector
    return length(blockVector.values)
end # function length

function printBlockVector(blockVector::BlockVector, decimals::Int=3)
    # Function for printing BlockVector
    # Inputs:
    #   blockVector - BlockVector
    #   decimals - number of decimals to print
    # Outputs:
    #   nothing
    for i in 1:blockVector.n
        print(round(blockVector[i], digits=decimals), " ")
    end
    print('\n')
end # function printBlockVector


struct BlockMatrix{T<:Number} <: AbstractMatrix{T}
    # BlockMatrix is struct with fields:
    # n - number of elements
    # l - size of inner matrices
    # A - matrix stores inner matrices of size l x l (Ak)
    # B - vector stores vertical vectors of size l (Bk)
    # C - vector stores triangular matrices of size l x l (Ck)
    n::Int
    l::Int
    v::Int
    A::Matrix{T}
    B::Vector{T}
    C::Vector{Vector{T}}

    function BlockMatrix{T}(n::Int, l::Int) where {T}
        # Constructor for BlockMatrix
        # Inputs:
        #   n - number of elements
        #   l - size of inner matrices
        #   v - number of blocks
        # Outputs:
        #   blockMatrix - BlockMatrix with n elements of type T
        if n < 4
            error("n should be >= 4")
        end
        if l < 1
            error("l should be >= 1")
        end
        if n % l != 0
            error("n should be divisible by l")
        end

        v = div(n, l)

        A = Matrix{T}(undef, n, l)
        B = Vector{T}(undef, n - l)
        C = Vector{Vector{T}}(undef, (v - 1))
        for i in 1:length(C)
            C[i] = Vector{T}(undef, div(l * (l + 1), 2))
        end

        # Clear memory for matrices Ak
        for i in size(A, 1)
            for j in size(A, 2)
                A[i, j] = 0
            end
        end

        # Clear memory for vectors Bk
        for i in 1:length(B)
            B[i] = 0
        end

        # Clear memory for matrices Ck
        for i in 1:length(C)
            for j in 1:length(C[i])
                C[i][j] = 0
            end
        end

        new{T}(n, l, v, A, B, C)
    end # function BlockMatrix

    function BlockMatrix{T}(inputFile::String) where {T}
        # Constructor for BlockMatrix
        # Inputs:
        #   inputFile - path to file with matrix description
        # Outputs:
        #   blockMatrix - BlockMatrix with elements of type T
        open(inputFile, "r") do f
            n, l = readline(f) |> split
            blockMatrix = BlockMatrix{T}(parse.(Int, n), parse.(Int, l))

            for line in eachline(f)
                i, j, value = split(line)
                blockMatrix[parse.(Int, i), parse.(Int, j)] = parse.(T, value)
            end

            return blockMatrix
        end
    end # function BlockMatrix
end # struct BlockMatrix

function getindex(blockMatrix::BlockMatrix, row::Int, col::Int)
    # Function for getting value from BlockMatrix at given row and column
    # Inputs:
    #   blockMatrix - BlockMatrix
    #   row - row of element
    #   col - column of element
    # Outputs:
    #   value - value of element at given row and column
    l = blockMatrix.l
    colResidue = (col - 1) % l
    rowResidue = (row - 1) % l
    midBlockLowestRow = col - colResidue
    midBlockHighestRow = midBlockLowestRow + l - 1

    if row < midBlockLowestRow # row in C block
        return blockMatrix.C[div(row - 1, l)+1][div(rowResidue * (rowResidue + 1), 2)+colResidue+1]
    elseif row > midBlockHighestRow # row in B block
        return blockMatrix.B[row-l]
    else # row in A block
        return blockMatrix.A[row, colResidue+1]
    end
end # function getindex

function setindex!(blockMatrix::BlockMatrix, value::T, row::Int, col::Int) where {T}
    # Function for setting value in BlockMatrix at given row and column
    # Inputs:
    #   blockMatrix - BlockMatrix
    #   value - value to set
    #   row - row of element
    #   col - column of element
    # Outputs:
    #   blockMatrix - BlockMatrix with value set at given row and column
    l = blockMatrix.l
    colResidue = (col - 1) % l
    rowResidue = (row - 1) % l
    midBlockLowestRow = col - colResidue
    midBlockHighestRow = midBlockLowestRow + l - 1

    if row < midBlockLowestRow # row in C block
        blockMatrix.C[div(row - 1, l)+1][div(rowResidue * (rowResidue + 1), 2)+colResidue+1] = value
    elseif row > midBlockHighestRow # row in B block
        blockMatrix.B[row-l] = value
    else # row in A block
        blockMatrix.A[row, colResidue+1] = value
    end

    return blockMatrix
end # function setindex!

function size(blockMatrix::BlockMatrix)
    # Function for getting size of BlockMatrix
    # Inputs:
    #   blockMatrix - BlockMatrix
    # Outputs:
    #   size - size of BlockMatrix
    return (blockMatrix.n, blockMatrix.n)
end # function size

function size(blockMatrix::BlockMatrix, dim::Int)
    # Function for getting size of BlockMatrix
    # Inputs:
    #   blockMatrix - BlockMatrix
    #   dim - dimension
    # Outputs:
    #   size - size of BlockMatrix
    return blockMatrix.n
end # function size

function getBlockMatrixRowBounds(blockMatrix::BlockMatrix, row::Int)
    # Function for getting bounds of row in BlockMatrix
    # Inputs:
    #   blockMatrix - BlockMatrix
    #   row - row of element
    # Outputs:
    #   bounds - bounds of row
    n = blockMatrix.n
    l = blockMatrix.l
    v = blockMatrix.v
    k = div(row - 1, l)
    rowResidue = (row - 1) % l

    if k == 0
        return [1, l + rowResidue + 1]
    elseif k == (v - 1)
        return [k * l, n]
    else
        return [k * l, (k + 1) * l + rowResidue + 1]
    end
end # function getBlockMatrixRowBounds

function getBlockMatrixColBounds(blockMatrix::BlockMatrix, col::Int)
    # Function for getting bounds of column in BlockMatrix
    # Inputs:
    #   blockMatrix - BlockMatrix
    #   col - column of element
    # Outputs:
    #   bounds - bounds of column
    n = blockMatrix.n
    l = blockMatrix.l
    k = div(col - 1, l)
    colResidue = (col - 1) % l

    lowerBound = k * l + 1
    if k > 0
        lowerBound -= l
        lowerBound += colResidue
    end

    upperBound = (k + 1) * l
    if colResidue == (l - 1) && col < (n - 1)
        upperBound += l
    end

    return [lowerBound, upperBound]
end # function getBlockMatrixColBounds

function printBlockMatrix(blockMatrix::BlockMatrix, decimals::Int=3)
    # Function for printing BlockMatrix
    # Inputs:
    #   blockMatrix - BlockMatrix
    #   decimals - number of decimals to print
    # Outputs:
    #   nothing
    for row in 1:blockMatrix.n
        cols = getBlockMatrixRowBounds(blockMatrix, row)
        for _ in 1:cols[1]-1
            print("0.", repeat("0", decimals), " ")
        end

        for col in cols[1]:cols[2]
            print(round(blockMatrix[row, col], digits=decimals), " ")
        end

        for _ in cols[2]+1:blockMatrix.n
            print("0.", repeat("0", decimals), " ")
        end
        print('\n')
    end
end # function printBlockMatrix

function *(blockMatrix::BlockMatrix, blockVector::BlockVector)
    # Function for multiplying BlockMatrix and BlockVector
    # Inputs:
    #   blockMatrix - BlockMatrix
    #   blockVector - BlockVector
    # Outputs:
    #   result - BlockVector
    if (size(blockVector, 1) != blockMatrix.n)
        error("Invalid sizes of arguments")
    end

    result = BlockVector{eltype(blockVector)}(blockMatrix.n, 0.0)

    for row in 1:blockMatrix.n
        cols = getBlockMatrixRowBounds(blockMatrix, row)
        for col in cols[1]:cols[2]
            result[row] += blockMatrix[row, col] * blockVector[col]
        end
    end

    return result
end # function *


struct ExtendedBlockMatrix{T<:Number} <: AbstractMatrix{T}
    n::Int
    l::Int
    v::Int
    blocks::Vector{Matrix{T}}

    function ExtendedBlockMatrix{T}(n::Int, l::Int) where {T}
        # Constructor for ExtendedBlockMatrix
        # Inputs:
        #   n - number of elements
        #   l - size of inner matrices
        #   v - number of blocks
        # Outputs:
        #   blockMatrix - ExtendedBlockMatrix with n elements of type T
        if n < 4
            error("n should be >= 4")
        end
        if l < 1
            error("l should be >= 1")
        end
        if n % l != 0
            error("n should be divisible by l")
        end

        v = div(n, l)

        blocks = Vector{Matrix{T}}(undef, v)
        for i in 1:length(blocks)
            if i == 1
                blocks[i] = Matrix{T}(undef, l, 3 * l)
            elseif i == length(blocks)
                blocks[i] = Matrix{T}(undef, l, 2 * l)
            else
                blocks[i] = Matrix{T}(undef, l, 3 * l)
            end
        end

        # Clear memory for matrices Ak
        for i in 1:length(blocks)
            for j in 1:size(blocks[i], 1)
                for k in 1:size(blocks[i], 2)
                    blocks[i][j, k] = 0
                end
            end
        end

        new{T}(n, l, v, blocks)
    end # function ExtendedBlockMatrix

    function ExtendedBlockMatrix{T}(inputFile::String) where {T}
        # Constructor for ExtendedBlockMatrix
        # Inputs:
        #   inputFile - path to file with matrix description
        # Outputs:
        #   blockMatrix - ExtendedBlockMatrix with elements of type T
        open(inputFile, "r") do f
            n, l = readline(f) |> split
            blockMatrix = ExtendedBlockMatrix{T}(parse.(Int, n), parse.(Int, l))

            for line in eachline(f)
                i, j, value = split(line)
                blockMatrix[parse.(Int, i), parse.(Int, j)] = parse.(T, value)
            end

            return blockMatrix
        end
    end # function ExtendedBlockMatrix
end # struct ExtendedBlockMatrix

function getindex(extendedBlockMatrix::ExtendedBlockMatrix, row::Int, col::Int)
    # Function for getting value from ExtendedBlockMatrix at given row and column
    # Inputs:
    #   extendedBlockMatrix - ExtendedBlockMatrix
    #   row - row of element
    #   col - column of element
    # Outputs:
    #   value - value of element at given row and column
    l = extendedBlockMatrix.l
    k = div(row - 1, l) + 1
    rowResidue = (row - 1) % l

    if k < 3
        return extendedBlockMatrix.blocks[k][rowResidue+1, col]
    else
        return extendedBlockMatrix.blocks[k][rowResidue+1, col-(k-2)*l]
    end


end # function getindex

function setindex!(extendedBlockMatrix::ExtendedBlockMatrix, value::T, row::Int, col::Int) where {T}
    # Function for setting value in ExtendedBlockMatrix at given row and column
    # Inputs:
    #   extendedBlockMatrix - ExtendedBlockMatrix
    #   value - value to set
    #   row - row of element
    #   col - column of element
    # Outputs:
    #   extendedBlockMatrix - ExtendedBlockMatrix with value set at given row and column
    l = extendedBlockMatrix.l
    k = div(row - 1, l) + 1
    rowResidue = (row - 1) % l

    if k < 3
        extendedBlockMatrix.blocks[k][rowResidue+1, col] = value
    else
        extendedBlockMatrix.blocks[k][rowResidue+1, col-(k-2)*l] = value
    end

    return extendedBlockMatrix
end # function setindex

function size(extendedBlockMatrix::ExtendedBlockMatrix)
    # Function for getting size of ExtendedBlockMatrix
    # Inputs:
    #   extendedBlockMatrix - ExtendedBlockMatrix
    # Outputs:
    #   size - size of ExtendedBlockMatrix
    return (extendedBlockMatrix.n, extendedBlockMatrix.n)
end # function size

function size(extendedBlockMatrix::ExtendedBlockMatrix, dim::Int)
    # Function for getting size of ExtendedBlockMatrix
    # Inputs:
    #   extendedBlockMatrix - ExtendedBlockMatrix
    #   dim - dimension
    # Outputs:
    #   size - size of ExtendedBlockMatrix
    return extendedBlockMatrix.n
end # function size

function getExtendedBlockMatrixRowBounds(extendedBlockMatrix::ExtendedBlockMatrix, row::Int)
    # Function for getting bounds of row in ExtendedBlockMatrix
    # Inputs:
    #   extendedBlockMatrix - ExtendedBlockMatrix
    #   row - row of element
    # Outputs:
    #   bounds - bounds of row
    l = extendedBlockMatrix.l
    v = extendedBlockMatrix.v
    k = div(row - 1, l) + 1

    if k == 1
        return [1, 3 * l]
    elseif k == v
        return [l * (v - 2) + 1, l * v]
    else
        return [l * (k - 2) + 1, l * (k + 1)]
    end
end # function getExtendedBlockMatrixRowBounds

function getExtendedBlockMatrixColBounds(extendedBlockMatrix::ExtendedBlockMatrix, col::Int)
    # Function for getting bounds of column in ExtendedBlockMatrix
    # Inputs:
    #   extendedBlockMatrix - ExtendedBlockMatrix
    #   col - column of element
    # Outputs:
    #   bounds - bounds of column
    l = extendedBlockMatrix.l
    v = extendedBlockMatrix.v
    k = div(col - 1, l) + 1

    if k == 1
        return [1, 2 * l]
    elseif k == v
        return [l * (v - 2) + 1, l * v]
    else
        return [l * (k - 2) + 1, l * (k + 1)]
    end
end # function getExtendedBlockMatrixColBounds

function printExtendedBlockMatrix(extendedBlockMatrix::ExtendedBlockMatrix, decimals::Int=3)
    # Function for printing ExtendedBlockMatrix
    # Inputs:
    #   extendedBlockMatrix - ExtendedBlockMatrix
    #   decimals - number of decimals to print
    # Outputs:
    #   nothing
    for row in 1:extendedBlockMatrix.n
        cols = getExtendedBlockMatrixRowBounds(extendedBlockMatrix, row)
        for _ in 1:cols[1]-1
            print("0.", repeat("0", decimals), " ")
        end

        for col in cols[1]:cols[2]
            print(round(extendedBlockMatrix[row, col], digits=decimals), " ")
        end

        for _ in cols[2]+1:extendedBlockMatrix.n
            print("0.", repeat("0", decimals), " ")
        end
        print('\n')
    end
end # function printExtendedBlockMatrix

function *(extendedBlockMatrix::ExtendedBlockMatrix, blockVector::BlockVector)
    # Function for multiplying ExtendedBlockMatrix and BlockVector
    # Inputs:
    #   extendedBlockMatrix - ExtendedBlockMatrix
    #   blockVector - BlockVector
    # Outputs:
    #   result - BlockVector
    if (size(blockVector, 1) != extendedBlockMatrix.n)
        error("Invalid sizes of arguments")
    end

    result = BlockVector{eltype(blockVector)}(extendedBlockMatrix.n, 0.0)

    for row in 1:extendedBlockMatrix.n
        cols = getExtendedBlockMatrixRowBounds(extendedBlockMatrix, row)
        for col in cols[1]:cols[2]
            result[row] += extendedBlockMatrix[row, col] * blockVector[col]
        end
    end

    return result
end # function *    

end # module structures