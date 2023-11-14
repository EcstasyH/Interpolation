# number of variables
@polyvar x1 x2
vars = [x1, x2]
# vector field
f = [ x2,
     -x1 + (1/3)*x1^3 - x2]

# description polynomial of the initial/unsafe set, >=0 by default
gi = [ x1*x2-1,x1 ]  
gu = [ -2-x1, x2-2 ] 
bc_deg = 2
