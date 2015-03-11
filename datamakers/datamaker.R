#define your datamaker functions in .R files in the datamaker subdirectory
#each datamaker should take input seed (integer) and args (list), and output a list with names elements meta and input
#the format of the meta and input elements should be defined in the README

datamaker = function(args){

  #here insert the meat of the function that needs to be defined for each dsc to be done
  #Your function should define the variables meta (a list) and input (a list)
 
  test.size = args$test.size # test sample size
  data.name = args$data.name # name of data set
  phenotype.id = args$phenotype.id # id of phenotype

  phenotype.path = paste0('datamaker/', data.name, '/', 'phenotype_', phenotype.id, '.RData')
  load(phenotype.path)
  total.size = length(y)	
  if(test.size >= total.size){
	test.size = total.size - 1
	warning("test sample size is adjusted: total sample size minus 1")
  }
  test.subject = sample(1:total.size, size=test.size, replace=FALSE)
  y.test.true = y[test.subject]	

  input = list(data.name=data.name, phenotype.id=phenotype.id, test.subject=test.subject)
  meta = list(true.value = y.test.true)
      
  #end of meat of function
  
  data = list(meta=meta,input=input)
  
  return(data)

}
