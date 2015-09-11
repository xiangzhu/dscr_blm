gblup.wrapper = function(input, args){
  
  # load dataset
  data.name = input$data.name
  data.path = paste0('datamakers/', data.name, '/')
  
  ## genotype data 
  genotype.path = paste0(data.path, 'genotype.RData')
  load(genotype.path)
  
  ## phenotype data
  phenotype.path = paste0(data.path, 'phenotype_', input$phenotype.id, '.RData')
  load(phenotype.path)
  
  # specify the genotype matrix, phenotype vector and relatedness matrix
  observedID = names(y)
  Y = y
  X = x[rownames(x) %in% observedID, ]
  if (prod(names(Y) == names(X)) == 0)
    stop("individuals are not the same in genotype and phenotype")
  
  # default number of iterations, burn-in and thinning (for wheat data)
  nIter = 6e4
  burnIn = 1e4
  thin   = 10
  
  # user-specified setting for blr routine
  if(!is.null(args$nIter)) nIter = args$nIter
  if(!is.null(args$burnIn)) burnIn = args$burnIn
  if(!is.null(args$thin)) thin = args$thin
  
  # create a test set: rmv the observed phenotype
  whichNA = input$test.subject
  YNA = Y
  YNA[whichNA] = NA
  
  # Compute marker-derived genomic relationship matrix
  X = scale(X, center=TRUE, scale=TRUE)
  G = tcrossprod(X)/ncol(X)
  
  # fit g-blup model
  ETA = list(list(K=G, model='RKHS'))
  fm=BGLR::BGLR(y=YNA, ETA=ETA, nIter=nIter, burnIn=burnIn, thin=thin, saveAt='result_')
  
  system('rm result_ETA_1_varU.dat result_varE.dat result_mu.dat')
  
  # output the posterior mean as predicted value
  y.test.predict = fm$yHat[whichNA]
  return(list(predict=y.test.predict)) 
  
}
