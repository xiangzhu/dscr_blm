#define your methods in .R files like this one in the methods subdirectory
#each method should take arguments input and args, like the example
#the output should be a list of the appropriate "output" format (defined in the README)

linear.predict.wrapper = function(X, beta){
  y.predict = X %*% beta
  return(y.predict)
}

gemma.bslmm.wrapper = function(input, args){
  
  Xtrn = input$X.train
  ytrn = input$y.train
  
  # specify the flags for bslmm
  model_type = args$model_type
  sample_step = args$sample_step
  burnin_step = args$burnin_step
  
  # fit the model by gemma (binary exe)
  
  # step 1: write (Xtrn, ytrn) to txt files and save them in a format as gemma required
  write.table(Xtrn, file="genotype.txt")
  write.table(ytrn, file="phenotype.txt")
  
  # step 2: make a system command to fit bslmm model in gemma
  
  model_fitting_command = "./gemma -g genotype.txt -p phenotype.txt -o result"
  # choose the model to fit
  model_fitting_command = paste(model_fitting_command, "-bslmm", model_type)
  # choose the length of sampling and burn-in
  model_fitting_command = paste(model_fitting_command, "-s", sample_step, "-w", burnin_step)
  # run gemma to fit the model
  system(model_fitting_command)
  
  # step 3: extract the useful info and delete the files/directories
  hypsam = read.table('output/result.hyp.txt', header=TRUE)
  hsam = hypsam[, 1]
  pvesam = hypsam[, 2]
  rhosam = hypsam[, 3]
  pgesam = hypsam[, 4]
  pisam = hypsam[, 5]
  ngammasam = hypsam[, 6]
  
  parsam = read.table('output/result.param.txt', header=TRUE)
  alphasam = parsam[, 5]
  betasam = parsam[, 6]
  gammasam = parsam[, 7]
  
  effectsam = alphasam + betasam * gammasam # total effect size estimate in GEMMA-BSLMM
  
  # output the phenotype prediction function
  beta.bslmm <- mean(effectsam); 
  predict <- function(Xnew){
    linear.predict.wrapper(Xnew, beta.bslmm)
  }
  
  return(list(predict=predict))
  
}