@polyvar x y z w
# do NOT use x0 as a variable, x0 is used as the homogenization variable
xvars = [x, y]
yvars = [z]
zvars = [w]

# s1 includes xvars + yvars
# >= 0 
s1 = [ -2*x*y^2 + x^2 - 3*x*z - y^2 - y*z + z^2 - 1,
       100 - x^2 - y^2,
       - x^2*z^2 - y^2*z^2 + x^2 + y^2 - 1/6*(x^4+2*x^2*y^2+y^4) + 1/120*(x^6+y^6) + 4

];

# s1 includes xvars + zvars
s2 = [  - 4*(x - y)^4 - (x + y)^2 - w^2 + 133.097, 
        100*(x + y)^2 - w^2*(x - y)^4 - 3000
     ];    

# degree of interpolation template
deg = 6