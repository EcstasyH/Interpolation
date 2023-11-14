# number of variables
@polyvar x1 x2 x3
vars = [x1, x2, x3]

# vector field
f = [ 10*(x2-x1),
     -x2+x1*(28-x3),
     x1*x2-8/3*x3
     ];

# description polynomial of the initial/unsafe set, >=0 by default
gi = [ 1 - (x1+14.5)^2 - (x2 + 14.5)^2 - (x3-12.5)^2 ]  
gu = [ -4-0.01*x1^2-0.01*x2^2-x3, -x3 ]
bc_deg = 1
