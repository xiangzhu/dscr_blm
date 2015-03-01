#define your methods in .R files like this one in the methods subdirectory
#each method should take arguments input and args, like the example
#the output should be a list of the appropriate "output" format (defined in the README)

bayeslasso.wrapper = function(input, args){

  # load in the dataset
  y = input$y
  X = input$X
  A = input$Z

  # defaul setting
  nIter = 5500
  burnIn = 500
  thin = 1
  priorBL = list(varE=list(df=3,S=2.5),
		 varU=list(df=3,S=0.63),
		 lambda = list(shape=0.52,rate=1e-5,value=20,type='random'))

  # user-specified setting
  if(!is.null(args$nIter))
	nIter = args$nIter
  if(!is.null(args$burnIn))
	burnIn = args$burnIn
  if(!is.null(args$thin))
	thin = args$thin
  if(length(priorBL) != 0)
	priorBL = args$priorBL

  # create a test set: rmv the observed phenotype
  whichNa = input$row.test
  yNa = y
  yNa[whichNa] = NA

  # run gibbs sampler to fit bayes lasso model
  fm=BLR(y=yNa, XL=X, GF=list(ID=(1:nrow(A)),A=A), prior=priorBL, nIter=nIter, burnIn=burnIn, thin=thin)

  # output the posterior mean as predicted value
  y.predict = fm$yHat[whichNa]
  y.true = y[whichNa]
  return(list(y.predict=y.predict, y.true=y.true)) 

}
