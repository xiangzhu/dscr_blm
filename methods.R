suppressPackageStartupMessages(library(BLR)) # for bayeslasso
suppressPackageStartupMessages(library(rrBLUP)) # for rrblup and rrblup.gkernel

source_dir("methods")

add_method(dsc_blm, name="bayes_lasso", fn=bayeslasso.wrapper, args=list(nIter=1.1e4,burnIn=1e3))
add_method(dsc_blm, name="gemma_bslmm", fn=gemma.bslmm.wrapper, args=list(w=1.1e4,s=1e3)) 
add_method(dsc_blm, name="rrblup", fn=rrblup.wrapper, args=list())
add_method(dsc_blm, name="rrblup_kernel", fn=rrblup.gkernel.wrapper, args=list()) 
