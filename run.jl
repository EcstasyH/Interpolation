using Pkg
Pkg.activate(".")

using SumOfSquares
using DynamicPolynomials
using MosekTools
using LinearAlgebra

# Parameters 
ϵ = 10^(-5)
λ = -1
sostol = 2

@polyvar x0

# Using Mosek as the SDP solver
solver = optimizer_with_attributes(Mosek.Optimizer, MOI.Silent() => true)

function interpolation(deg, num_tech)
    # synthesize Craig interpolation using the standard Putinar theorem
    # deg: degree of interpolation template, h(x,y)
    # num_tech: whether to use intermediate enhancement techniques (=1) or not (=0)

    # compute init and unsafe region
    m1 = length(s1)
    m2 = length(s2)
    
    s1region = @set(s1[1]>=0)
    for i = 2:m1
        s1region = intersect(s1region, @set(s1[i]>=0))
    end
    s2region = @set(s2[1]>=0)
    for i = 2:m2
        s2region = intersect(s2region, @set(s2[i]>=0))
    end
        
    model = SOSModel(solver)
    monos = monomials(xvars, 0:deg)
    
    if num_tech == 1
        monos = ScaledMonomialBasis(monos)
    end
    
    # h(xvars) is the target interpolation
    @variable(model, h, Poly(monos))
    
    #@variable(model, γ)
    
    @constraint(model, h - 1 >= 0, domain = s1region, maxdegree =  maxdegree(h)+sostol)
    @constraint(model, - h - 1 >= 0, domain = s2region, maxdegree =  maxdegree(h)+sostol)
    
    #@objective(model,Max,γ)
    
    JuMP.optimize!(model)
    if (JuMP.has_values(model))
        h_val = SumOfSquares.value(h)
        if num_tech==1
            coef_list = coefficients(h_val);
            for i in 1:length(coef_list)
                if coef_list[i] <= ϵ && coef_list[i] >= -ϵ
                    coef_list[i] = 0
                end
            end
            h_val = dot(coef_list, monomials(h_val))
        end
        return h_val
    else
        return 0
    end
end

function homo(f)
    # homogenize f w.r.t. variable x_0
    
    f_homo = 0
    d = maxdegree(f)
    for t in terms(f)
        f_homo += t*x0^(d-degree(t))
    end
    return f_homo
end

function interpolation_homo(deg, num_tech)
    # synthesize Craig interpolation using the homogenization formulation
    # deg: degree of interpolation template, h(x,y)
    # num_tech: whether to use intermediate enhancement techniques (=1) or not (=0)

    m1 = length(s1)
    m2 = length(s2)
#     s1region = @set(s1[1]>=0)
#     for i = 2:m1
#         s1region = intersect(s1region, @set(s1[i]>=0))
#     end
#     s2region = @set(s2[1]>=0)
#     for i = 2:m2
#         s2region = intersect(s2region, @set(s2[i]>=0))
#     end
    
    s1region_homo = @set(homo(s1[1])>=0)
    for i = 2:m1
        s1region_homo = intersect(s1region_homo, @set(homo(s1[i])>=0))
    end
    
    s2region_homo = @set(homo(s2[1])>=0)
    for i = 2:m2
        s2region_homo = intersect(s2region_homo, @set(homo(s2[i])>=0))
    end
    
    θ = x0^2
    for i = 1:length(xvars)
        θ = θ + xvars[i]^2
    end

    s1region_homo = intersect(s1region_homo, @set(θ==1),@set(x0>=0));
    s2region_homo = intersect(s2region_homo, @set(θ==1),@set(x0>=0));

    model = SOSModel(solver)
    monos = monomials(xvars, 0:deg)
    
    if num_tech == 1
        monos = ScaledMonomialBasis(monos)    
    end
        
    @variable(model, h, Poly(monos))
   
    @constraint(model, homo(h) >= 0 , domain = s1region_homo, maxdegree = maxdegree(h)+sostol)
    @constraint(model, - homo(h) >= 0 , domain = s2region_homo, maxdegree =  maxdegree(h)+sostol)    
    
    # no optimal target, maybe add one
    # @variable(model, γ)
    # @objective(model, Max, γ)
        
    JuMP.optimize!(model)
    if (JuMP.has_values(model))
        #println("A feasible solution is found! Optimal Value: ",SumOfSquares.value(γ))
        h_val = SumOfSquares.value(h)
        if num_tech == 1
            coef_list = coefficients(h_val);
            for i in 1:length(coef_list)
                if coef_list[i] <= ϵ && coef_list[i] >= -ϵ
                    coef_list[i] = 0
                end
            end
            h_val = dot(coef_list, monomials(h_val))
        end
        return h_val
    else 
        return 0
    end
end

# compute interpolation using two methods

num_tech = 1
name = "example2d"

include("./Benchmarks/"*name*".jl");

# print problem instance (so that Mathematica can read)
file = open("./Results/problem/"*name*".txt", "w");
for k = [xvars, yvars, zvars, s1, s2]
    write(file, "{")
    for i = 1:length(k)-1
        write(file, string(k[i])*",")
    end
    write(file, string(last(k))*"}\n")
end
close(file)

# print results based on the method in CAV20
file = open("./Results/sufficient/"*name*".txt", "w");
stats = @timed h = interpolation(deg,num_tech)
println(h)
write(file, Base.replace(string(h),"e"=>"*10^")*"\n")
write(file, string(stats.time)*"\n") 
close(file)

# print homogenization approach results
file = open("./Results/homo/"*name*".txt", "w");
stats = @timed h = interpolation_homo(deg,num_tech)
println(h)
write(file, Base.replace(string(h),"e"=>"*10^")*"\n")
write(file, string(stats.time)*"\n") 
close(file)
