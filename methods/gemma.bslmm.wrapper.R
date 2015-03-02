#define your methods in .R files like this one in the methods subdirectory
#each method should take arguments input and args, like the example
#the output should be a list of the appropriate "output" format (defined in the README)

gemma.bslmm.wrapper = function(input, args){
  
  # load in the dataset
  X = input$X
  y = input$y
  
  # create a test dataset
  whichNa = input$row.test
  yNa = y
  yNa[whichNa] = NA

  # defaul setting for bslmm (see manual for gemma)
  bslmm = 1
    
  # specify the flags for bslmm
  if(!is.null(args$bslmm))
	bslmm = args$bslmm

  # fit the model by gemma (binary exe)
  
  # step 1: write (Xtrn, ytrn) to txt files and save them in a format as gemma required
  write.table(X, file="genotype.txt")
  write.table(yNa, file="phenotype.txt", row.names=FALSE, col.names=FALSE)
  
  # step 2: make a system command to fit bslmm model in gemma
  
  model_fitting_command = "./gemma -g genotype.txt -p phenotype.txt -o result -epm result.param.txt -emu result.log.txt -predict 1"
  # choose the model type
  model_fitting_command = paste(model_fitting_command, "-bslmm", bslmm)
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
  
  effectsam = alphasam + betasam * gammasam # total effect size estimate in gemma-bslmm
  
  # output the phenotype prediction function
  beta.bslmm <- mean(effectsam); 
  predict <- function(Xnew){
    linear.predict.wrapper(Xnew, beta.bslmm)
  }
  
  return(list(predict=predict))
  
}
