using Pkg
Pkg.activate(".")

using JuMP
using MosekTools
using DynamicPolynomials
using TSSOS
using LinearAlgebra


ϵ = 10^(-5) # ignore small coefficients within [-ϵ,ϵ]
@polyvar x0 # homogenization variable
@polyvar w  # introduced for semialgebraic interpolants


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
    # synthesize Craig interpolation using CAV20 method
    # deg: degree of interpolation template, h(x,y)
    
    model = Model(optimizer_with_attributes(Mosek.Optimizer))
    set_optimizer_attribute(model, MOI.Silent(), true)
    
    h,hc,hb = add_poly!(model, xvars, deg)
    
    if length(yvars)==0
        phivars = xvars
    else
        phivars = [xvars; yvars]
    end
    if length(zvars)==0
        psivars = xvars
    else
        psivars = [xvars; zvars]
    end

    for i = 1:length(s1)
        model,info1 = add_psatz!(model, h-1,  phivars, s1[i], [],  d_relax, QUIET=true, CS=false, TS=false, Groebnerbasis=true)
    end
    
    for i = 1:length(s2)
        model,info2 = add_psatz!(model, -h-1, psivars, s2[i], [],  d_relax, QUIET=true, CS=false, TS=false,  Groebnerbasis=true)
    end
    for i in hc
        @constraint(model, -1<=i<=1)
    end

    optimize!(model)
    status = termination_status(model)
    if status != MOI.OPTIMAL
        println("termination status: $status")
        status = primal_status(model)
        println("solution status: $status")
    end
    hc = value.(hc)
    hc = scale_list(hc)   
    for i in 1:length(hc)
        if hc[i] <= ϵ && hc[i] >= -ϵ
            hc[i] = 0
        end
    end
    return hc'*hb
end

function interpolation_homo(deg)
    # synthesize polynomial Craig interpolation using the homogenization formulation
    # deg: degree of interpolation template, h(x,y)

    model = Model(optimizer_with_attributes(Mosek.Optimizer))
    set_optimizer_attribute(model, MOI.Silent(), true)
    
    h,hc,hb = add_poly!(model, xvars, deg)
        
    if length(yvars)==0
        phivars = xvars
    else
        phivars = [xvars; yvars]
    end

    if length(zvars)==0
        psivars = xvars
    else
        psivars = [xvars; zvars]
    end

    for i = 1:length(s1)
        model,info = add_psatz!(model, homogenize(h, x0),  [x0; phivars], [homogenize.(s1[i], x0); x0], [1-sum([x0;phivars].^2)], d_relax, QUIET=true, CS=false, TS=false, Groebnerbasis=true)
    end    
    for i = 1:length(s2)
        model,info = add_psatz!(model, homogenize(-h, x0), [x0; psivars], [homogenize.(s2[i], x0); x0], [1-sum([x0;psivars].^2)], d_relax, QUIET=true, CS=false, TS=false, Groebnerbasis=true)
    end
    for i in hc
        @constraint(model, -1<=i<=1)
    end

    optimize!(model)
    status = termination_status(model)
    if status != MOI.OPTIMAL
        println("termination status: $status")
        status = primal_status(model)
        println("solution status: $status")
    end
    hc = value.(hc)  
    hc = scale_list(hc)    
    for i in 1:length(hc)
        if hc[i] <= ϵ && hc[i] >= -ϵ
            hc[i] = 0
        end
    end
    return hc'*hb
end

function interpolation_semi(deg)
    # synthesize semialgebraic interpolant 
    
    model = Model(optimizer_with_attributes(Mosek.Optimizer))
    set_optimizer_attribute(model, MOI.Silent(), true)
    
    h1,hc1,hb1 = add_poly!(model, xvars, deg)
    h2,hc2,hb2 = add_poly!(model, xvars, deg)
    
    if length(yvars)==0
        phivars = xvars
    else
        phivars = [xvars; yvars]
    end

    if length(zvars)==0
        psivars = xvars
    else
        psivars = [xvars; zvars]
    end
    
    for i = 1:length(s1)
        model,info = add_psatz!(model, homogenize(h1+w*h2, x0),  [x0; w; phivars], [homogenize.(s1[i], x0); x0; w], [1-sum([x0;phivars].^2)-w^2; sum([x0;xvars].^2)-w^2], d_relax, QUIET=true, CS=false, TS=false, Groebnerbasis=true)
    end    
    for i = 1:length(s2)
        model,info = add_psatz!(model, homogenize(-h1-w*h2, x0), [x0; w; psivars], [homogenize.(s2[i], x0); x0; w], [1-sum([x0;psivars].^2)-w^2; sum([x0;xvars].^2)-w^2], d_relax, QUIET=true, CS=false, TS=false, Groebnerbasis=true)
    end
    
    for i in hc1
        @constraint(model, -1<=i<=1)
    end
    for i in hc2
        @constraint(model, -1<=i<=1)
    end

    optimize!(model)
    status = termination_status(model)
    if status != MOI.OPTIMAL
        println("termination status: $status")
        status = primal_status(model)
        println("solution status: $status")
    end
    hc1 = value.(hc1)      
    hc2 = value.(hc2)
    h_val = hc1'*hb1 + w*hc2'*hb2
    coef_list = coefficients(h_val)
    coef_list = scale_list(coef_list)
    for i in 1:length(coef_list)
        if coef_list[i] <= ϵ && coef_list[i] >= -ϵ
            coef_list[i] = 0
        end
    end
    h_val = dot(coef_list, monomials(h_val))
    return h_val
end

# compute interpolation using three methods
function run_tssos(name, method1, method2, method3)
    # to print results Mathematica can read
    include("./Benchmarks/"*name*".jl");
    println("======", name, "======");
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
        stats = @timed h = interpolation(deg)
        println("using CAV20 technique:")
        @show h
        write(file, Base.replace(string(h),"e"=>"*10^")*"\n")
        write(file, string(stats.time)*"\n") 
        close(file)
    end

    if method2
        # print homogenization approach results
        file = open("./Results/homo/"*name*".txt", "w");
        stats = @timed h = interpolation_homo(deg)
        println("Polynomial Interpolant:");
        @show h
        write(file, Base.replace(string(h),"e"=>"*10^")*"\n")
        write(file, string(stats.time)*"\n") 
        close(file)
    end
    
    if method3
        # print semialgebraic approach results
        file = open("./Results/nonpoly/"*name*".txt", "w");
        stats = @timed h = interpolation_semi(deg)
        println("Semialgebraic Interpolant:")
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

# to run an example using all three methods
# run_tssos("ex2", putinar, homogenizatio, semialgebraic)

run_tssos("ex2", false, homogenization, false)
run_tssos("ex3", false, false, semialgebraic)
run_tssos("ex4", false, homogenization, semialgebraic)

