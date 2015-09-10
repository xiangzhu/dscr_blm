# make data
source("datamakers/datamaker.R")
args = list(test.size=100, data.name="wheat", phenotype.id=1)
data = datamaker(args)

# run methods
input = data$input

## bayes lasso
source("methods/bayeslasso.wrapper.R")
res1 = bayeslasso.wrapper(input, args=list())

## gemma bslmm
source("methods/gemma.bslmm.wrapper.R")
res2 = gemma.bslmm.wrapper(input, args=list())

## rrblup
source("methods/rrblup.wrapper.R")
res3 = rrblup.wrapper(input, args=list())

## rrblup gaussian kernel
source("methods/rrblup.gkernel.wrapper.R")
res4 = rrblup.gkernel.wrapper(input, args=list())

# score methods
source("score.R")
scr1 = score(data, res1)
scr2 = score(data, res2)
scr3 = score(data, res3)
scr4 = score(data, res4)
