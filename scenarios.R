source_dir("datamakers")

args_eg1 = list(data.name="wheat",test.size=100,phenotype.id=1)
add_scenario(dsc_blm,name="wheat",datamaker,args=args_eg1,seed=1:20)

