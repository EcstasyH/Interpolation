# lti
# number of variables
@polyvar x1 x2
vars = [x1, x2]

# vector field
f = [ x1^2+x2^2-1,
      5*(x1*x2-1)
     ]

# description polynomial of the initial/unsafe set, >=0 by default
gi = [x1-2, -2-x2]
gu = [x2 - x1^2 - 1, x2]
bc_deg = 1
