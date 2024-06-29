#  Craig Interpolant Generation over Unbounded Domains

This file describes the research artifact for the publication:

Nonlinear Craig Interpolant Generation over Unbounded Domains by Separating Semialgebraic Set

Hao Wu, Jie Wang, Bican Xia, Xiakun Li, Naijun Zhan, and Ting Gan

FM 2024

Paper 115

## Preparation

- Mosek solver (v10.2) for solving SDPs.
- Julia (v1.9.2) for formulating Sum-of-Squares relaxations and translating them into SDPs
- Mathematica (v12) or Wolfram Engine (v14.0) for posterior verification and plotting graphs.

(Skip this part if you are using the virtual machine image.) Follow the instructions to prepare the environment:
1. Install Mosek solver (https://www.mosek.com/downloads/) and apply for an academic license via (https://www.mosek.com/products/academic-licenses/)
2. Install Julia programming language (https://julialang.org/)
3. Clone this repository from github
   - run `git clone https://github.com/EcstasyH/Interpolation`
   - run `cd Interpolation` 
4. Install necessary julia packages
   - run `julia` to start an interactive session 
   - run `import Pkg`
   - run `Pkg.activate(".")` to activate the environment
   - run `Pkg.instantiate()` to download necessary dependencies
   - run `exit()` to quit the interactive session
5. Optional, if you want to verify the results and plot the graphs. Install Mathematica (commercial, https://www.wolfram.com/mathematica/) or Wolfram Engine (free but needs a developer licence, https://www.wolfram.com/engine/). 

## Virtual Machine

This artifact is distributed as a virtual machine (VM) in OVA format. The VM contains an installation of Ubuntu 22.04, along with the required software. The VM was created and tested using Oracle VirtualBox 7.0.18 running on a Windows 10 laptop with 16 GB of RAM and an intel i9-12900K CPU 2.50 GHz. During production the VM was allocated 4 GB of RAM and 1 processor through VirtualBox. The VM account is `vboxuser` and the password is `qwer12321`.

Open terminal and run `cd Interpolation`

Note: The VM image also contains the artifact our another paper ''On Completeness of SDP-Based Barrier Certificate Synthesis over Unbounded Domains.''

## Important Files

```
Interpolation/
- Benchmarks/      % all benchmarks written in Julia
- Results/         % SDP computation results
   - problem/      % benchmark information for Mathematica to read
   - sufficient/   % results using the method in [Gan et al. CAV 2020] 
   - homo/         % solving Program (22)
   - nonpoly/      % solving Program (23)
   - plots/        % plots using Mathematica
- run.jl           % solve Example 2,3,4 in the paper 
- verify.wls       % Molfram Engine script for verifying the results
- verify.nb        % Mathematica notebook file for verifcation
- clean.sh         % script for clean results
```

## Evaluation Instructions
The purpose of the artifact is to substantiate the numerical results and plots reported in Section 5. The experiment consists of two parts: (1) Compute the interpolants using Julia; (2) Verify the numerical results using Mathematica/Wolfram Engine (to avoid numerical errors in SDP solving).   

- To compute interpolants for three examples, run `julia run.jl`. The numerical results will be stored within `Results` folder.
- To verify results in the first step, run `wolframscript verify.wls`. The wolframe engine reads the results in `Results/` directory and employs symbolic methods to verify them. 

## Claims
The experimental results may have a numerical error/disturbance of 10^-5 compared to the data in the paper.   

If you have any questions, please feel free to contact me (wuhao@ios.ac.cn).