# Nonlinear Craig Interpolant Synthesis
Synthesizing Craig Interpolants over unbounded domains. 

## Requirement
- Julia (version >= 1.9.2): to formulate SOS relaxations and transform them into SDPs
- Mosek solver: to solve  SDPs
- Mathematica (version >= 12): to verify interpolations and plot graphs.

Please following the steps to prepare the environment:
1. Clone this repository from github
   - run `git clone https://github.com/EcstasyH/Interpolation`
   - run `cd Interpolation` 
1. install julia from https://julialang.org/
3. install necessary julia packages
   - run `julia` to start an interactive session 
   - run `import Pkg`
   - run `Pkg.activate(".")` to install required packages
   - run `exit()` to quit the interactive session
4. install Mosek solver and apply for an academic license, see https://www.mosek.com/products/academic-licenses/
5. (optional, if you want to verify the results and plot the graphs) install Mathematica
   - Mathematica becomes inefficient when the problem instance involves too many variables and/or the degree is too large. 

## Run Benchmarks

Just `julia run.jl`  or use the corresponding juypter notebook file `run_TSSOS.ipynb`.

The implementation based on SumOfSquares package can be found in file `run_SOS.ipynb`, which gives similar results to all examples.

## Verify Results
The intermediate results are stored in `Results` directory. We use Mathematica to read these results and verify them. Please refer to the content of `Verify.nb` file. 