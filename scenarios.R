sourceDir("datamakers")
scenarios=list()

#Now, for each scenario create an element of scenarios of the following form
#scenarios[[1]]=list(name="",fn=,args,seed=1:100)

args_eg1 = list(data.mode="insilico", test.size=100, total.size=600, residual.var=4, num.allsnp=1000, num.causal=10)
args_eg2 = list(data.mode="wheat", test.size=100, column.id=1)

scenarios[[1]]=list(name="example_1", fn=datamaker, args=args_eg1, seed=1:50)
scenarios[[2]]=list(name="example_2", fn=datamaker, args=args_eg2, seed=1:50)
