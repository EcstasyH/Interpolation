
@polyvar x y z
# do NOT use x0 as a variable, x0 is used as the homogenization variable
xvars = [x]
yvars = [y]
zvars = [z]

# s1 includes xvars + yvars
# >= 0 
s1 = [ 
        [-1-x]
];

# s1 includes xvars + zvars
s2 = [  
        [x^3]
     ];    

# degree of interpolation template
deg = 1


