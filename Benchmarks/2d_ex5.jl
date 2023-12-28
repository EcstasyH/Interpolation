
@polyvar x y y0 z0
# do NOT use x0 as a variable, x0 is used as the homogenization variable
xvars = [x, y]
yvars = [y0]
zvars = [z0]

e = 0.1
# s1 includes xvars + yvars
# >= 0 
s1 = [ 
        [x^2+y^2-25],
        [1-x^2-y^2]
];

# s1 includes xvars + zvars
s2 = [  
        [x^2/2+y^2/4-1, 81-x^4-y^4],
     ];    

# degree of interpolation template
deg = 4


