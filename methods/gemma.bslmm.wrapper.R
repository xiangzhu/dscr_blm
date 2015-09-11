gemma.bslmm.wrapper = function(input, args){
	
  # locate the dataset
  data.name = input$data.name
  data.path = paste0('datamakers/', data.name, '/')

  genotype.path = paste0(data.path, 'gemma_genotype_', input$phenotype.id, '.txt.gz')

  phenotype.path = paste0(data.path, 'phenotype_', input$phenotype.id, '.RData')
  load(phenotype.path)

  # create a training set and a test set
  whichNA = input$test.subject
  YNA = y
  YNA[whichNA] = NA
  y.test.true = y[whichNA]
  
  # write the training set for gemma
  train.phenotype.path = paste0(data.path, 'gemma_train_phenotype_', input$phenotype.id, '.txt')
  write(YNA, file=train.phenotype.path, ncolumns=1);

  # default setting for gemma-bslmm
  bslmm = 1 # continuous trait
  w = 100000 # burn-in
  s = 1000000 # total length of chain
  rpace = 10 # recording space 
  
  # user-specified setting for gemma-bslmm
  if(!is.null(args$bslmm)) bslmm = args$bslmm
  if(!is.null(args$w)) w = args$w
  if(!is.null(args$s)) s = args$s
  if(!is.null(args$rpace)) rpace = args$rpace
  
  # fit bslmm model using training set
  # turn off all the snp filters
  model_fitting_command = "methods/gemma -o result -notsnp"
  # specify the model type
  model_fitting_command = paste(model_fitting_command, "-bslmm", as.character(bslmm))
  # specify the training data
  model_fitting_command = paste(model_fitting_command, "-g", genotype.path, "-p", train.phenotype.path)
  # specify the length of simulated chain
  model_fitting_command = paste(model_fitting_command, "-w", as.character(w), "-s", as.character(s), "-rpace", as.character(rpace))
  # run gemma to fit the model
  system(model_fitting_command)
  
  # predict traits for the test set  
  train_predict_command = "methods/gemma -o result -notsnp -epm ./output/result.param.txt -emu ./output/result.log.txt -predict 1"
  train_predict_command = paste(train_predict_command, "-g", genotype.path, "-p", train.phenotype.path)
  system(train_predict_command)
  
  # extract the useful info and delete the files/directories
  gemma.prdt = read.table('output/result.prdt.txt')
  y.test.predict = gemma.prdt[!is.na(gemma.prdt)]

  # rmv training set and output directory
  status = file.remove(train.phenotype.path)
  system('rm -rf output')
  
  return(list(predict=y.test.predict))   
}
