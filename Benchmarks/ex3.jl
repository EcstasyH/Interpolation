
# sec 5: example 3 

@polyvar x y a b c d
# do NOT use x0 as a variable, x0 is used as the homogenization variable
xvars = [x, y]
yvars = [a, b]
zvars = [c, d]

# s1 includes xvars + yvars
# >= 0 
s1 = [ 
        [x^6-2*y^4, x^4+4*y^2-32, y^3-a^2-(a+1)^2, x^3],
        [x^6-2*y^4, x^4+4*y^2-32, -y^3-b^2-(b+1)^2, -x^3]
];

# s1 includes xvars + zvars
s2 = [  
        [4-x^4-y^4],
        [0.25-(x+2.5+c)^2-(y-2.5-c)^2, 0.04-c^2],
        [0.25-(x-2.5-d)^2-(y+2.5+d)^2, 0.04-d^2]
     ];    

# degree of interpolation template
deg = 4

