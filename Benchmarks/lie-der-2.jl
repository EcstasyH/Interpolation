# lie-der
# number of variables
@polyvar x1 x2
vars = [x1, x2]

# vector field
f = [ -2*x2,
      x1^2
     ]

# description polynomial of the initial/unsafe set, >=0 by default
#gi = [ -x1-x2^2-1, -x1 ]  
gi = [ 1-x2^2, -1-x1 ]  
gu = [ x1 - 0.04*x2^2 - 2, x1] 
bc_deg = 3
