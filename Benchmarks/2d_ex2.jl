
@polyvar x y y0 z0
# do NOT use x0 as a variable, x0 is used as the homogenization variable
xvars = [x, y]
yvars = [y0]
zvars = [z0]


# s1 includes xvars + yvars
# >= 0 
f1 = 3.8025 - x^2 + 0.1*y^2
f2 = y
f3 = 0.9025 - (x-1)^2 - y^2
f4 = (x-1)^2 + y^2 - 0.09
f5 = (x+1)^2 + y^2 - 1.1025
f6 = 0.04 - (x+1)^2 - y^2

g1 = 3.8025 - x^2 + 0.1*y^2
g2 = -y
g3 = 0.9025 - (x+1)^2 - y^2
g4 = (x+1)^2 + y^2 - 0.09
g5 = (x-1)^2 + y^2 - 1.1025
g6 = 0.04 - (x-1)^2 - y^2

s1 = [ 
        [f1, f2, f4, f5],
        [f3, f4, f5],
        [f6]
];

# s1 includes xvars + zvars
s2 = [ 
        [g1, g2, g4, g5],
        [g3, g4, g5],
        [g6]
];
# degree of interpolation template
deg = 7


