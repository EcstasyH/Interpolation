# lti
# number of variables
@polyvar x1 x2
vars = [x1, x2]

# vector field
f = [ x1-x1^3+x2-x1*x2^2,
      -x1+x2-x1^2*x2-x2^3
     ]

# description polynomial of the initial/unsafe set, >=0 by default
gi = [x1-x2^2-2, x2, x1]
gu = [-x1^2-2-x2, -x2]
bc_deg = 1
