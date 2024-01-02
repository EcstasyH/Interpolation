
@polyvar x a b c d
# do NOT use x0 as a variable, x0 is used as the homogenization variable
xvars = [x]
yvars = [a, b]
zvars = [c, d]

# s1 includes xvars + yvars
# >= 0 
s1 = [ 
        [x^3 - a, a^3-b^2-1]
];

# s1 includes xvars + zvars
s2 = [  
        [-x-c, c^3-d^2-(1-d)^2]
        # [-x-c, c^3-d^2-(1-d)^2]
     ];    

# degree of interpolation template
deg = 1


