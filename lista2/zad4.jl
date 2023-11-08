# Karol Janic
# 3.11.2023
# Lista 2, zad 4

import Pkg
Pkg.add("Polynomials")
Pkg.add("Printf")

using Polynomials
using Printf

function simpleEvaluation(coeffs, x)
    result = 0.0
    for i in 1:20
        result += coeffs[i] * x^i 
    end
    
    return result
end

function hornerEvaluation(x)
    result = 1.0
    for root in 20:-1:1
        result *= (x - root)
    end

    return result
end

function checkRoots(coeffs)
    naturalPoly = Polynomial(reverse(coeffs))
    polyRoots = roots(naturalPoly)

    for (index, root) in enumerate(polyRoots)
        if isreal(root)
            @printf("\\hline\n")
            @printf("%d & %lf & %lf & %lf & %lf \\\\ \n", index, root, abs(naturalPoly(root)), abs(hornerEvaluation(root)), abs(root - index))
        else
            @printf("\\hline")
            @printf("%d & - & - & - & - \\\\ \n", index)
        end
    end
end

checkRoots([
    1, 
    -210.0, 
    20615.0,
    -1256850.0,
    53327946.0,
    -1672280820.0,
    40171771630.0,
    -756111184500.0,          
    11310276995381.0,
    -135585182899530.0,
    1307535010540395.0,
    -10142299865511450.0,
    63030812099294896.0,
    -311333643161390640.0,
    1206647803780373360.0,
    -3599979517947607200.0,
    8037811822645051776.0,
    -12870931245150988800.0,
    13803759753640704000.0,
    -8752948036761600000.0,
    2432902008176640000.0
    ])

checkRoots([
    1, 
    -210.0 - 2^(-23), 
    20615.0,
    -1256850.0,
    53327946.0,
    -1672280820.0,
    40171771630.0,
    -756111184500.0,          
    11310276995381.0,
    -135585182899530.0,
    1307535010540395.0,
    -10142299865511450.0,
    63030812099294896.0,
    -311333643161390640.0,
    1206647803780373360.0,
    -3599979517947607200.0,
    8037811822645051776.0,
    -12870931245150988800.0,
    13803759753640704000.0,
    -8752948036761600000.0,
    2432902008176640000.0
    ])