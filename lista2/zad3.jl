# Karol Janic
# 3.11.2023
# Lista 2, zad 3

import Pkg
Pkg.add("Printf")

using Printf

include("hilb.jl")
include("matcond.jl")

function solveGauss(A, b)
    return A \ b
end


function solveInv(A, b)
    return inv(A) * b
end


function compareHilberts(nValues)
    for n in nValues
        A = hilb(n)
        condA = cond(A)
        rankA = rank(A)

        expectedX = ones(n)
        b = A * expectedX

        gaussX = solveGauss(A, b)
        invX = solveInv(A, b)

        gaussErr = norm(gaussX - expectedX) / norm(expectedX)
        invErr = norm(invX - expectedX) / norm(expectedX)

        @printf("\\hline\n")
        @printf("%d & %d & %.2e & %.2e & %.2e \\\\ \n", n, rankA, condA, gaussErr, invErr)
    end
end


function compareRandoms(nValues, cValues)
    for c in cValues
        @printf("\\hline\n")
        @printf("%d", c)

        for n in nValues
            A = matcond(n, c)
            condA = cond(A)
            rankA = rank(A)

            expectedX = ones(n)
            b = A * expectedX

            gaussX = solveGauss(A, b)
            invX = solveInv(A, b)

            gaussErr = norm(gaussX - expectedX) / norm(expectedX)
            invErr = norm(invX - expectedX) / norm(expectedX)

            @printf(" & %d & %.2e & %.2e", rankA, gaussErr, invErr)
        end
        @printf(" \\\\ \n")
    end
end

println("Hilbert:")
compareHilberts([2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15])

println("Random:")
compareRandoms([5, 10, 20], [1.0, 10.0, 1.0e3, 1.0e7, 1.0e12, 1.0e16])