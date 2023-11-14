# lti
# number of variables
@polyvar x1 x2
vars = [x1, x2]

# vector field
f = [ -1/3*x1^3+x1-x2+0.875,
      0.08*(x1-0.8*x2+0.7)
     ]

# description polynomial of the initial/unsafe set, >=0 by default
gi = [0.25^2 - (x1+0.75)^2 - (x2-1.25)^2]
gu = [-2-x2]
bc_deg = 4
