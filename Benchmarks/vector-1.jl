# number of variables
@polyvar x1  x2
vars = [x1, x2]
# vector field
f = [ x2,
      x1]

# description polynomial of the initial/unsafe set, >=0 by default
gi = [ x1+4, x2+4, -x1, -x2 ]  
gu = [ 2-(x1+2)^2-(x2-2)^2] 
bc_deg = 2
