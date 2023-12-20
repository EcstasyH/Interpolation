
@polyvar x y y0 z0
# do NOT use x0 as a variable, x0 is used as the homogenization variable
xvars = [x, y]
yvars = [y0]
zvars = [z0]

e = 0.1
# s1 includes xvars + yvars
# >= 0 
s1 = [ 
        [y^2-x^2-1],
        # [(y+3)^2-(x+3)^2, (x+3)^2-(y+3)^2],
        # [(y-3)^2-(x-3)^2, (x-3)^2-(y-3)^2]
];

# s1 includes xvars + zvars
s2 = [  
        [x^2-(1+e)*y^2]
     ];    

# degree of interpolation template
deg = 2


