
# sec 1: illstrative

@polyvar x y z  R r 
# do NOT use x0 as a variable, x0 is used as the homogenization variable
xvars = [x, y, z]
yvars = [ ]

zvars = [R, r]

f1 = 1 + 0.1*z^4 - x^4 - y^4 
f2 = 10*z^4 - x^4 - y^4
g1 = 4*R^2*(x^2 + y^2) - (x^2 + y^2 + z^2 + R^2 - r^2)^2
g2 = R - 4
g3 = 6 - R
g4 = r - 0.5
g5 = 1 - r 


# s1 includes xvars + yvars
# >= 0 
s1 = [ 
        [f1,f2]
];

# s1 includes xvars + zvars
s2 = [  
        [g1, g2, g3, g4, g5]
     ];    

# degree of interpolation template
deg = 2

# for tssos
d_relax = 2