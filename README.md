# CAV24
Synthesizing Craig Interpolations over non-compact regions via homogenization. 

## Requirement
- Julia (version >= 1.9.2): to formulate SOS relaxations and transform them into SDPs
- Mosek solver: to solve  SDPs
- Mathematica (version >= 12): to verify interpolations and plot graphs.

Please following the steps to prepare the environment:
1. install julia from https://julialang.org/
2. Clone this repository from github
   - run `git clone https://github.com/EcstasyH/Interpolation`
   - run `cd Interpolation` 
3. install necessary julia packages
   - run `julia` to start an interactive session 
   - run `import Pkg`
   - run `Pkg.activate(".")` to install required packages
   - run `exit()` to quit the interactive session
4. install Mosek solver and apply for an academic license, see https://www.mosek.com/products/academic-licenses/
5. (optional, if you want to verify the results and plot the graphs) install Mathematica
   - Mathematica becomes inefficient when the problem instance involves too many variables and/or the degree is too large. 

## Run Benchmarks

Benchmark files are stored in the `Benchmarks` directory. For example, if you want to run the two-dimensional benchmark `example2d.jl`, edit the content of `run.jl` file to `name = "example2d"` on line 155. Then, run `julia run.jl`.

Due to the precompiling mechanism of Julia, running `julia run.jl` for each instance is very inefficient. Hence, I suggest using Jupyter Notebook to work with the `run_all.ipynb` file. 

## Verify Results
The results for benchmarks all stored in `Results` directory. We use Mathematica to read these results and verify them. Please refer to the content of `Verify.nb` file. 