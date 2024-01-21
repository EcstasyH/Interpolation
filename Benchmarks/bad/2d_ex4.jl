
@polyvar x y z a1 R r 
# do NOT use x0 as a variable, x0 is used as the homogenization variable
xvars = [x, y, z]
yvars = [a1]
zvars = [R, r]

f1 = 1 + 0.1*z^4 - x^4 - y^4 
f2 = 10*z^4 - x^4 - y^4
g1 = 4*5^2*(x^2 + y^2) - (x^2 + y^2 + z^2 + 5^2 - 0.75^2)^2



# s1 includes xvars + yvars
# >= 0 
s1 = [ 
        [f1,f2]
];

# s1 includes xvars + zvars
s2 = [  
        [g1]
     ];    

# degree of interpolation template
# deg = 2
deg = 2

