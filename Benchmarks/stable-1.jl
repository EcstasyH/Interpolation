# number of variables
@polyvar x1 x2 x3
vars = [x1, x2, x3]

# vector field
f = [ -x1+x2-x3,
      -x1*(x3+1)-x2,
      0.76524*x1-4.7037*x3
     ];

# description polynomial of the initial/unsafe set, >=0 by default
gi = [ 0.25 - (x1)^2 - (x2)^2 - (x3)^2 ]  
# gu = [ 0.25 - (x1+0)^2 - (x2+1)^2 - (x3-1)^2]
gu = [ 0.04-(x1-1.8)^2-(x2-1.8)^2-x3^2 ]
bc_deg = 5
