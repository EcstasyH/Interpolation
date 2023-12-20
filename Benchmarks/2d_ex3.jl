
@polyvar x y z1 z2
# do NOT use x0 as a variable, x0 is used as the homogenization variable
xvars = [x, y]
yvars = [z1]
zvars = [z2]

epsilon = 0.1
k = 2
t = 3

# s1 includes xvars + yvars
# >= 0 
s1 = [ 
        [y^(2*k)-(1+epsilon)^2*x^(2*k)-1]
        # # ,
        # [(y-3*(1+epsilon))^2-(1+epsilon)^2*(x-3)^2],
        # [(y+3*(1+epsilon))^2-(1+epsilon)^2*(x+3)^2]
];

# s1 includes xvars + zvars
s2 = [  
        [-1-y^(2*t)+(1-epsilon)^2*x^(2*t)]
        # ,
        # [(1-epsilon)^2*(x-3)^2-(y-3*(1-epsilon))^2],
        # [(1-epsilon)^2*(x+3)^2-(y+3*(1-epsilon))^2]
     ];    

# degree of interpolation template
deg = 6


