sourceDir("methods")
#now for each method define a list with its name, function and arguments (if no additional arguments use NULL)

addMethod(dsc_osl, name="bayes_lasso", fn=bayeslasso.wrapper, args=list(nIter=NULL, burnIn=NULL, thin=NULL, priorBL=list()))
addMethod(dsc_osl, name="varbvs_fixed", fn=varbvs.fixedhyper.wrapper, args=list(sigma=NULL, sa=NULL, logodds=NULL))
addMethod(dsc_osl, name="gemma_bslmm", fn=gemma.bslmm.wrapper, args=list(bslmm=NULL, w=NULL, s=NULL)) 
