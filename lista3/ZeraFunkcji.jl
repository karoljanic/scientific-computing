# Karol Janic
# 13.11.2023
# Lista 3, zad 1, 2, 3

module ZeraFunkcji
export mbisekcji, mstycznych, msiecznych

"""
Funkcja rozwiązująca równanie f(x) = 0 metodą bisekcji

# Dane
f - funkcja f(x) zadana jako anonimowa funkcja
a - lewy koniec przedziału początkowego
b - prawy koniec przedziału początkowego
delta - dokładność obliczeń
epsilon - dokładność obliczeń

# Wyniki
Czwórka (r, v, it, err), gdzie
r - przybliżenie pierwiastka równania f(x) = 0
v - wartość f(r)
it - liczba wykonanych iteracji
err - sygnalizacja błędu:
    0 - brak błędu
    1 - funkcja nie zmienia znaku w przedziale [a,b]
"""
function mbisekcji(f, a::Float64, b::Float64, delta::Float64, epsilon::Float64)
    fa = f(a)
    fb = f(b)

    if sign(fa) == sign(fb)
        return 0, 0, 0, 1
    end

    e = b - a
    it = 0
    while true
        it = it + 1
        e = e / 2
        c = a + e
        fc = f(c)
        if abs(e) < delta || abs(fc) < epsilon
            return c, fc, it, 0
        end

        if sign(fa) == sign(fc)
            a = c
            fa = fc
        else
            b = c
            fb = fc
        end
    end
end


"""
Funkcja rozwiązująca równanie f(x) = 0 metodą stycznych(Newtona)

# Dane
f - funkcja f(x) zadana jako anonimowa funkcja
pf - pochodna f'(x) zadana jako anonimowa funkcja
x0 - przybliżenie początkowe
delta - dokładności obliczeń
epsilon - dokładności obliczeń
maxit - maksymalna dopuszczalna liczba iteracji

# Wyniki
Czwórka (r, v, it, err), gdzie
r - przybliżenie pierwiastka równania f(x) = 0
v - wartość f(r)
it - liczba wykonanych iteracji
err - sygnalizacja błędu:
    0 - brak błędu
    1 - nie osiągnięto wymaganej dokładności w maxit iteracji
    2 - pochodna bliska zeru
"""
function mstycznych(f, pf, x0::Float64, delta::Float64, epsilon::Float64, maxit::Int)
    fx = f(x0)
    if abs(fx) < epsilon
        return x0, fx, 0, 0
    end

    x = x0
    for it = 1:maxit
        dfx = pf(x)
        if abs(dfx) < 10.0 * eps(Float64)
            return x, fx, it, 2
        end
        
        newx = x - fx / dfx
        fx = f(newx)
        if abs(newx - x) < delta || abs(fx) < epsilon
            return newx, fx, it, 0
        end
        
        x = newx
    end

    return x, fx, maxit, 1
end


"""
Funkcja rozwiązująca równanie f(x) = 0 metodą siecznych

# Dane
f - funkcja f(x) zadana jako anonimowa funkcja
x0 - pierwsze przybliżenia początkowe
x1 - drugie przybliżenia początkowe
delta - dokładności obliczeń
epsilon - dokładności obliczeń
maxit - maksymalna dopuszczalna liczba iteracji

# Wyniki
Czwórka (r, v, it, err), gdzie
r - przybliżenie pierwiastka równania f(x) = 0
v - wartość f(r)
it - liczba wykonanych iteracji
err - sygnalizacja błędu:
    0 - brak błędu
    1 - nie osiągnięto wymaganej dokładności w maxit iteracji
"""
function msiecznych(f, x0::Float64, x1::Float64, delta::Float64, epsilon::Float64, maxit::Int)
    fx0 = f(x0)
    fx1 = f(x1)

    for it = 1:maxit
        if abs(fx0) > abs(fx1)
            x0, x1 = x1, x0
            fx0, fx1 = fx1, fx0
        end

        s = (x1 - x0) / (fx1 - fx0)
        x1 = x0
        fx1 = fx0
        x0 = x0 - fx0 * s
        fx0 = f(x0)

        if abs(x1 - x0) < delta || abs(fx0) < epsilon
            return x0, fx0, it, 0
        end
    end

    return x0, fx0, it, maxit
end 

end # ZeraFunkcji
