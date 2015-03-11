# write phenotype vector
load("phenotype_1.RData")
write(y, file="gemma_phenotype_1.txt", ncolumns=1)
rm(y)

load("phenotype_2.RData")
write(y, file="gemma_phenotype_2.txt", ncolumns=2)
rm(y)

load("phenotype_3.RData")
write(y, file="gemma_phenotype_3.txt", ncolumns=3)
rm(y)

load("phenotype_4.RData")
write(y, file="gemma_phenotype_4.txt", ncolumns=4)
rm(y)

# write mean genotype matrix, delimited by comma
# row: SNPs; columns: individuals
load("genotype.RData")
write(x, file='geno.txt', ncolumns=dim(x)[1], sep=',')
rsid = paste0(rep('rs', dim(x)[2]), 1:dim(x)[2])
write(rsid, file='rsid.txt')
majo = rep('A', dim(x)[2])
write(majo, file='majo.txt')
mino = rep('C', dim(x)[2])
write(mino, file='mino.txt')
rm(x)

# use linux command to combine text files by columns
system('paste -d"," rsid.txt mino.txt majo.txt geno.txt > gemma_genotype.txt')
system('gzip gemma_genotype.txt')
system('rm geno.txt rsid.txt mino.txt majo.txt')

