using JuMP
using MosekTools
using DynamicPolynomials
using MultivariatePolynomials
using TSSOS

ϵ = 10^(-5)
d_relax = 5 

@polyvar x0

cd("D:/project/Interpolation-main/")

run_tssos("ex2")

function interpolation(deg)
    # synthesize Craig interpolation using the standard Putinar theorem
    # deg: degree of interpolation template, h(x,y)
    
    model = Model(optimizer_with_attributes(Mosek.Optimizer))
    set_optimizer_attribute(model, MOI.Silent(), true)
    
    h,hc,hb = add_poly!(model, xvars, deg)
    
    # just avoid bugs when yvars is empty
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

    # homogenization
    for i = 1:length(s1)
        model,info1 = add_psatz!(model, h-1,  [phivars; x0], [x0; s1[i]], [1-sum([x0;phivars].^2)], d_relax, QUIET=true, CS=false, TS=false)
    end
    
    for i = 1:length(s2)
        model,info2 = add_psatz!(model, -h-1, [psivars; x0], [x0; s2[i]], [1-sum([x0;psivars].^2)], d_relax, QUIET=true, CS=false, TS=false)
    end
    for i in hc
        @constraint(model, -1<=i<=1)
    end
    # @constraint(model, sum(hc)==1)

    optimize!(model)
    status = termination_status(model)
    if status != MOI.OPTIMAL
        println("termination status: $status")
        status = primal_status(model)
        println("solution status: $status")
    end
    hc = value.(hc)
    for i in 1:length(hc)
        if hc[i] <= ϵ && hc[i] >= -ϵ
            hc[i] = 0
        end
    end
    return hc'*hb
end

function interpolation_homo(deg)
    # synthesize Craig interpolation using the homogenization formulation
    # deg: degree of interpolation template, h(x,y)

    model = Model(optimizer_with_attributes(Mosek.Optimizer))
    set_optimizer_attribute(model, MOI.Silent(), false)
    
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
    # @constraint(model, sum(hc)==1)

    optimize!(model)
    status = termination_status(model)
    if status != MOI.OPTIMAL
        println("termination status: $status")
        status = primal_status(model)
        println("solution status: $status")
    end
    hc = value.(hc)      
    for i in 1:length(hc)
        if hc[i] <= ϵ && hc[i] >= -ϵ
            hc[i] = 0
        end
    end
    return hc'*hb
end

function run_tssos(name)

    # print results based on the method in CAV20
    # file = open("./Results/sufficient/"*name*".txt", "w");
    # stats = @timed h = interpolation(deg)
    # println("using CAV20 technique:",stats.time)
    # @show h
    # write(file, Base.replace(string(h),"e"=>"*10^")*"\n")
    # write(file, string(stats.time)*"\n") 
    # close(file)

    # print homogenization approach results
    file = open("./Results/homo/"*name*".txt", "w");
    stats = @timed h = interpolation_homo(deg)
    println("using homogenization technique:",stats.time)
    @show h
    write(file, Base.replace(string(h),"e"=>"*10^")*"\n")
    write(file, string(stats.time)*"\n") 
    close(file)
end