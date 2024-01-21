
@polyvar x y a b
# do NOT use x0 as a variable, x0 is used as the homogenization variable
xvars = [x, y]
yvars = [a]
zvars = [b]


# s1 includes xvars + yvars
# >= 0 
f1 = 11 - x^4 + 0.1*y^4
f2 = y^3
f3 = 0.9025 - (x-1)^4 - y^4
f4 = (x-1)^4 + y^4 - 0.09
f5 = (x+1)^4 + y^4 - 1.1025
f6 = 0.04 - (x+1)^4 - y^4

g1 = 11 - x^4 + 0.1*y^4
g2 = -y^3
g3 = 0.9025 - (x+1)^4 - y^4
g4 = (x+1)^4 + y^4 - 0.09
g5 = (x-1)^4 + y^4 - 1.1025
g6 = 0.04 - (x-1)^4 - y^4

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



