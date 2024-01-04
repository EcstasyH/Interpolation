
@polyvar x y z w
# do NOT use x0 as a variable, x0 is used as the homogenization variable
xvars = [x, y]
yvars = [z]
zvars = [w]

# s1 includes xvars + yvars
# >= 0 
s1 = [ 
        [4-x-y^2-z^2],
        [x^2-z^2-y^2]
];

# s1 includes xvars + zvars
s2 = [  
        [y^2-(x^2+4)^2],
     ];    

# degree of interpolation template
deg = 4