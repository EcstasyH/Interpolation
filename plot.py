import matplotlib.pyplot as plt
import numpy as np

def f(x, y):
  return 0.0000592146 * x * y**2 - 0.0000368594 * x**3 * y**2 - 0.0000272932 * y**3 - 0.0000137155 * x**2 * y**3 + 0.0000699586 * x * y**4 + 0.000133369 * y**5

x = np.linspace(-1, 1, 1000)
y = np.linspace(-1, 1, 1000)

X, Y = np.meshgrid(x, y)
Z = f(X, Y)

plt.contour(X, Y, Z, 0, colors='black')
plt.show()