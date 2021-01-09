library(tidyverse)

forw_selc_R2<- function(data,predicted,max_iter,imp_treshold) {
  
  #Start iteration variables in default or null states
  r2_current<-0
  each_selected_model <- data.frame(Features=character(),R2=numeric(),AIC=numeric())
  rest_features <- names(data %>% select(-predicted))
  existing_features <- c()
  iter_number<-0
  completed = FALSE
  
  #Forward selection continues until no added feature improves R2 
  while(completed==FALSE & iter_number<=max_iter)
  {
    #Increase the iteration 
    iter_number<-iter_number+1
    
    #Nullify iter_scores
    iter_scores <- data.frame(Feature=character(),R2=numeric(),AIC=numeric(),stringsAsFactors=FALSE)
    
    #Test each of the rest of the variables adding to the model by R2 square increases
    #Add if condition is sustained
    for(i in 1:length(rest_features)) {
      #Train the model with existing + iteration features
      existing_feat <- paste(existing_features,sep="",collapse=" + ")
      mdl_func <- as.formula(paste(predicted, paste(existing_feat, rest_features[i], sep= " + "), sep = " ~ "))
      mdl<-lm(mdl_func, data=data)
      #Append the feature name, R squared, and AIC
      iter_scores[nrow(iter_scores)+1,] <- list(rest_features[i],summary(mdl)$r.squared,AIC(mdl))
    }
    #Sort descending by R squared
    iter_scores <- iter_scores %>% arrange(desc(R2))
    
    #If R squared has improved, add to the model variables
    if (iter_scores[1,"R2"] > r2_current + imp_treshold) {
      #Print the new best added feature line 
      cat("\nThe best feature of the iteration",iter_number, "\n")
      print(iter_scores[1,])
      existing_features <- append(existing_features,iter_scores[1,1])
      rest_features <- rest_features[!rest_features %in% iter_scores[1,1]]
      r2_current=iter_scores[1,2]
      #Since we came up with a new favorite model, we'll save its details.
      each_selected_model[nrow(each_selected_model)+1,] <- list(paste(existing_features,sep="",collapse=", "),r2_current,iter_scores[1,3])
      cat("\nCurrent model\n")
      print(each_selected_model[nrow(each_selected_model),])
    } else {
      #Break the loop
      completed = TRUE
      cat("\nR squared score does not increase at least by 0.00001 anymore by adding features, the best model by forward selection is found.\n")
    }
  }
  
  return(each_selected_model)
}
