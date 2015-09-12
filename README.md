# dscr\_blm
a repository for a dynamic statistical comparison of Bayesian linear model fitting procedures and their applications in genetic association studies

## How to use this to set up a new DSC

1. Copy this repo. For example, suppose you want to call your repo `dscr_blm` and host it on github. You could do the following:
    * create a new repo named `dscr_blm` on your github account.
    * clone this repo to your locaal computer, under the directory `dscr_blm` say, using `git clone https://github.com/stephens999/dscr-template.git dscr_blm`
    * set up your local repo to push to your github repo: `cd dscr_blm` `git remote rm origin` `git remote add origin https://github.com/yourgithubid/dscr_blm.git`
    * Push to your github repo using `git push -u origin master`
2. Put at least one datamaker function in a `.R` file in the `datamakers` directory (all `.R` files in this directory will be sourced before `scenarios.R`). See the file `datamakers/eg_datamaker.R` for example.
3. Put at least one method function in a `.R` file in the `methods` directory (all `.R` files in this directory will be sourced before methods.R). See the file `methods/eg_method.R`
4. Edit the file `scenarios.R` to define your scenarios 
5. Edit the file `methods.R` to define your methods
6. Edit the file `score.R` to define your scoring function
7. Replace the text in this `README.md` file with a description of the DSC. Include background, and definitions of the structure of the objects `meta`, `input`, and `output` that is used by your DSC. A template for these instructions is included below.
8. Run your DSC by running `source("run_dsc.R")` in R. [Make sure you have installed the `dscr` package first from https://github.com/stephens999/dscr]


