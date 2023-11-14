# lie-der
# number of variables
@polyvar x1 x2
vars = [x1, x2]

# vector field
f = [ -2*x2,
      x1^2
     ]

# description polynomial of the initial/unsafe set, >=0 by default
gi = [ 0.16 - (x1+1)^2 - (x2)^2 ]   
gu = [ 0.16 - (x1)^2 - (x2+1)^2 ] 
bc_deg = 1
