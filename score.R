#This file should define your score function

score = function(data, output){
#insert calculations here; return a named list of results
  true.value = data$meta$true.value
  predict = output$predict
  mean_squared_error = mean( (true.value - predict)^2 )
  mean_absolute_error = mean( abs(true.value - predict) )
  return(list(mean_squared_error=mean_squared_error, mean_absolute_error=mean_absolute_error))
}

addScore(dsc_osl,score)
