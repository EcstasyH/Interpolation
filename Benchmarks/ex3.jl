# sec 5: example 4

@polyvar x y  
# do NOT use x0 as a variable, x0 is used as the homogenization variable
xvars = [x, y]
yvars = [ ]

zvars = []

f1 = 2*2^2*x*y-(x^2-y^3)^2 

h1 = x^2+y^2-1

g1 = -2*2.5^2*x*y-(x^2+y^2)^2 

# >= 0 
s1 = [ 
        [f1, h1]
];

# s1 includes xvars + zvars
s2 = [  
        [g1, h1]
     ];    

# degree of interpolation template
deg = 3

# for tssos
d_relax = 2
