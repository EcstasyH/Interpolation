
@polyvar x y z1 z2 w1 w2
# do NOT use x0 as a variable, x0 is used as the homogenization variable
xvars = [x, y]
yvars = [z1, z2]
zvars = [w1, w2]

# s1 includes xvars + yvars
# >= 0 
s1 = [ 
        [16-(x+y-4)^2+16*(x-y)^2, x+y-z1^2-(2-z1)^2],
        [16-(x+y+4)^2+16*(x-y)^2, -x-y-z2^2-(2-z2)^2]
];

# s1 includes xvars + zvars
s2 = [  
        [16-16*(x+y)^2-(x-y+4)^2, y-x-w1^2-(1-w1)^2],
        [16-16*(x+y)^2-(x-y-4)^2, x-y-w2-(1-w2)^2]
     ];    

# degree of interpolation template
deg = 2