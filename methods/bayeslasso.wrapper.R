bayeslasso.wrapper = function(input, args){

  # load dataset
  data.name = input$data.name
  data.path = paste0('datamakers/', data.name, '/')
  
  ## genotype data 
  genotype.path = paste0(data.path, 'genotype.RData')
  load(genotype.path)
  
  ## phenotype data
  phenotype.path = paste0(data.path, 'phenotype_', input$phenotype.id, '.RData')
  load(phenotype.path)
  
  ## relatedness data
  if (length(intersect(list.files(), 'relatedness.RData'))==0){
    z = NULL
  } else {
    relatedness.path = paste0(data.path, 'relatedness.RData')
    load(relatedness.path)
  }

  # specify the genotype matrix, phenotype vector and relatedness matrix
  observedID = names(y)
  Y = y
  X = x[rownames(x) %in% observedID, ]
  A = z[rownames(x) %in% observedID, rownames(x) %in% observedID]
  if (prod(names(Y) == names(X)) == 0)
    stop("individuals are not the same in genotype and phenotype")

  # defaul prior (tuned for wheat data)
  # url: https://dl.sciencesocieties.org/publications/tpg/articles/3/2/106
  priorBL = list(varE=list(df=3,S=2.5),
                 varU=list(df=3,S=0.63),
                 lambda=list(shape=0.52,rate=1e-4,value=30,type='random'))
  
  # default number of iterations, burn-in and thinning (for wheat data)
  nIter = 1e3
  burnIn = 1e2
  #nIter  = 6e4
  #burnIn = 1e4
  thin   = 10

  # user-specified setting for blr routine
  if(!is.null(args$nIter)) nIter = args$nIter
  if(!is.null(args$burnIn)) burnIn = args$burnIn
  if(!is.null(args$thin)) thin = args$thin
  if(length(args$priorBL) != 0) priorBL = args$priorBL
  
  # create a test set: rmv the observed phenotype
  whichNA = input$test.subject
  YNA = Y
  YNA[whichNA] = NA

  # run gibbs sampler to fit bayes lasso model
  library(BLR)
  if (is.null(A)){
    fm=BLR(y=YNA, XL=X, GF=NULL, prior=priorBL, nIter=nIter, burnIn=burnIn, thin=thin, saveAt="result_")
  } else {
    fm=BLR(y=YNA, XL=X, GF=list(ID=(1:nrow(A)),A=A), prior=priorBL, nIter=nIter, burnIn=burnIn, thin=thin, saveAt="result_")
  }
  
  system('rm result_lambda.dat result_varE.dat')

  # output the posterior mean as predicted value
  y.test.predict = fm$yHat[whichNA]
  return(list(predict=y.test.predict)) 

}
