#define your methods in .R files like this one in the methods subdirectory
#each method should take arguments input and args, like the example
#the output should be a list of the appropriate "output" format (defined in the README)

varbvs.fixedhyper.wrapper = function(input,args){

  # locate the dataset
  data.name = input$data.name
  data.path = paste0('../datamakers/', data.name, '/')

  # load in the dataset
  genotype.path = paste0(data.path, 'genotype.RData')
  load(genotype.path)

  phenotype.path = paste0(data.path, 'phenotype_', input$phenotype.id, '.RData')
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
  if (prod(names(Y) == rownames(X)) == 0)
        stop("individuals are not the same in genotype and phenotype")

  which.test = input$test.subject
  which.train = setdiff(1:length(Y), which.test)
  
  y.test = Y[which.test]
  y.train = Y[which.train]

  X.test = X[which.test, ]
  X.train = X[which.train, ]
  
  # fix the hyper parameters
  if(!is.null(args$sigma)){
  	sigma = args$sigma
  }else{
	sigma = 4 # the variance of the residual 
  } 
  if(!is.null(args$sa)){
  	sa = args$sa
  }else{ 			
  	sa = 1/4 # sa*sigma is the prior variance of the regression coefficients
  }
  if(!is.null(args$logodds)){
  	logodds = args$logodds
  }else{ 	
  	logodds = log(0.01/0.99) # prior log-odds of inclusion for each variable
  }
  # fit the model by variational inference
  library(varbvs)
  result <- varbvsoptimize(X.train, y.train, sigma, sa, logodds)

  # output the phenotype prediction for the test set
  beta.var <- result$alpha * result$mu;
  y.test.predict = X.test %*% beta;

  return(list(predict=y.test.predict))
}
