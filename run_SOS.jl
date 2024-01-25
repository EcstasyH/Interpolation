# compute interpolation using three methods

# run for the first time
# using Pkg
# Pkg.activate(".")

using SumOfSquares
using DynamicPolynomials
using MosekTools
using LinearAlgebra

# Parameters 
ϵ = 10^(-5) # if a coefficient is in [-ϵ, ϵ], set it to zero
relax = 2 # relaxation order = degree of template + relax

# x0 is the homogeneous variable, 
# w represents sqrt{\|x\|^2+1} 
@polyvar x0 w

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

function scale_list(list)
    # scale a list of floats so that the largest absolute value is 1
    a = abs(minimum(list))
    b = abs(maximum(list))
    if a <= b
        list = list/b
    else
        list = list/a
    end
end

function interpolation(deg)
    # synthesize Craig interpolation using the standard Putinar theorem
    # deg: degree of interpolation template, h(x,y)
    
    s1region = get_region.(s1)
    s2region = get_region.(s2)
    
    model = SOSModel(solver)
    monos = monomials(xvars, 0:deg)
    
    @variable(model, h, Poly(monos))
    
    for i = 1:length(s1region)
        @constraint(model, h - 1 >= 0, domain = s1region[i], maxdegree =  maxdegree(h)+relax)
    end
    for i = 1:length(s2region)
        @constraint(model, - h - 1 >= 0, domain = s2region[i], maxdegree =  maxdegree(h)+relax)
    end
    for i in coefficients(h)
        @constraint(model, -1<=i<=1)
    end

    JuMP.optimize!(model)
    if (JuMP.has_values(model))
        h_val = SumOfSquares.value(h)
        coef_list = coefficients(h_val)
        # ignore terms with small coefficients <= 0.1^5
        for i in 1:length(coef_list)
            if coef_list[i] <= ϵ && coef_list[i] >= -ϵ
                coef_list[i] = 0
            end
        end
        h_val = dot(coef_list, monomials(h_val))
        return h_val
    else
        return -1
    end
end

function interpolation_homo(deg)
    # synthesize Craig interpolation using the homogenization formulation
    # deg: degree of interpolation template, h(x,y)
    
    θ = x0^2 + dot(xvars, xvars)

    # to avoid some bugs when yvars is empty
    if length(yvars) == 0
        θy = θ
    else   
        θy = θ + dot(yvars, yvars)
    end

    if length(zvars) == 0
        θz = θ
    else   
        θz = θ + dot(zvars, zvars)
    end

    s1region_homo = get_region_homo.(s1, θy)
    s2region_homo = get_region_homo.(s2, θz)    

    model = SOSModel(solver)
    monos = monomials(xvars, 0:deg)
        
    @variable(model, h, Poly(monos))
    
    for i = 1:length(s1region_homo)
        @constraint(model, homo(h) >= 0 , domain = s1region_homo[i], maxdegree = maxdegree(h)+relax)
    end    
    for i = 1:length(s2region_homo)
        @constraint(model, homo(-h) >= 0 , domain = s2region_homo[i], maxdegree =  maxdegree(h)+relax)
    end
    for i in coefficients(h)
        @constraint(model, -1<=i<=1)
    end

    JuMP.optimize!(model)
    if (JuMP.has_values(model))
        h_val = SumOfSquares.value(h)
        coef_list = coefficients(h_val)
        coef_list = scale_list(coef_list) 
        # ignore terms with small coefficients <= 0.1^5 
        for i in 1:length(coef_list)
            if coef_list[i] <= ϵ && coef_list[i] >= -ϵ
                coef_list[i] = 0
            end
        end
        h_val = dot(coef_list, monomials(h_val))
        return h_val
    else 
        return -1
    end
end

function interpolation_semi(deg)
    # synthesize semialgebraic interpolant
    # deg: degree of interpolation template, h1(x) h2(x)
    
    θ = x0^2 + dot(xvars, xvars)
    if length(yvars) == 0
        θy = θ
    else   
        θy = θ + dot(yvars, yvars)
    end

    if length(zvars) == 0
        θz = θ
    else   
        θz = θ + dot(zvars, zvars)
    end

    s1region_homo = get_region_homo.(s1, θy+w^2)
    s2region_homo = get_region_homo.(s2, θz+w^2)    

    model = SOSModel(solver)
    monos = monomials(xvars, 0:deg)

    @variable(model, h1, Poly(monos))
    @variable(model, h2, Poly(monos))    
    
    for i = 1:length(s1region_homo)
        @constraint(model, homo(h1+w*h2) >= 0 , domain = intersect(s1region_homo[i], @set(w>=0), @set(θ-w^2==0)), maxdegree = maxdegree(h)+relax)
    end    
    for i = 1:length(s2region_homo)
        @constraint(model, homo(-h1-w*h2) >= 0 , domain = intersect(s2region_homo[i], @set(w>=0), @set(θ-w^2==0)), maxdegree =  maxdegree(h)+relax)
    end
    for i in coefficients(h1)
        @constraint(model, -1<=i<=1)
    end
    for i in coefficients(h2)
        @constraint(model, -1<=i<=1)
    end
    JuMP.optimize!(model)
    if (JuMP.has_values(model))
        # println("A feasible solution is found! Optimal Value: ",SumOfSquares.value(γ))
        h1_val = SumOfSquares.value(h1)
        h2_val = SumOfSquares.value(h2)
        h_val = h1_val + w * h2_val
        coef_list = coefficients(h_val)
        coef_list = scale_list(coef_list)
        # ignore terms with small coefficients <= 0.1^5 
        for i in 1:length(coef_list)
            if coef_list[i] <= ϵ && coef_list[i] >= -ϵ
                coef_list[i] = 0
            end
        end
        h_val = dot(coef_list, monomials(h_val))
        return h_val
    else 
        return -1
    end
end

function run(name, method1, method2, method3)
    include("./Benchmarks/"*name*".jl");

    # print problem instance (so that Mathematica can read)
    file = open("./Results/problem/"*name*".txt", "w");
    write(file, "{")
    for i = 1:length(xvars) 
        if i<=length(xvars)-1
            write(file, string(xvars[i])*",")
        else
            write(file, string(xvars[i]))
        end
    end
    write(file, "}\n")
    write(file, "{")
    for i = 1:length(yvars) 
        if i<=length(yvars)-1
            write(file, string(yvars[i])*",")
        else
            write(file, string(yvars[i]))
        end
    end
    write(file, "}\n")
    write(file, "{")
    for i = 1:length(zvars) 
        if i<=length(zvars)-1
            write(file, string(zvars[i])*",")
        else
            write(file, string(zvars[i]))
        end
    end
    write(file, "}\n")
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

    if method1 
        # print results based on the method in CAV20
        file = open("./Results/sufficient/"*name*".txt", "w");
        stats = @timed h = interpolation(deg,num_tech)
        println("using CAV20 technique:")
        @show h
        write(file, Base.replace(string(h),"e"=>"*10^")*"\n")
        write(file, string(stats.time)*"\n") 
        close(file)
    end

    if method2
        # print homogenization approach results
        file = open("./Results/homo/"*name*".txt", "w");
        stats = @timed h = interpolation_homo(deg,num_tech)
        println("using homogenization technique:");
        @show h
        write(file, Base.replace(string(h),"e"=>"*10^")*"\n")
        write(file, string(stats.time)*"\n") 
        close(file)
    end
    
    if method3
        # print semialgebraic approach results
        file = open("./Results/nonpoly/"*name*".txt", "w");
        stats = @timed h = interpolation_nonpoly(deg,num_tech)
        println("using nonpoly technique:")
        @show h
        write(file, Base.replace(string(h),"e"=>"*10^")*"\n")
        write(file, string(stats.time)*"\n") 
        close(file)
    end
end

# methods
putinar = true
homogenization = true
semialgebraic = true

run("ex4", putinar, homogenization, semialgebraic)