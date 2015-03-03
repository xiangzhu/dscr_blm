# write phenotype vector
write(y, file="gemma_phenotype_1.txt", ncolumns=1)

# write mean genotype matrix, delimited by comma
# row: SNPs; columns: individuals
write(x, file='geno.txt', ncolumns=dim(x)[1], sep=',')
rsid = paste0(rep('rs', dim(x)[2]), 1:dim(x)[2])
write(rsid, file='rsid.txt')
majo = rep('A', dim(x)[2])
write(majo, file='majo.txt')
mino = rep('C', dim(x)[2])
write(mino, file='mino.txt')	

# use linux command to combine text files by columns
system('paste -d"," rsid.txt mino.txt majo.txt geno.txt > gemma_genotype.txt')
system('gzip gemma_genotype.txt')
system('rm geno.txt rsid.txt mino.txt majo.txt')

# generate a training set by setting some obsverations as NA
yNa = y
yNa[whichNA] = NA
write(yNa, file="gemma_phenotype_1_train.txt", ncolumns=1);

# fit bslmm on the training set
../bin/gemma -g mouse_hs1940.geno.txt.gz -p mouse_hs1940.pheno.txt -n 2 -a mouse_hs1940.anno.txt -bslmm -o mouse_hs1940_CD8_bslmm -w 1000 -s 10000 -seed 1

# generate the relatedness matrix based on training set
../bin/gemma -g mouse_hs1940.geno.txt.gz -p mouse_hs1940.pheno.txt -n 2 -a mouse_hs1940.anno.txt -gk 1 -o mouse_hs1940_CD8_train

# do prediction based on estimated breeding values: need the relatedness matrix
../bin/gemma -g mouse_hs1940.geno.txt.gz -p mouse_hs1940.pheno.txt -n 2 -epm ./output/mouse_hs1940_CD8_bslmm.param.txt -emu ./output/mouse_hs1940_CD8_bslmm.log.txt -ebv ./output/mouse_hs1940_CD8_bslmm.bv.txt -k ./output/mouse_hs1940_CD8_train.cXX.txt -predict -o mouse_hs1940_CD8_prdt_k

# do prediction based on estimated alphas: do not need the relatedness matrix
../bin/gemma -g mouse_hs1940.geno.txt.gz -p mouse_hs1940.pheno.txt -n 2 -epm ./output/mouse_hs1940_CD8_bslmm.param.txt -emu ./output/mouse_hs1940_CD8_bslmm.log.txt -predict -o mouse_hs1940_CD8_prdt

