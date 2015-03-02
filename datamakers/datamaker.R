#define your datamaker functions in .R files in the datamaker subdirectory
#each datamaker should take input seed (integer) and args (list), and output a list with names elements meta and input
#the format of the meta and input elements should be defined in the README

datamaker = function(args){

  #here insert the meat of the function that needs to be defined for each dsc to be done
  #Your function should define the variables meta (a list) and input (a list)
 
  Ntst = args$test.size # test sample size
  Dmod = args$data.mode # types of genotypes/phenotypes data: simulated or real
  Tmod = args$tool.mode # types of software packages: R or binary exe

  # 1. prep genotype/phenotype (design matrix/response vector)

  if(Dmod=="indep"){
	library(varbvs)
	Ntol = args$total.size   # total sample size
	resv = args$residual.var # residual variance
	Nsnp = args$num.allsnp 	 # total number of snps 
	Ncau = args$num.causal 	 # total number of causal variants

	snps = create.snps(Nsnp, Ncau)
	data = create.data(snps$maf, snps$beta, resv, Ntol)

	X = data$X # genotype matrix
	y = data$y # phenotype vector
	Z = NULL   # relatedness matrix
  }

  if(Dmod=="wheat"){
	library(BLR)
	data(wheat)
	envrt.id = args$column.id # pick one environment (four available)
	
	X = X		    # genotype matrix
	y = Y[, envrt.id]   # phenotype matrix
	Z = A		    # relatedness matrix
  }

  if(Tmod=="rtool" & Dmod=="mouse"){
	trait.id = args$column.id # pick one trait (CD8+ or MCH)

	# phenotype vector
	traits = as.matrix(data.table::fread("mouse/mouse_hs1940.pheno.txt"))
	trait = traits[, trait.id]
	NonNAindex = which(!is.na(trait))
	y = trait[NonNAindex]

	# relatedness matrix
	cXX = as.matrix(read.table("mouse/mouse_hs1940.cXX.txt"))
	Z = cXX[NonNAindex, NonNAindex] 

	# genotype matrix
	mean.genotype = read.table(gzfile("mouse/mouse_hs1940.geno.txt.gz"), sep=",", colClasses=c(rep("character", 3), rep("numeric", 1940)))
	mean.genotype.only = mean.genotype[, 4:1943]
	
	
  }

  if(Tmod=="rtool" & Dmod=="piggy"){

  }
  
  # 2. aggregate output args
  meta = list(X.test=Xtst, y.test=ytst);
  input = list(X.train=Xtrn, y.train=ytrn);  
    
  #end of meat of function
  
  data = list(meta=meta,input=input)
  
  return(data)

}
