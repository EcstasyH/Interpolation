@polyvar vc y0 z0
# do NOT use x0 as a variable, x0 is used as the homogenization variable
xvars = [vc]
yvars = [y0]
zvars = [z0]

# s1 includes xvars + yvars
# >= 0 
s1 = [ 
        [vc*(40-vc)]
];

# s1 includes xvars + zvars
s2 = [  
        [vc-49.61],
     ];    

# degree of interpolation template
deg = 2