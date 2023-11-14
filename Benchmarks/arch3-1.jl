# lti
# number of variables
@polyvar x1 x2
vars = [x1, x2]

# vector field
f = [ x1-x1^3+x2-x1*x2^2,
      -x1+x2-x1^2*x2-x2^3
     ]

# description polynomial of the initial/unsafe set, >=0 by default
gi = [0.04 - (x1)^2 - (x2)^2]
gu = [0.25 - (x1-2.5)^2 - (x2-2.5)^2]
bc_deg = 2
