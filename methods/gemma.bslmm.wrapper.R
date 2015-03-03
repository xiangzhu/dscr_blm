#define your methods in .R files like this one in the methods subdirectory
#each method should take arguments input and args, like the example
#the output should be a list of the appropriate "output" format (defined in the README)

gemma.bslmm.wrapper = function(input, args){

  # locate the dataset
  data.name = input$data.name
  data.path = paste0('/home/maimaizhu/GitHub/dscr_blm/datamakers/', data.name, '/')

  genotype.path = paste0(data.path, 'gemma_genotype_', input$phenotypeID, '.txt.gz')

  phenotype.path = paste0(data.path, 'phenotype_', input$phenotypeID, '.RData')
  load(phenotype.path)

  # create a training set: rmv the observed phenotypes of some individuals
  whichNA = input$test.subject
  YNA = y
  YNA[whichNA] = NA
  # write the training set for gemma
  train.phenotype.path = paste0(data.path, 'gemma_train_phenotype_', input$phenotypeID, '.txt')
  write(YNA, file=train.phenotype.path, ncolumns=1);


 
  
  # load in the dataset
  #X = input$X
  #y = input$y
  
  # create a test dataset
  #whichNa = input$row.test
  #yNa = y
  #yNa[whichNa] = NA

  # defaul setting for bslmm (see manual for gemma)
  #bslmm = 1
    
  # user-specified setting for gemma
  if(!is.null(args$bslmm)){
	bslmm = args$bslmm
  }else{
	bslmm = 1 # continuous trait
  }
  if(!is.null(args$w)){
	w = args$w
  }else{
	w = 1000
  }
  if(!is.null(args$s)){
        s = args$s
  }else{
        s = 10000
  }

  # fit the model by gemma (binary exe)
  
  # step 1: write (Xtrn, ytrn) to txt files and save them in a format as gemma required
  #write.table(X, file="genotype.txt")
  #write.table(yNa, file="phenotype.txt", row.names=FALSE, col.names=FALSE)
  
  # step 2: make a system command to fit bslmm model in gemma
  # turn off all the snp filters
  model_fitting_command = "./gemma -o result"
  # specify the training data
  model_fitting_command = paste(model_fitting_command, "-g", genotype.path, "-p", train.phenotype.path)
  #
  # run gemma to fit the model
  system(model_fitting_command)
  trait_predict_command = "./gemma -g genotype.txt -p phenotype.txt -epm ./output/result.param.txt -emu ./output/result.log.txt -predict -o prdt"
  
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
