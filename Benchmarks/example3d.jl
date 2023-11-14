@polyvar x y z a1 b1 c1 d1 a2 b2 c2 d2
# do NOT use x0 as a variable, x0 is used as the homogenization variable
xvars = [x, y, z]
yvars = [a1, b1, c1, d1]
zvars = [a2, b2, c2, d2]

# s1 includes xvars + yvars
# >= 0 
s1 = [ 4 - x^2 - y^2 - z^2 - a1^2 - b1^2 - c1^2 - d1^2,
       -y^4 + 2*x^4 - a1^4 - 0.01,
       z^2 - b1^2 - c1^2 - d1^2 - x - 1
     ];

# s1 includes xvars + zvars
s2 = [ 4 - x^2 - y^2 - z^2 - a2^2 - b2^2 - c2^2 - d2^2,
       x^2 - y - a2 - b2 - d2^2 - 3,
       x
     ];    

# degree of interpolation template
deg = 2