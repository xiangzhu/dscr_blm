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
  hmin = 0
  hmax = 1
  rmin = 0
  rmax = 1
  pmin = log10(1/p)
  pmax = log10(1)
  smin = 0
  smax = 300
  gmean = 2000
  hscale = min(10/sqrt(n),1)
  rscale = min(10/sqrt(n),1)
  pscale = min(5/sqrt(n),1)
  w = 1e5
  s = 1e6
  rpace = 10
  wpace = 1e3
  seed = sample(1:1e5, 1) # randomly generate a seed
  mh = 10
  
  # specify the flags for bslmm
  
  # fit the model by gemma (binary exe)
  
  # step 1: write (Xtrn, ytrn) to txt files and save them in a format as gemma required
  write.table(X, file="genotype.txt")
  write.table(yNa, file="phenotype.txt", row.names=FALSE, col.names=FALSE)
  
  # step 2: make a system command to fit bslmm model in gemma
  
  model_fitting_command = "./gemma -g genotype.txt -p phenotype.txt -o result -epm result.param.txt -emu result.log.txt -predict 1"
  # choose the model type
  model_fitting_command = paste(model_fitting_command, "-bslmm", bslmm)
  # choose the min/max for h
  model_fitting_command = paste(model_fitting_command, "-hmin", hmin, "-hmax", hmax)
  # choose the min/max for rho
  model_fitting_command = paste(model_fitting_command, "-rmin", rmin, "-rmax", rmax)
  # choose the min/max for log10(pi)
  model_fitting_command = paste(model_fitting_command, "-pmin", pmin, "-pmax", pmax)
  # choose the min/max for |gamma|
  model_fitting_command = paste(model_fitting_command, "-smin", smin, "-smax", smax)
  # choose the mean for the geometric distribution
  model_fitting_command = paste(model_fitting_command, "-gmean", gmean)
  # choose the step size for the proposal of h
  model_fitting_command = paste(model_fitting_command, "-hscale", hscale)
  # choose the step size for the proposal of rho
  model_fitting_command = paste(model_fitting_command, "-rscale", rscale)
  # choose the step size for the proposal of log10(pi)
  model_fitting_command = paste(model_fitting_command, "-pscale", pscale)
  # choose the burn-in and sampling steps
  model_fitting_command = paste(model_fitting_command, "-w", w, "-s", s)
  # choose the recording and writting pace
  model_fitting_command = paste(model_fitting_command, "-rpace", rpace, "-wpace", wpace)
  # choose the random seed and number of MH steps in each iteration
  model_fitting_command = paste(model_fitting_command, "-seed", seed, "-mh", mh)
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
