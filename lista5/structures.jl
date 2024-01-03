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
    # v - number of blocks
    # values - vector of vectors of values with length n and type T
    n::Int
    l::Int
    v::Int
    values::Vector{Vector{T}}

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

        values = Vector{Vector{T}}(undef, n)
        for i in 1:n
            cols = getBlockMatrixRowBounds(n, l, i)
            values[i] = Vector{T}(undef, cols[2] - cols[1] + 1)
        end

        # Clear memory
        for i in 1:length(values)
            for j in 1:length(values[i])
                values[i][j] = 0
            end
        end

        new{T}(n, l, v, values)
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
    cols = getBlockMatrixRowBounds(blockMatrix.n, blockMatrix.l, row)
    if col < cols[1] || col > cols[2]
        return 0
    else
        return blockMatrix.values[row][col-cols[1]+1]
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
    cols = getBlockMatrixRowBounds(blockMatrix.n, blockMatrix.l, row)
    if col >= cols[1] && col <= cols[2]
        blockMatrix.values[row][col-cols[1]+1] = value
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

function getBlockMatrixRowBounds(n::Int, l::Int, row::Int)
    # Function for getting bounds of row in BlockMatrix
    # Inputs:
    #   n - n of BlockMatrix
    #   l - l of BlockMatrix
    #   row - row of element
    # Outputs:
    #   bounds - bounds of row
    k = div(row - 1, l)

    return [max(1, k * l), min(n, row + l)]
end # function getBlockMatrixRowBounds

function getBlockMatrixColBounds(n::Int, l::Int, col::Int)
    # Function for getting bounds of column in BlockMatrix
    # Inputs:
    #   n - n of BlockMatrix
    #   l - l of BlockMatrix
    #   col - column of element
    # Outputs:
    #   bounds - bounds of column
    k = div(col, l)

    return [max(1, col - l), min(n, (k + 1) * l)]
end # function getBlockMatrixColBounds

function printBlockMatrix(blockMatrix::BlockMatrix, decimals::Int=3)
    # Function for printing BlockMatrix
    # Inputs:
    #   blockMatrix - BlockMatrix
    #   decimals - number of decimals to print
    # Outputs:
    #   nothing
    for row in 1:blockMatrix.n
        cols = getBlockMatrixRowBounds(blockMatrix.n, blockMatrix.l, row)
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
        cols = getBlockMatrixRowBounds(blockMatrix.n, blockMatrix.l, row)
        for col in cols[1]:cols[2]
            result[row] += blockMatrix[row, col] * blockVector[col]
        end
    end

    return result
end # function *


struct ExtendedBlockMatrix{T<:Number} <: AbstractMatrix{T}
    # ExtendedBlockMatrix is struct with fields:
    # n - number of elements
    # l - size of inner matrices
    # v - number of blocks
    # values - vector of vectors with length v and type T
    n::Int
    l::Int
    v::Int
    values::Vector{Vector{T}}

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

        values = Vector{Vector{T}}(undef, n)
        for i in 1:n
            cols = getExtendedBlockMatrixRowBounds(n, l, i)
            values[i] = Vector{T}(undef, cols[2] - cols[1] + 1)
        end

        # Clear memory
        for i in 1:length(values)
            for j in 1:length(values[i])
                values[i][j] = 0
            end
        end

        new{T}(n, l, v, values)
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
    cols = getExtendedBlockMatrixRowBounds(extendedBlockMatrix.n, extendedBlockMatrix.l, row)
    if col < cols[1] || col > cols[2]
        return 0
    else
        return extendedBlockMatrix.values[row][col-cols[1]+1]
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
    cols = getExtendedBlockMatrixRowBounds(extendedBlockMatrix.n, extendedBlockMatrix.l, row)
    if col >= cols[1] && col <= cols[2]
        extendedBlockMatrix.values[row][col-cols[1]+1] = value
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

function getExtendedBlockMatrixRowBounds(n::Int, l::Int, row::Int)
    # Function for getting bounds of row in ExtendedBlockMatrix
    # Inputs:
    #   extendedBlockMatrix - ExtendedBlockMatrix
    #   row - row of element
    # Outputs:
    #   bounds - bounds of row
    k1 = div(row - 1, l)
    k2 = div(row, l)

    return [max(1, k1 * l), min(n, (k2 + 2) * l)]
end # function getExtendedBlockMatrixRowBounds

function getExtendedBlockMatrixColBounds(n::Int, l::Int, col::Int)
    # Function for getting bounds of column in ExtendedBlockMatrix
    # Inputs:
    #   extendedBlockMatrix - ExtendedBlockMatrix
    #   col - column of element
    # Outputs:
    #   bounds - bounds of column
    k1 = div(col - l - 1, l)
    k2 = div(col, l)

    return return [max(1, k1 * l), min(n, (k2 + 1) * l)]
end # function getExtendedBlockMatrixColBounds

function printExtendedBlockMatrix(extendedBlockMatrix::ExtendedBlockMatrix, decimals::Int=3)
    # Function for printing ExtendedBlockMatrix
    # Inputs:
    #   extendedBlockMatrix - ExtendedBlockMatrix
    #   decimals - number of decimals to print
    # Outputs:
    #   nothing
    for row in 1:extendedBlockMatrix.n
        cols = getExtendedBlockMatrixRowBounds(extendedBlockMatrix.n, extendedBlockMatrix.l, row)
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
        cols = getExtendedBlockMatrixRowBounds(extendedBlockMatrix.n, extendedBlockMatrix.l, row)
        for col in cols[1]:cols[2]
            result[row] += extendedBlockMatrix[row, col] * blockVector[col]
        end
    end

    return result
end # function *    

end # module structures