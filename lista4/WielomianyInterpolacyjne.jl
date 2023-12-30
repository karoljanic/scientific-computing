# Karol Janic
# 1.12.2023
# Lista 4, zad 1, 2, 3, 4

module WielomianyInterpolacyjne
export ilorazyRoznicowe, warNewton, naturalna, rysujNnfx

# using Pkg
# Pkg.add("Plots")

using Plots

"""
Funkcja wyznaczająca ilorazy różnicowe dla zadanych węzłów 
oraz wartości funkcji w tych węzłach

# Dane
x - wektor długości n+1 zawierający węzły x0, x1, ..., xn
f - wektor długości n+1 zawierający wartości funkcji w zadanych 
    węzłach f(x0), f(x1), ..., f(xn)

# Wyniki
fx - wektor długości n+1 zawierający ilorazy różnicowe
"""
function ilorazyRoznicowe(x::Vector{Float64}, f::Vector{Float64})
    xLen = length(x)
    fx = copy(f)

    for i in 2:xLen
        for j in xLen:-1:i
            fx[j] = (fx[j] - fx[j-1]) / (x[j] - x[j-i+1])
        end
    end

    return fx
end

"""
Funkcja obliczająca wartość wielomianu interpolacyjnego
w postaci Newtona dla zadanej reprezentacji oraz zadanego argumentu

# Dane
x - wektor długości n+1 zawierający węzły x0, x1, ..., xn
fx - wektor długości n+1 zawierający ilorazy różnicowe
t - argument dla którego wartość jest obliczan

# Wyniki
ft - wartość wielomianu interpolacyjnego w punkcie t
"""
function warNewton(x::Vector{Float64}, fx::Vector{Float64}, t::Float64)
    xLen = length(x)
    ft = fx[xLen]

    for i in (xLen-1):-1:1
        ft = fx[i] + (t - x[i]) * ft
    end

    return ft
end

"""
Funkcja wyznaczająca współczynniki wielomianu interpolacyjnego 
w postaci naturalnej dla zadanej reprezentacji

# Dane
x - wektor długości n+1 zawierający węzły x0, x1, ..., xn
fx - wektor długości n+1 zawierający ilorazy różnicowe

# Wyniki
a - wektor długości n+1 zawierający współczynniki wielomianu interpolacyjnego 
w postaci normalnej: a0, a1, ..., an
"""
function naturalna(x::Vector{Float64}, fx::Vector{Float64})
    xLen = length(x)
    a = copy(fx)

    for i in (xLen-1):-1:1
        for j in i:(xLen-1)
            a[j] -= a[j+1] * x[i]
        end
    end

    return a
end

"""
Funkcja interpolująca zadaną funkcję f na zadanym przedziale [a, b]
za pomocą wielomianu interpolacyjnego stopnia n w postaci Newtona
przy użyciu węzłów równoległych, tj. 
xk = a+k*h;     h = (b-a)/n;      k = 0, 1, ..., n

# Dane
f - funkcja do interpolacji zadana jako anonimowa funkcja
a - dolny przedział interpolacji
b - górny przedział interpolacji
n - stopień wielomianu interpolacyjnego
d - liczba punktów przy rysowaniu funkcji przypadająca na jeden węzeł

# Wyniki
wykres zawierający wielomian interpolacyjny i interpolowaną
funkcję w przedziale [a, b]
"""
function rysujNnfx(f, a::Float64, b::Float64, n::Int, d::Int=100)
    h = (b - a) / n
    w = Vector{Float64}(undef, n + 1)   # węzły
    fw = Vector{Float64}(undef, n + 1)  # wartości f w węzłach

    for k in 0:n
        w[k+1] = a + k * h
        fw[k+1] = f(w[k+1])
    end

    fx = ilorazyRoznicowe(w, fw) # postać Newtona wielomianu interpolacyjnego

    m = d * (n + 1)
    dx = (b - a) / m

    x = Vector{Float64}(undef, m + 1)
    yF = Vector{Float64}(undef, m + 1)
    yW = Vector{Float64}(undef, m + 1)

    for k in 0:m
        x[k+1] = a + k * dx
        yF[k+1] = f(x[k+1])
        yW[k+1] = warNewton(w, fx, x[k+1])
    end

    p = plot(x, [yF, yW], label=["funkcja" "wielomian interpolacyjny"], fmt=:png)
    scatter!(w, fw, label="węzły", markersize=4)
end

end # WielomianyInterpolacyjne
