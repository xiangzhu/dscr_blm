#define your methods in .R files like this one in the methods subdirectory
#each method should take arguments input and args, like the example
#the output should be a list of the appropriate "output" format (defined in the README)
library(varbvs)

linear.predict.wrapper = function(X, beta){
  y.predict = X %*% beta
  return(y.predict)
}

varbvs.fixedhyper.wrapper = function(input,args){
  
  Xtrn = input$X.train
  ytrn = input$y.train

  # fix the hyper parameters
  sigma = args$sigma # the variance of the residual
  sa = args$sa # sa*sigma is the prior variance of the regression coefficients
  logodds = args$logodds # prior log-odds of inclusion for each variable

  # fit the model by variational inference
  result <- varbvsoptimize(Xtrn, ytrn, sigma, sa, logodds)

  # output the phenotype prediction function
  beta.var <- result$mu
  predict <- function(Xnew){
    linear.predict.wrapper(Xnew, beta.var)
  }

  return(list(predict=predict))
}
