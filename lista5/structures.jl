# Karol Janic

module structures

export BlockMatrix, BlockVector, printBlockVector, printBlockMatrix


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

function Base.getindex(blockVector::BlockVector, index::Int)
    # Function for getting value from BlockVector at given index
    # Inputs:
    #   blockVector - BlockVector
    #   index - index of element
    # Outputs:
    #   value - value of element at given index
    return blockVector.values[index]
end # function getindex

function Base.setindex!(blockVector::BlockVector, value::T, index::Int) where {T}
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

function Base.size(blockVector::BlockVector)
    # Function for getting size of BlockVector
    # Inputs:
    #   blockVector - BlockVector
    # Outputs:
    #   size - size of BlockVector
    return size(blockVector.values)
end # function size

function Base.length(blockVector::BlockVector)
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
    A::Matrix{T}
    B::Vector{T}
    C::Vector{T}

    function BlockMatrix{T}(n::Int, l::Int) where {T}
        # Constructor for BlockMatrix
        # Inputs:
        #   n - number of elements
        #   l - size of inner matrices
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

        A = Matrix{T}(undef, n, l)
        B = Vector{T}(undef, n - l)
        C = Vector{T}(undef, div(l * (l + 1), 2) * (div(n, l) - 1))

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
            C[i] = 0
        end

        new{T}(n, l, A, B, C)
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

function Base.getindex(blockMatrix::BlockMatrix, row::Int, col::Int)
    l = blockMatrix.l

    colResidue = (col - 1) % l
    midBlockLowestRow = col - colResidue
    midBlockHighestRow = midBlockLowestRow + l - 1

    rowResidue = (row - 1) % l

    if row < midBlockLowestRow
        return blockMatrix.C[div((row - 1), l)*div(l * (l + 1), 2)+div(rowResidue * (rowResidue + 1), 2)+colResidue+1]
    elseif row > midBlockHighestRow
        return blockMatrix.B[row-l]
    else
        return blockMatrix.A[row, colResidue+1]
    end
end # function getindex

function Base.setindex!(blockMatrix::BlockMatrix, value::T, row::Int, col::Int) where {T}
    l = blockMatrix.l

    colResidue = (col - 1) % l
    midBlockLowestRow = col - colResidue
    midBlockHighestRow = midBlockLowestRow + l - 1

    rowResidue = (row - 1) % l

    if row < midBlockLowestRow
        blockMatrix.C[div((row - 1), l)*div(l * (l + 1), 2)+div(rowResidue * (rowResidue + 1), 2)+colResidue+1] = value
    elseif row > midBlockHighestRow
        blockMatrix.B[row-l] = value
    else
        blockMatrix.A[row, colResidue+1] = value
    end

    return blockMatrix
end # function setindex!

function Base.size(blockMatrix::BlockMatrix)
    return (blockMatrix.n, blockMatrix.n)
end # function size

function Base.size(blockMatrix::BlockMatrix, dim::Int)
    return blockMatrix.n
end # function size

function printBlockMatrix(blockMatrix::BlockMatrix, decimals::Int=3)
    n = blockMatrix.n
    l = blockMatrix.l

    for v in 0:(div(n, l)-1)
        for ii in 1:l
            i = v * l + ii

            if v == 0
                # A block
                for j in 1:l
                    print(round(blockMatrix[i, j], digits=decimals), " ")
                end

                # Zeros
                for j in l+1:l+ii-1
                    print("0.", repeat("0", decimals), " ")
                end

                # C block
                print(round(blockMatrix[i, l+ii], digits=decimals), " ")

                # Zeros
                for j in l+ii+1:n
                    print("0.", repeat("0", decimals), " ")
                end
            elseif v == (div(n, l) - 1)
                # Zeros
                for j in 1:v*l-1
                    print("0.", repeat("0", decimals), " ")
                end

                # B block 
                print(round(blockMatrix[i, v*l], digits=decimals), " ")

                # A block
                for j in v*l+1:v*l+l
                    print(round(blockMatrix[i, j], digits=decimals), " ")
                end
            else
                # Zeros
                for j in 1:v*l-1
                    print("0.", repeat("0", decimals), " ")
                end

                # B block 
                print(round(blockMatrix[i, v*l], digits=decimals), " ")

                # A block
                for j in v*l+1:v*l+l
                    print(round(blockMatrix[i, j], digits=decimals), " ")
                end

                # Zeros
                for j in v*l+l+1:v*l+l+ii-1
                    print("0.", repeat("0", decimals), " ")
                end

                # C block
                print(round(blockMatrix[i, v*l+l+ii], digits=decimals), " ")

                # Zeros
                for j in v*l+l+ii+1:n
                    print("0.", repeat("0", decimals), " ")
                end
            end

            println()
        end
    end
end # function printBlockMatrix

function Base .* (blockMatrix::BlockMatrix, vector::BlockVector)
    if (size(vector, 1) != blockMatrix.n)
        error("Invalid sizes of arguments")
    end

    n = blockMatrix.n
    l = blockMatrix.l

    result = BlockVector{eltype(vector)}(n, 0.0)

    for v in 0:(div(n, l)-1)
        for ii in 1:l
            i = v * l + ii

            if v == 0
                # A block
                for j in 1:l
                    result[i] += blockMatrix[i, j] * vector[j]
                end

                # C block
                result[i] += blockMatrix[i, l+ii] * vector[l+ii]
            elseif v == (div(n, l) - 1)
                # B block 
                result[i] += blockMatrix[i, v*l] * vector[v*l]

                # A block
                for j in v*l+1:v*l+l
                    result[i] += blockMatrix[i, j] * vector[j]
                end
            else
                # B block 
                result[i] += blockMatrix[i, v*l] * vector[v*l]

                # A block
                for j in v*l+1:v*l+l
                    result[i] += blockMatrix[i, j] * vector[j]
                end

                # C block
                result[i] += blockMatrix[i, v*l+l+ii] * vector[v*l+l+ii]
            end
        end
    end

    return result
end # function *

end # module structures