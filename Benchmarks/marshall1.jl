
@polyvar x y z
# do NOT use x0 as a variable, x0 is used as the homogenization variable
xvars = [x]
yvars = [y]
zvars = [z]

# s1 includes xvars + yvars
# >= 0 
s1 = [ 
        [x^3 - y^2]
];

# s1 includes xvars + zvars
s2 = [  
        [-1-x - z^2]
     ];    

# degree of interpolation template
deg = 1


