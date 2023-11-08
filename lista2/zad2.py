# Karol Janic
# 3.11.2023
# Lista 2, zad 2

import numpy as np
import matplotlib.pyplot as plt

def f(x):
    return np.exp(x) * np.log(1 + np.exp(-x))

x1 = np.linspace(-50, 50, 1000)
x2 = np.linspace(32, 40, 1000)
x3 = np.linspace(20, 30, 1000)

y1 = f(x1)
y2 = f(x2)
y3 = f(x3)

plt.clf()
plt.plot(x1, y1, color="green")
plt.xlabel("x")
plt.ylabel("f(x)")
plt.savefig("report/plots/f(x)-1-pyplot")

plt.clf()
plt.plot(x2, y2, color="green")
plt.xlabel("x")
plt.ylabel("f(x)")
plt.savefig("report/plots/f(x)-2-pyplot")

plt.clf()
plt.plot(x3, y3, color="green")
plt.xlabel("x")
plt.ylabel("f(x)")
plt.savefig("report/plots/f(x)-3-pyplot")