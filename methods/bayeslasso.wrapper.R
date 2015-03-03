#define your methods in .R files like this one in the methods subdirectory
#each method should take arguments input and args, like the example
#the output should be a list of the appropriate "output" format (defined in the README)

bayeslasso.wrapper = function(input, args){

  # locate the dataset
  data.name = input$data.name
  data.path = paste0('/home/maimaizhu/GitHub/dscr_blm/datamakers/', data.name, '/')

  # load in the dataset
  genotype.path = paste0(data.path, 'genotype.RData')
  load(genotype.path)

  phenotype.path = paste0(data.path, 'phenotype_', input$phenotypeID, '.RData')
  load(phenotype.path)

  if (length(intersect(list.files(), 'relatedness.RData'))==0){
	z = NULL
  }else{
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

  # defaul setting for blr routine
  #nIter = 5500
  #burnIn = 500
  #thin = 1
  priorBL = list(varE=list(df=3,S=2.5),
		 varU=list(df=3,S=0.63),
		 lambda = list(shape=0.52,rate=1e-5,value=20,type='random'))

  # user-specified setting for blr routine
  if(!is.null(args$nIter))
	nIter = args$nIter
  if(!is.null(args$burnIn))
	burnIn = args$burnIn
  if(!is.null(args$thin))
	thin = args$thin
  if(length(args$priorBL) != 0)
	priorBL = args$priorBL

  # create a test set: rmv the observed phenotype
  whichNA = input$test.subject
  YNA = Y
  YNA[whichNA] = NA

  # run gibbs sampler to fit bayes lasso model
  library(BLR)
  if (is.null(A)){
  	fm=BLR(y=YNA, XL=X, GF=NULL, prior=priorBL, nIter=nIter, burnIn=burnIn, thin=thin)
  }else{
	fm=BLR(y=YNA, XL=X, GF=list(ID=(1:nrow(A)),A=A), prior=priorBL, nIter=nIter, burnIn=burnIn, thin=thin)
  }

  # output the posterior mean as predicted value
  y.predict = fm$yHat[whichNA]
  y.true = y[whichNA]
  return(list(y.predict=y.predict, y.true=y.true)) 

}
