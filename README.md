# CAV24
Synthesizing Craig Interpolations over non-compact regions via homogenization. 

## Requirement
- Julia (version >= 1.9.2): to formulate SOS relaxations and transform them into SDPs
- Mosek solver: to solve  SDPs
- Mathematica (version >= 12): to verify interpolations and plot graphs.

Please following the steps to prepare the environment:
1. install julia from https://julialang.org/
2. Clone this repoistory from github
   - run `git clone https://github.com/EcstasyH/Interpolation`
   - run `cd Interpolation` 
3. install necessary julia packages
   - run `julia` to start an interactive session 
   - run `import Pkg`
   - run `Pkg.activate(".")` to install required packages
   - run `exit()` to quit the interactive session
4. apply for an academic license to use Mosek, see https://www.mosek.com/products/academic-licenses/
5. (optional, if you want to verify the results and plot the graphs) install Mathematica