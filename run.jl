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

function get_region(basic_sas)
    region = @set(basic_sas[1]>=0)
    for i = 2:length(basic_sas)
        region = intersect(region, @set(basic_sas[i]>=0))
    end
    return region
end

function get_region_homo(basic_sas, θvar)
    region = @set(homo(basic_sas[1])>=0)
    for i = 2:length(basic_sas)
        region = intersect(region, @set(homo(basic_sas[i])>=0))
    end
    region = intersect(region, @set(θvar==1),@set(x0>=0))
    return region
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


function interpolation(deg, num_tech)
    # synthesize Craig interpolation using the standard Putinar theorem
    # deg: degree of interpolation template, h(x,y)
    # num_tech: whether to use intermediate enhancement techniques (=1) or not (=0)

    # compute init and unsafe region
    s1region = get_region.(s1) # 这里再加上一个scale操作
    s2region = get_region.(s2)
    
    model = SOSModel(solver)
    monos = monomials(xvars, 0:deg)
    
    if num_tech == 1
        monos = ScaledMonomialBasis(monos)
    end
    
    # h(xvars) is the target interpolation
    @variable(model, h, Poly(monos))
    
    #@variable(model, γ)

    for i = 1:length(s1region)
        @constraint(model, h - 1 >= 0, domain = s1region[i], maxdegree =  maxdegree(h)+sostol)
    end
    
    for i = 1:length(s2region)
        @constraint(model, - h - 1 >= 0, domain = s2region[i], maxdegree =  maxdegree(h)+sostol)
    end
    
    # @constraint(model, sum(coefficients(h))<= 1)
    # @constraint(model, sum(coefficients(h))>= -1)
    # #@objective(model,Max,γ)
    
    JuMP.optimize!(model)
    if (JuMP.has_values(model))
        h_val = SumOfSquares.value(h)
        if num_tech==1
            coef_list = coefficients(h_val);
            for i in 1:length(coef_list)
                if coef_list[i] <= ϵ && coef_list[i] >= -ϵ
                    coef_list[i] = 0
                else #
                    coef_list[i] = round(coef_list[i],digits = 8)
                end
            end
            h_val = dot(coef_list, monomials(h_val))
        end
        return h_val
    else
        return -1
    end
end

function interpolation_homo(deg, num_tech)
    # synthesize Craig interpolation using the homogenization formulation
    # deg: degree of interpolation template, h(x,y)
    # num_tech: whether to use intermediate enhancement techniques (=1) or not (=0)

    θ = x0^2 + dot(xvars, xvars)
    θy = θ + dot(yvars, yvars)
    θz = θ + dot(zvars, zvars)
    
    
    s1region_homo = get_region_homo.(s1, θy)
    s2region_homo = get_region_homo.(s2, θz)    

    model = SOSModel(solver)
    monos = monomials(xvars, 0:deg)
    
    if num_tech == 1
        monos = ScaledMonomialBasis(monos)    
    end
        
    @variable(model, h, Poly(monos))
    
    for i = 1:length(s1region_homo)
        @constraint(model, homo(h) >= 0 , domain = s1region_homo[i], maxdegree = maxdegree(h)+sostol)
    end
    
    for i = 1:length(s2region_homo)
        @constraint(model, - homo(h) >= 0 , domain = s2region_homo[i], maxdegree =  maxdegree(h)+sostol)
    end

    # for i in coefficients(h)
    #     @constraint(model, i<=1)
    #     @constraint(model, i>=-1)
    # end

    @constraint(model, sum(coefficients(h))<= 1)
    @constraint(model, sum(coefficients(h))>= -1)

    # @constraint(model, sum(coefficients(h))<= -0.00001)
    # @constraint(model, sum(coefficients(h))>= -1)

    # no optimal target, maybe add one
    # @variable(model, γ)
    # @objective(model, Max, γ)
        
    JuMP.optimize!(model)
    if (JuMP.has_values(model))
        # println("A feasible solution is found! Optimal Value: ",SumOfSquares.value(γ))
        h_val = SumOfSquares.value(h)
        if num_tech == 1
            coef_list = coefficients(h_val);
            for i in 1:length(coef_list)
                if coef_list[i] <= ϵ && coef_list[i] >= -ϵ
                    coef_list[i] = 0
                else #
                    coef_list[i] = round(coef_list[i],digits = 8)
                end
            end
            h_val = dot(coef_list, monomials(h_val))
        end
        return h_val
    else 
        return -1
    end
end


# compute interpolation using two methods

num_tech = 1
# name = "bound2d"
name = "2d_ex7"

include("./Benchmarks/"*name*".jl");

# print problem instance (so that Mathematica can read)
file = open("./Results/problem/"*name*".txt", "w");
for k = [xvars, yvars, zvars]
    write(file, "{")
    for i = 1:length(k)-1
        write(file, string(k[i])*",")
    end
    write(file, string(last(k))*"}\n")
end
for k = [s1, s2]
    write(file, "{")
    for i = 1:length(k)
        write(file, "{")
        for j = 1:length(k[i])
            write(file, Base.replace(string(k[i][j]),"e"=>"*10^"))
            if j < length(k[i])
                write(file, ",") 
            end
        end
        write(file, "}")
        if i < length(k)
            write(file, ",")
        end
    end
    write(file, "}\n")
end
close(file)

# print results based on the method in CAV20
file = open("./Results/sufficient/"*name*".txt", "w");
stats = @timed h = interpolation(deg,num_tech)
println("using CAV20 technique:")
@show h
write(file, Base.replace(string(h),"e"=>"*10^")*"\n")
write(file, string(stats.time)*"\n") 
close(file)

# print homogenization approach results
file = open("./Results/homo/"*name*".txt", "w");
stats = @timed h = interpolation_homo(deg,num_tech)
println("using homogenization technique:")
@show h
write(file, Base.replace(string(h),"e"=>"*10^")*"\n")
write(file, string(stats.time)*"\n") 
close(file)
