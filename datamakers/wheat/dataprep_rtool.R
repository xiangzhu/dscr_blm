library(BLR)
data(wheat)

y = Y[, 1] 
save(y, file = "phenotype_1.RData")
rm(y)

y = Y[, 2]
save(y, file = "phenotype_2.RData")
rm(y)

y = Y[, 3]
save(y, file = "phenotype_3.RData")
rm(y)

y = Y[, 4]
save(y, file = "phenotype_4.RData")
rm(y)

x = X; rownames(x) = rownames(Y)
save(x, file = "genotype.RData")

z = A;
save(z, file = "relatedness.RData")



