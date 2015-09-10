datamaker = function(args){
  
  test.size = args$test.size # test sample size
  data.name = args$data.name # name of data set
  phenotype.id = args$phenotype.id # id of phenotype

  # randomly partition data into training and test set
  phenotype.path = paste0('datamakers/', data.name, '/', 'phenotype_', phenotype.id, '.RData')
  load(phenotype.path)
  total.size = length(y)	
  if(test.size >= total.size){
	test.size = total.size - 1
	warning("test sample size is adjusted: total sample size minus 1")
  }
  test.subject = sort(sample(1:total.size, size=test.size, replace=FALSE))
  y.test.true = y[test.subject]	

  input = list(data.name=data.name, phenotype.id=phenotype.id, test.subject=test.subject)
  meta = list(true.value = y.test.true)
      
  data = list(meta=meta,input=input)
  
  return(data)

}
