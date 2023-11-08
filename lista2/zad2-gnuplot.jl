# Karol Janic
# 3.11.2023
# Lista 2, zad 2

import Pkg
Pkg.add("Gnuplot")

using Gnuplot

@gp "f(x) = exp(x) * log(1.0 + exp(-x))"
@gp :- "set xrange [-50:50]"
@gp :- "set yrange [-0.2:1.5]"
@gp :- "set xlabel \" x\""
@gp :- "set ylabel \" f(x)\""
@gp :- "plot f(x) notitle"

save(term="pngcairo size 480,360", output="report/plots/f(x)-1-gnuplot.png")

@gp "f(x) = exp(x) * log(1.0 + exp(-x))"
@gp :- "set xrange [32:40]"
@gp :- "set yrange [-0.2:2.0]"
@gp :- "set xlabel \" x\""
@gp :- "set ylabel \" f(x)\""
@gp :- "plot f(x) notitle"

save(term="pngcairo size 480,360", output="report/plots/f(x)-2-gnuplot.png")
