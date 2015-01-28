# dscr-template
a template repository for a dynamic statistical comparison

## An example

See https://github.com/stephens999/dscr-example for an example of a repo set up using this template 

## How to use this to set up a new DSC

1. Copy this repo. For example, suppose you want to call your repo `dscr-example` and host it on github. You could do the following:
    * create a new repo named `dscr-example` on your github account.
    * clone this repo to your locaal computer, under the directory `dscr-example` say, using `git clone https://github.com/stephens999/dscr-template.git dscr-example`
    * set up your local repo to push to your github repo: `cd dscr-example` `git remote rm origin` `git remote add origin https://github.com/yourgithubid/dscr-example.git`
    * Push to your github repo using `git push -u origin master`
2. Put at least one datamaker function in a `.R` file in the `datamakers` directory (all `.R` files in this directory will be sourced before `scenarios.R`). See the file `datamakers/eg_datamaker.R` for example.
3. Put at least one method function in a `.R` file in the `methods` directory (all `.R` files in this directory will be sourced before methods.R). See the file `methods/eg_method.R`
4. Edit the file `scenarios.R` to define your scenarios 
5. Edit the file `methods.R` to define your methods
6. Edit the file `score.R` to define your scoring function
7. Replace the text in this `README.md` file with a description of the DSC. Include background, and definitions of the structure of the objects `meta`, `input`, and `output` that is used by your DSC. A template for these instructions is included below.
8. Run your DSC by running `source("run_dsc.R")` in R. [Make sure you have installed the `dscr` package first from https://github.com/stephens999/dscr]


# Instructions Template

Edit this template to provide specific details on your own DSC.
I have included some instructions that might be generically applicable and useful for all DSCs (eg how to
add a method, how to add a scenario).

# Background 

For a general introduction to DSCs, see [here](https://github.com/stephens999/dscr/blob/master/intro.md).

Here provide general background on the problem that methods in this DSC are attempting to do.
Provide enough detail so that someone could work out whether their method might be appropriate to add to the DSC.

# Input, meta and output formats

This DSC uses the following formats:

`input: list(name [type])` # Add more explanation of each element here

`meta: list(name [type])` # Add more explanation of each element here

`output: list(name [type])` # Add more explanation of each element here


# Scores

Provide a summary of how methods are scored.

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




