rrblup.wrapper = function(input, args){
  
  # load dataset
  data.name = input$data.name
  data.path = paste0('datamakers/', data.name, '/')
  
  ## genotype data 
  genotype.path = paste0(data.path, 'genotype.RData')
  load(genotype.path)
  
  ## phenotype data
  phenotype.path = paste0(data.path, 'phenotype_', input$phenotype.id, '.RData')
  load(phenotype.path)
  
  observedID = names(y)
  Y = y
  X = x[rownames(x) %in% observedID, ]
  if (prod(names(Y) == names(X)) == 0)
    stop("individuals are not the same in genotype and phenotype")
  
  # recode biallelic SNP as [aa, Aa, AA]=[-1, 0, 1]
  G = 2*X - 1
  
  # compute additive relationship matrix
  A = rrBLUP::A.mat(G)
  if (prod(rownames(A) == names(y)) == 0)
    stop("individuals are not the same in relatedness and phenotype")
  
  # assemble phenotypes and genotype IDs into a data frame
  test = input$test.subject
  y[test] = NA # simply mask phenotypes in the test set
  df = data.frame(y=y, gid=observedID)
  results = rrBLUP::kin.blup(df, K=A, geno="gid", pheno="y")
  
  # output the posterior mean as predicted value
  y.test.predict = results$g[test]
  return(list(predict=y.test.predict)) 
}