score = function(data, output){

  # known truth: observed phenotypes in the test set
  true.value = data$meta$true.value
  
  # predicted phenotypes 
  predict = output$predict
  
  # mean square error (mse)
  mse = mean((true.value-predict)^2)
  
  # root mean square error (rmse)
  rmse = sqrt(mean((true.value-predict)^2))
  
  # pearson correlation
  pcor = cor(predict, true.value)
  
  # simple regression slope
  slope = lm(true.value~predict)$coef[2]
  
  return(list(mse=mse, rmse=rmse, pcor=pcor, slope=slope))
}

add_score(dsc_blm,score)