# lti
# number of variables
@polyvar x1 x2
vars = [x1, x2]

# vector field
f = [ -2*x1+x1^2+x2,
      x1-2*x2+x2^2
     ]

# description polynomial of the initial/unsafe set, >=0 by default
gi = [ 0.1^2-x1^2-x2^2 ]
gu = [ 0.25^2-(x1-0.75)^2-(x2-0.75)^2 ]
bc_deg = 3
