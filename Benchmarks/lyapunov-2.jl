# number of variables
@polyvar x1 x2 x3
vars = [x1, x2, x3]

# vector field
f = [ -x2,
      -x3,
      -x1-2*x2-x3+x1^3
     ];

# description polynomial of the initial/unsafe set, >=0 by default
gi = [ 0.25 - (x1-0.25)^2 - (x2-0.25)^2 - (x3-0.25)^2 ]  
# gu = [ 0.25 - (x1+0)^2 - (x2+1)^2 - (x3-1)^2]
gu = [ x1-2, -2-x2, -2-x3]
bc_deg = 5
