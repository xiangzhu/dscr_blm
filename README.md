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

# Background 

For a recent review of genomic prediction (**without any simulation studies/data analysis**), see [here](http://www.sciencedirect.com/science/article/pii/S1360138514001411).

*Here provide general background on the problem that methods in this DSC are attempting to do.
Provide enough detail so that someone could work out whether their method might be appropriate to add to the DSC*.

# Input, meta and output formats

This DSC uses the following formats:

`input: list(data.name=string, phenotype.id=integer, test.subject=integer vector)` 

`meta: list(true.value=numeric vector)`

`output: list(predict=numeric vector)`


# Scores

Provide a summary of how methods are scored. For now, we use mean squared and absolute error between predicted and true values of phenotypes in test set.

See [score.R](score.R).

# To add a method

To add a method there are two steps.

- add a `.R` file containing an R function implenting that method to the `methods/` subdirectory
- add the method to the list of methods in the `methods.R` file.

Each method function must take arguments `(input,args)` where `input` is a list with the correct format (defined above), and `args` is a list containing any additional arguments the method requires.

Each method function must return `output`, where `output` is a list with the correct format (defined above).

# To add a scenario

To add a scenario there are two steps, the first of which can be skipped if you are using an existing datamaker function

- add a `.R` file containing an R function implenting a datamaker to the `datamakers/` subdirectory
- add the scenario to the list of scenarios in the `scenarios.R` file.

Each datamaker function must return a `list(meta,input)` where `meta` and `input` are each lists with the correct format
(defined above).

# Results

Here is a simple illustration. It just proves that my dsc problem works under the framework of `dscr` pacakge. It is still an ardous journey to make sure every method wrapper is correctly coded and properly tuned, every dataset is carefully cleaned, and every published result is (approximately) recovered.

Below are the mean squared and absolute error of two methods (Bayes Lasso and Bayes Sparse Linear Mixed Models) on two test samples (size=100).

```
method scenario mean_squared_error
1 bayes_lasso  wheat_1          0.7730888
2 gemma_bslmm  wheat_1          1.3352193
3 bayes_lasso  wheat_2          0.6940036
4 gemma_bslmm  wheat_2          1.1594067
5 bayes_lasso  wheat_3          1.0330434
6 gemma_bslmm  wheat_3          1.4141507
7 bayes_lasso  wheat_4          0.6934084
8 gemma_bslmm  wheat_4          1.0609606

```

```
method scenario mean_absolute_error
1 bayes_lasso  wheat_1           0.7170201
2 gemma_bslmm  wheat_1           0.9177054
3 bayes_lasso  wheat_2           0.6326330
4 gemma_bslmm  wheat_2           0.8287579
5 bayes_lasso  wheat_3           0.7626129
6 gemma_bslmm  wheat_3           0.9284478
7 bayes_lasso  wheat_4           0.6473019
8 gemma_bslmm  wheat_4           0.8192511

```
