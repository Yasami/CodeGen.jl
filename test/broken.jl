# These don't work.

using Test
using CodeGen
using LLVM
using MicroLogging

configure_logging(min_level=:debug)


# Results in several problems below:  codegen of this works now
codegen(Base.throw_inexacterror, Tuple{Symbol, Type{Int}, Int})


function test_arrays(x)
    y = fill(2pi, 5)
    push!(y, 3x)
    z = reverse(y)
    zz = y .+ z.^2
    return maximum(zz)
end
codegen(test_arrays, Tuple{Float64})  
   


array_max2(x) = maximum([3,x])
codegen(array_max2, Tuple{Int})     # This passes & verifies
# @cgtest array_max2(1)               # Segfaults...
codegen(array_max2, Tuple{Float64}) # no method matching emit_box!(::CodeGen.CodeCtx, ::Type{Tuple{Int64,Float64}}, ::LLVM.LoadInst)  


function test_arrays(x)
    y = fill(2pi, 5)
    push!(y, 3x)
    z = reverse(y)
    zz = y .+ z.^2
    return maximum(zz)
end
codegen(test_arrays, Tuple{Float64})  
   

make_string(x) = string(1, x, "asdf")
codegen(make_string, Tuple{Int}) # same error as above


codegen(sin, Tuple{Float64})


function type_unstable(x)
    for i = 1:10
      x = x/2
    end
    return x
end
codegen(type_unstable, Tuple{Int})
# @jitrun(type_unstable, 1)   # segfaults



# Wishful thinking:)
using StaticArrays, OrdinaryDiffEq
function diffeq()
    A  = @SMatrix [ 1.0  0.0 0.0 -5.0
                    4.0 -2.0 4.0 -3.0
                   -4.0  0.0 0.0  1.0
                    5.0 -2.0 2.0  3.0]
    u0 = @SMatrix rand(4,2)
    tspan = (0.0,1.0)
    f(t,u) = A*u
    prob = ODEProblem(f,u0,tspan)
    solve(prob,Tsit5())
    return 1
end
codegen(diffeq)

