#define your datamaker functions in .R files in the datamaker subdirectory
#each datamaker should take input seed (integer) and args (list), and output a list with names elements meta and input
#the format of the meta and input elements should be defined in the README

datamaker = function(seed,args){

  set.seed(seed)
  
  #here insert the meat of the function that needs to be defined for each dsc to be done
  #Your function should define the variables meta (a list) and input (a list)
 
  Ntst = args$test.size # test sample size
  Dmod = args$data.mode # types of genotypes/phenotypes data: simulated or real

  # 1. prep genotype/phenotype (design matrix/response vector)
  if(Dmod=="insilico"){
	library(varbvs)
	Ntol = args$total.size
	resd = args$residual.sd
	Nsnp = args$num.allsnp
	Ncau = args$num.causal
	snps = create.snps(Nsnp, Ncau)
	data = create.data(snps$maf, snps$beta, resd, N)

	X = data$X
	y = data$y

	Ntrn = Ntol - Ntst
	if(Ntrn <= 0) stop("training sample should contain at least one individual!")
	
	Xtrn = X[1:Ntrn, ]
	Xtst = X[(Ntrn+1):Ntol, ]

	ytrn = y[1:Ntrn]
	ytst = y[(Ntrn+1):Ntol]

  }

  if(Dmod=="wheat"){
	library(BLR)
	data(wheat)
	Envr = args$column.id
	
	X = X
	y = Y[, Envr]

	Itst = sample(1:length(y), size=Ntst, replace=FALSE)
	Itrn = setdiff(1:length(y), Itst)

	Xtrn = X[Itrn, ]
	Xtst = X[Itst, ]

	ytrn = y[Itrn]
	ytst = y[Itst]

  }

  
  # 2. aggregate output args
  meta = list(X.test=Xtst, y.test=ytst);
  input = list(X.train=Xtrn, y.train=ytrn);  
    
  #end of meat of function
  
  data = list(meta=meta,input=input)
  
  return(data)

}
